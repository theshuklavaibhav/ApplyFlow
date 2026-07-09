import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../utils/constants.dart';
import '../models/job_application.dart';

// ─── Glass Card ──────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final Color? borderColor;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient ?? LinearGradient(
              colors: [
                AppColors.surface.withOpacity(0.9),
                AppColors.surfaceHigh.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.border,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─── Gradient Stat Card ──────────────────────────────────────────
class GradientStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final Gradient gradient;
  final IconData icon;

  const GradientStatCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gradient as LinearGradient).colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11, color: Colors.white.withOpacity(0.75),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Status Badge ────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String status;
  final bool small;

  const StatusBadge({super.key, required this.status, this.small = false});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.statusColor(status);
    final label = status[0] + status.substring(1).toLowerCase();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─── Job Card ────────────────────────────────────────────────────
class JobCard extends StatelessWidget {
  final JobApplication job;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColors.statusColor(job.status);
    final gradient = AppColors.statusGradient(job.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              // Top gradient accent bar
              Container(
                height: 3,
                decoration: BoxDecoration(gradient: gradient),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Company avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          job.company.isNotEmpty ? job.company[0].toUpperCase() : '?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Company + role
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.company,
                            style: AppText.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            job.roleTitle,
                            style: AppText.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: job.status, small: true),
                  ],
                ),
              ),
              // Bottom row — location + date
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Row(
                  children: [
                    if (job.location != null && job.location!.isNotEmpty) ...[
                      Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(job.location!, style: AppText.bodySmall),
                      const SizedBox(width: 12),
                    ],
                    Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      job.appliedDate != null
                          ? DateFormat('dd MMM yyyy').format(job.appliedDate!)
                          : 'No date',
                      style: AppText.bodySmall,
                    ),
                    const Spacer(),
                    if (onDelete != null)
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(Icons.delete_outline, size: 16, color: AppColors.textMuted),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Circular Progress Card ──────────────────────────────────────
class CircularProgressCard extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const CircularProgressCard({
    super.key,
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 36,
            lineWidth: 6,
            percent: percent.clamp(0.0, 1.0),
            center: Text(
              '${(percent * 100).toInt()}%',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14, fontWeight: FontWeight.w700, color: color,
              ),
            ),
            progressColor: color,
            backgroundColor: color.withOpacity(0.15),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 10),
          Text(label, style: AppText.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─── Shimmer Loader ──────────────────────────────────────────────
class JobCardShimmer extends StatelessWidget {
  const JobCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceHigh,
      child: Column(
        children: List.generate(4, (_) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
        )),
      ),
    );
  }
}

// ─── Gradient Button ─────────────────────────────────────────────
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Gradient gradient;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.gradient = AppColors.purpleGradient,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20, width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.rocket_launch_outlined, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 24),
            Text(title, style: AppText.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: AppText.bodyMedium, textAlign: TextAlign.center),
            if (onAction != null) ...[
              const SizedBox(height: 28),
              GradientButton(label: actionLabel ?? 'Get Started', onTap: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppText.titleMedium),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13, color: AppColors.purple, fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
