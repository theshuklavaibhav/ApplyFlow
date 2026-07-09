import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/job_application.dart';
import '../providers/job_provider.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class AddEditJobScreen extends StatefulWidget {
  final JobApplication? exisitingJob;
  const AddEditJobScreen({super.key, this.exisitingJob});

  @override
  State<AddEditJobScreen> createState() => _AddEditJobScreenState();
}

class _AddEditJobScreenState extends State<AddEditJobScreen> {
  late TextEditingController _companyController;
  late TextEditingController _roleController;
  late TextEditingController _locationController;
  late TextEditingController _jobUrlController;
  late TextEditingController _notesController;
  String _status = 'WISHLIST';
  DateTime? _appliedDate;
  bool _isSaving = false;

  final _statusList = ['WISHLIST', 'APPLIED', 'INTERVIEW', 'OFFER', 'REJECTED'];

  @override
  void initState() {
    super.initState();
    final job = widget.exisitingJob;
    _companyController = TextEditingController(text: job?.company ?? '');
    _roleController = TextEditingController(text: job?.roleTitle ?? '');
    _locationController = TextEditingController(text: job?.location ?? '');
    _jobUrlController = TextEditingController(text: job?.jobUrl ?? '');
    _notesController = TextEditingController(text: job?.notes ?? '');
    _status = job?.status ?? 'WISHLIST';
    _appliedDate = job?.appliedDate;
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _locationController.dispose();
    _jobUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_companyController.text.trim().isEmpty ||
        _roleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Company and role are required'),
          backgroundColor: AppColors.rejectedColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final job = JobApplication(
      id: widget.exisitingJob?.id ?? '',
      company: _companyController.text.trim(),
      roleTitle: _roleController.text.trim(),
      location: _locationController.text.trim(),
      jobUrl: _jobUrlController.text.trim(),
      notes: _notesController.text.trim(),
      status: _status,
      appliedDate: _appliedDate,
      createdAt: widget.exisitingJob?.createdAt ?? DateTime.now(),
    );

    try {
      final provider = context.read<JobProvider>();
      if (widget.exisitingJob == null) {
        await provider.addJob(job);
      } else {
        await provider.updateJob(widget.exisitingJob!.id, job);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save failed: $e'),
            backgroundColor: AppColors.rejectedColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _appliedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.purple,
            onPrimary: Colors.white,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _appliedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.exisitingJob != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'Edit Application' : 'New Application',
          style: AppText.titleMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _isSaving ? null : _save,
              child: Text(
                'Save',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _isSaving ? AppColors.textMuted : AppColors.purple,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Company avatar preview
            Center(
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.statusGradient(_status),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.statusColor(_status).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _companyController.text.isNotEmpty
                        ? _companyController.text[0].toUpperCase()
                        : '?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _label('Company *'),
            TextField(
              controller: _companyController,
              onChanged: (_) => setState(() {}), // refresh avatar
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary, fontSize: 14,
              ),
              decoration: const InputDecoration(hintText: 'e.g. Razorpay'),
            ),
            const SizedBox(height: 16),

            _label('Role *'),
            TextField(
              controller: _roleController,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary, fontSize: 14,
              ),
              decoration: const InputDecoration(hintText: 'e.g. SDE-1 Backend'),
            ),
            const SizedBox(height: 20),

            _label('Status'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _statusList.map((s) {
                final isSelected = _status == s;
                final color = AppColors.statusColor(s);
                return GestureDetector(
                  onTap: () => setState(() => _status = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.statusGradient(s) : null,
                      color: isSelected ? null : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : AppColors.border,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ] : null,
                    ),
                    child: Text(
                      s[0] + s.substring(1).toLowerCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Applied date'),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 16, color: AppColors.textMuted),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _appliedDate != null
                                      ? DateFormat('dd MMM yyyy').format(_appliedDate!)
                                      : 'Select date',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: _appliedDate != null
                                        ? AppColors.textPrimary
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Location'),
                      TextField(
                        controller: _locationController,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary, fontSize: 13,
                        ),
                        decoration: const InputDecoration(hintText: 'e.g. Noida'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _label('Job URL'),
            TextField(
              controller: _jobUrlController,
              keyboardType: TextInputType.url,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary, fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: 'https://...',
                prefixIcon: Icon(Icons.link, color: AppColors.textMuted, size: 18),
              ),
            ),
            const SizedBox(height: 16),

            _label('Notes'),
            TextField(
              controller: _notesController,
              maxLines: 4,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary, fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: 'Referral contact, prep notes, recruiter name...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            GradientButton(
              label: isEditing ? 'Update Application' : 'Save Application',
              onTap: _save,
              isLoading: _isSaving,
              gradient: AppColors.statusGradient(_status),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: AppText.labelMedium),
  );
}
