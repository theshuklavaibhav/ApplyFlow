import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/job_provider.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobs = context.watch<JobProvider>();
    final total = jobs.jobsList.length;
    final applied = jobs.appliedCount;
    final interviews = jobs.interviewCount;
    final offers = jobs.offerCount;
    final rejected = jobs.jobsList.where((j) => j.status == 'REJECTED').length;
    final wishlist = jobs.jobsList.where((j) => j.status == 'WISHLIST').length;

    final interviewRate = total > 0 ? interviews / total : 0.0;
    final offerRate = interviews > 0 ? offers / interviews : 0.0;
    final responseRate = total > 0 ? (interviews + offers) / total : 0.0;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.bg,
              title: Text('Analytics', style: AppText.displayMedium),
              centerTitle: false,
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // ── Funnel overview ───────────────────────
                  const SectionHeader(title: 'Application funnel'),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Column(
                      children: [
                        _FunnelRow(label: 'Total tracked', value: total,
                            color: AppColors.purple, max: total),
                        _FunnelRow(label: 'Applied', value: applied,
                            color: AppColors.blue, max: total),
                        _FunnelRow(label: 'Interview', value: interviews,
                            color: AppColors.orange, max: total),
                        _FunnelRow(label: 'Offer', value: offers,
                            color: AppColors.green, max: total),
                        _FunnelRow(label: 'Rejected', value: rejected,
                            color: AppColors.rejectedColor, max: total),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Rate cards ────────────────────────────
                  const SectionHeader(title: 'Key metrics'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CircularProgressCard(
                          label: 'Interview\nRate',
                          percent: interviewRate,
                          color: AppColors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CircularProgressCard(
                          label: 'Offer\nRate',
                          percent: offerRate,
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CircularProgressCard(
                          label: 'Response\nRate',
                          percent: responseRate,
                          color: AppColors.cyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Pie chart ─────────────────────────────
                  if (total > 0) ...[
                    const SectionHeader(title: 'Status breakdown'),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 180,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 3,
                                centerSpaceRadius: 44,
                                sections: [
                                  if (wishlist > 0) _pieSection(
                                    wishlist, total, 'Wishlist', AppColors.wishlistColor),
                                  if (applied > 0) _pieSection(
                                    applied, total, 'Applied', AppColors.blue),
                                  if (interviews > 0) _pieSection(
                                    interviews, total, 'Interview', AppColors.orange),
                                  if (offers > 0) _pieSection(
                                    offers, total, 'Offer', AppColors.green),
                                  if (rejected > 0) _pieSection(
                                    rejected, total, 'Rejected', AppColors.rejectedColor),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              if (wishlist > 0) _legend('Wishlist', AppColors.wishlistColor),
                              if (applied > 0) _legend('Applied', AppColors.blue),
                              if (interviews > 0) _legend('Interview', AppColors.orange),
                              if (offers > 0) _legend('Offer', AppColors.green),
                              if (rejected > 0) _legend('Rejected', AppColors.rejectedColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Achievement cards ─────────────────────
                  const SectionHeader(title: 'Achievements'),
                  const SizedBox(height: 12),
                  _AchievementCard(
                    icon: '🎯',
                    title: 'Active Hunter',
                    subtitle: '$total applications tracked',
                    unlocked: total >= 1,
                    color: AppColors.purple,
                  ),
                  const SizedBox(height: 8),
                  _AchievementCard(
                    icon: '💼',
                    title: 'Interview Ready',
                    subtitle: 'Got your first interview',
                    unlocked: interviews >= 1,
                    color: AppColors.orange,
                  ),
                  const SizedBox(height: 8),
                  _AchievementCard(
                    icon: '🏆',
                    title: 'Offer Received',
                    subtitle: 'First offer in hand',
                    unlocked: offers >= 1,
                    color: AppColors.green,
                  ),
                  const SizedBox(height: 8),
                  _AchievementCard(
                    icon: '🚀',
                    title: 'Power Applicant',
                    subtitle: '10+ applications tracked',
                    unlocked: total >= 10,
                    color: AppColors.cyan,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PieChartSectionData _pieSection(int value, int total, String label, Color color) {
    return PieChartSectionData(
      value: value.toDouble(),
      title: '$value',
      titleStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white,
      ),
      color: color,
      radius: 50,
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.plusJakartaSans(
          fontSize: 11, color: AppColors.textSecondary,
        )),
      ],
    );
  }
}

class _FunnelRow extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;

  const _FunnelRow({
    required this.label, required this.value,
    required this.max, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = max > 0 ? value / max : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: AppText.bodySmall),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13, fontWeight: FontWeight.w700, color: color,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool unlocked;
  final Color color;

  const _AchievementCard({
    required this.icon, required this.title,
    required this.subtitle, required this.unlocked, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: unlocked ? color.withOpacity(0.4) : AppColors.border,
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: unlocked ? color.withOpacity(0.15) : AppColors.border.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                unlocked ? icon : '🔒',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
                Text(subtitle, style: AppText.bodySmall),
              ],
            ),
          ),
          if (unlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Unlocked', style: GoogleFonts.plusJakartaSans(
                fontSize: 10, fontWeight: FontWeight.w700, color: color,
              )),
            ),
        ],
      ),
    );
  }
}
