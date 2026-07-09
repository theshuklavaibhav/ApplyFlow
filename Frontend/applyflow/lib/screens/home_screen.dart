import 'dart:ui';
import 'package:applyflow/screens/add_edit_job_screen.dart';
import 'package:applyflow/screens/ai_screen.dart';
import 'package:applyflow/screens/analytics_screen.dart';
import 'package:applyflow/screens/job_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/auth_provider.dart';
import '../providers/job_provider.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().fetchJobs();
    });
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _firstName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'there';
    return fullName.split(' ').first;
  }

  
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final jobs = context.watch<JobProvider>();
    final total = jobs.jobsList.length;
    final interviews = jobs.interviewCount;
    final offers = jobs.offerCount;
    final interviewRate = total > 0 ? (interviews / total) : 0.0;
    final offerRate = interviews > 0 ? (offers / interviews) : 0.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: AppColors.bg,
            title: Row(
              children: [
                ShaderMask(
                  shaderCallback: (b) => AppColors.purpleGradient.createShader(b),
                  child: Text('ApplyFlow',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () => _showProfile(context, auth),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.purpleGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _firstName(auth.currentUser?.fullName).isNotEmpty
                          ? _firstName(auth.currentUser?.fullName)[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Greeting ──────────────────────────────
                Text(
                  '${_greeting()} 👋',
                  style: AppText.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  _firstName(auth.currentUser?.fullName),
                  style: AppText.displayLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Let's land that offer today.",
                  style: AppText.bodyMedium,
                ),
                const SizedBox(height: 24),

                // ── Hero progress card ────────────────────
                GlassCard(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.purple.withOpacity(0.3),
                      AppColors.pink.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderColor: AppColors.purple.withOpacity(0.3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Career Progress',
                              style: AppText.labelMedium,
                            ),
                            const SizedBox(height: 6),
                            ShaderMask(
                              shaderCallback: (b) => AppColors.purpleGradient.createShader(b),
                              child: Text(
                                '$total Applications',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$interviews interviews · $offers offers',
                              style: AppText.bodySmall,
                            ),
                            const SizedBox(height: 16),
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: offerRate.clamp(0.0, 1.0),
                                minHeight: 6,
                                backgroundColor: AppColors.border,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${(offerRate * 100).toInt()}% offer rate from interviews',
                              style: AppText.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      CircularPercentIndicator(
                        radius: 48,
                        lineWidth: 7,
                        percent:(total > 0 ? (interviews / total) : 0).clamp(0.0, 1.0).toDouble(),
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(interviewRate * 100).toInt()}%',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16, fontWeight: FontWeight.w800,
                                color: AppColors.purple,
                              ),
                            ),
                            Text('rate', style: AppText.bodySmall),
                          ],
                        ),
                        progressColor: AppColors.purple,
                        backgroundColor: AppColors.purple.withOpacity(0.15),
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Stat cards grid ───────────────────────
                Row(
                  children: [
                    Expanded(
                      child: GradientStatCard(
                        label: 'Applied',
                        value: '${jobs.appliedCount}',
                        subtitle: 'applications',
                        gradient: AppColors.cyanGradient,
                        icon: Icons.send_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GradientStatCard(
                        label: 'Interview',
                        value: '${jobs.interviewCount}',
                        subtitle: 'scheduled',
                        gradient: AppColors.orangeGradient,
                        icon: Icons.people_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GradientStatCard(
                        label: 'Offers',
                        value: '${jobs.offerCount}',
                        subtitle: 'received',
                        gradient: AppColors.greenGradient,
                        icon: Icons.celebration_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GradientStatCard(
                        label: 'Total',
                        value: '$total',
                        subtitle: 'tracked',
                        gradient: AppColors.purpleGradient,
                        icon: Icons.track_changes_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Quick action chips ────────────────────
                const SectionHeader(title: 'Quick actions'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ActionChip(
                      icon: Icons.add_circle_outline,
                      label: 'Add Application',
                      color: AppColors.purple,
                      onTap: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AddEditJobScreen())
                     ) ; 
                      },
                    ),
                    _ActionChip(
                      icon: Icons.auto_awesome_outlined,
                      label: 'AI Career Copilot',
                      color: AppColors.pink,
                      onTap: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AiScreen())
                     ) ; 
                      },
                    ),
                    _ActionChip(
                      icon: Icons.bar_chart_outlined,
                      label: 'View Analytics',
                      color: AppColors.cyan,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AnalyticsScreen())
                        ) ; 
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Recent applications ───────────────────
                SectionHeader(
                  title: 'Recent applications',
                  action: 'See all',
                  onAction: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => JobListScreen())
                     ) ; 
                  },
                ),
                const SizedBox(height: 12),
                if (jobs.isLoading)
                  const JobCardShimmer()
                else if (jobs.jobsList.isEmpty)
                  EmptyState(
                    title: 'Your career journey starts here',
                    subtitle: 'Add your first application to begin tracking your path to the perfect role.',
                    onAction: () {},
                    actionLabel: 'Add Application',
                  )
                else
                  ...jobs.jobsList.take(3).map((job) => JobCard(
                    job: job,
                    onTap: () {},
                  )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context, AuthProvider auth) {
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
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (auth.currentUser?.fullName ?? '?')[0].toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(auth.currentUser?.fullName ?? '', style: AppText.titleLarge),
            Text(auth.currentUser?.email ?? '', style: AppText.bodyMedium),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Sign out',
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFEC4899)],
              ),
              onTap: () {
                Navigator.pop(context);
                auth.logout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.plusJakartaSans(
              fontSize: 12, fontWeight: FontWeight.w600, color: color,
            )),
          ],
        ),
      ),
    );
  }
}
