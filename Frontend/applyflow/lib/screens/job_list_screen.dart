import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/job_provider.dart';
import '../utils/constants.dart';
import '../widgets/job_card.dart';
import '../widgets/stat_card.dart';
import '../screens/add_edit_job_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final List<String> _filters = [
    'ALL',
    'APPLIED',
    'INTERVIEW',
    'OFFER',
    'REJECTED',
  ];
  @override
  void initState() {
    super.initState();
    // Fetch All Movement this screen loads -- runs once, not on every rebuild
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<JobProvider>().fetchJobs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => jobProvider.fetchJobs(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsGeometry.fromLTRB(18, 16, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your applications',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),

                          GestureDetector(
                            onTap: () => _showLogoutMenu(context, authProvider),
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: AppColors.ink,
                              child: Text(
                                _initials(
                                  authProvider.currentUser?.fullName ?? '?',
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          StatCard(
                            lable: 'Applied',
                            count: jobProvider.appliedCount,
                            color: AppColors.applied,
                          ),
                          const SizedBox(width: 8),
                          StatCard(
                            lable: 'Interview',
                            count: jobProvider.interviewCount,
                            color: AppColors.interview,
                          ),
                          const SizedBox(width: 8),
                          StatCard(
                            lable: 'Offer',
                            count: jobProvider.offerCount,
                            color: AppColors.offer,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 32,
                        child: ListView.separated(
                          itemCount: _filters.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 6),
                          itemBuilder: (context, i) {
                            final filter = _filters[i];
                            final isActive = jobProvider.activeFilter == filter;
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: null,
                                child: Text(
                                  filter == 'All'
                                      ? 'All'
                                      : filter[0] +
                                            filter.substring(1).toLowerCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              // Loading, empty, or list states
              if (jobProvider.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (jobProvider.jobsList.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.input_outlined,
                          size: 40,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No application yet',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const Text(
                          'Tap + to add your first one.',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final job = jobProvider.jobsList[index];
                      return JobCard(
                        job: job,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditJobScreen(
                              // existingJob: job
                            ),
                          ),
                        ),
                      );
                    }, childCount: jobProvider.jobsList.length),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditJobScreen())
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split('');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0][0].toUpperCase() : '?';
  }

  void _showLogoutMenu(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: ListTile(
          leading: Icon(Icons.logout, color: AppColors.rejected),
          title: Text("Logout"),
          onTap: () {
            Navigator.pop(context);
            auth.logout();
          },
        ),
      ),
    );
  }
}
