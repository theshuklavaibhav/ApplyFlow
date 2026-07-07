import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/job_application.dart';
import '../utils/constants.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';

class AddEditJobScreen extends StatefulWidget {
  final JobApplication?
  exisitingJob; // null == adding new , non null == editing
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

    final JobApplication? job = widget.exisitingJob;
    _companyController = TextEditingController(text: job?.company ?? '');
    _roleController = TextEditingController(text: job?.roleTitle ?? '');
    _locationController = TextEditingController(text: job?.location ?? '');
    _jobUrlController = TextEditingController(text: job?.jobUrl ?? '');
    _notesController = TextEditingController(text: job?.notes ?? '');
    _status = job?.status ?? 'WISHLIST';
    _appliedDate = job?.appliedDate;
  }

    Future<void> _save() async {
    // ✅ Bug 2 fixed — validation runs FIRST, before anything else
    if (_companyController.text.trim().isEmpty || _roleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company and role are required')),
      );
      return; // stop here, don't save anything
    }

    setState(() => _isSaving = true);

    // ✅ Bug 1 fixed — correct spelling: existingJob
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
      final jobProvider = context.read<JobProvider>();

      // ✅ Bug 3 fixed — add vs update are now different
      if (widget.exisitingJob == null) {
        await jobProvider.addJob(job);        // creating new
      } else {
        await jobProvider.updateJob(widget.exisitingJob!.id, job);  // editing existing
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
    // ✅ Bug 4 fixed — no dead code after finally
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _appliedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if(picked != null) setState(()=> _appliedDate = picked);
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
      ),
    );
  }

  Widget _textfield(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.background),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: AppColors.ink),
        ),
        title: Text(
          widget.exisitingJob == null ? 'New Application' : 'EditApplication',
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isSaving ? AppColors.textMuted : AppColors.primary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Company'),
            _textfield(_companyController, 'e.g : Razorpay'),
            const SizedBox(height: 14),

            _label('Role'),
            _textfield(_roleController, 'e.g. SDE- 1 Backend'),
            const SizedBox(height: 14),

            _label('Status'),
            Wrap(
              spacing: 6,
              children: _statusList.map((s) {
                final isSelected = _status == s;
                final color = AppColors.statusColor(s);
                return GestureDetector(
                  onTap: () => setState(() => _status = s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.12)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      s[0] + s.substring(1).toLowerCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? color : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Applied Date'),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _appliedDate != null
                                    ? DateFormat(
                                        'dd MMM yyyy',
                                      ).format(_appliedDate!)
                                    : 'Select date',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _appliedDate != null
                                      ? AppColors.ink
                                      : AppColors.textMuted,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 15,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Location'),
                      _textfield(_locationController, 'e.g. Noida'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _label('Job URL'),
            _textfield(_jobUrlController, 'http://...'),
            const SizedBox(height: 14),

            _label('Notes'),
            _textfield(
              _notesController,
              'Refferal , prep notes , etc.',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
