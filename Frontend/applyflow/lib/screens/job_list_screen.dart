import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';
import 'add_edit_job_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final _filters = ['All', 'WISHLIST', 'APPLIED', 'INTERVIEW', 'OFFER', 'REJECTED'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().fetchJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    // local search filter on top of server filter
    final filtered = _searchQuery.isEmpty
        ? jobProvider.jobsList
        : jobProvider.jobsList.where((j) =>
            j.company.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            j.roleTitle.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Applications', style: AppText.displayMedium),
                  Text(
                    '${jobProvider.jobsList.length} total tracked',
                    style: AppText.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search company or role...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 14, color: AppColors.textMuted,
                        ),
                        prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close, color: AppColors.textMuted, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Filter chips
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final f = _filters[i];
                        final isActive = jobProvider.activeFilter == f;
                        final color = f == 'All'
                            ? AppColors.purple
                            : AppColors.statusColor(f);
                        return GestureDetector(
                          onTap: () => jobProvider.setFilter(f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: isActive ? AppColors.purpleGradient : null,
                              color: isActive ? null : AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isActive
                                    ? Colors.transparent
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              f == 'All' ? 'All' : f[0] + f.substring(1).toLowerCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isActive ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),

            // ── List ─────────────────────────────────────
            Expanded(
              child: jobProvider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: JobCardShimmer(),
                    )
                  : filtered.isEmpty
                      ? EmptyState(
                          title: _searchQuery.isNotEmpty
                              ? 'No results found'
                              : 'No applications yet',
                          subtitle: _searchQuery.isNotEmpty
                              ? 'Try a different search term'
                              : 'Tap the + button to add your first application',
                          onAction: _searchQuery.isEmpty ? () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddEditJobScreen()),
                          ) : null,
                          actionLabel: 'Add Application',
                        )
                      : RefreshIndicator(
                          onRefresh: () => jobProvider.fetchJobs(),
                          color: AppColors.purple,
                          backgroundColor: AppColors.surface,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: filtered.length,
                            itemBuilder: (context, i) {
                              final job = filtered[i];
                              return JobCard(
                                job: job,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddEditJobScreen(exisitingJob: job),
                                  ),
                                ),
                                onDelete: () => _confirmDelete(context, jobProvider, job.id),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, JobProvider provider, String id) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.border, borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.rejectedColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline, color: AppColors.rejectedColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text('Delete application?', style: AppText.titleLarge),
            const SizedBox(height: 8),
            Text(
              'This cannot be undone.',
              style: AppText.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Delete',
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFEC4899)],
              ),
              onTap: () {
                Navigator.pop(context);
                provider.deleteJob(id);
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.plusJakartaSans(
                color: AppColors.textSecondary,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
