import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      _AiFeature('✨', 'Resume Review', 'Get instant AI feedback on your resume',
          AppColors.purpleGradient, 'Coming soon'),
      _AiFeature('🎯', 'ATS Score Check', 'See how your resume scores against ATS filters',
          AppColors.cyanGradient, 'Coming soon'),
      _AiFeature('🎤', 'Mock Interview', 'Practice with AI-generated interview questions',
          AppColors.orangeGradient, 'Coming soon'),
      _AiFeature('✍️', 'Cover Letter', 'Generate tailored cover letters in seconds',
          AppColors.greenGradient, 'Coming soon'),
      _AiFeature('📊', 'Salary Predictor', 'Estimate salary for any role and location',
          AppColors.purpleGradient, 'Coming soon'),
      _AiFeature('🔍', 'Skill Gap Analysis', 'Find what skills you need for your target role',
          AppColors.cyanGradient, 'Coming soon'),
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.bg,
              title: Row(
                children: [
                  Text('AI Career ', style: AppText.displayMedium),
                  ShaderMask(
                    shaderCallback: (b) => AppColors.purpleGradient.createShader(b),
                    child: Text('Copilot', style: AppText.displayMedium.copyWith(color: Colors.white)),
                  ),
                ],
              ),
              centerTitle: false,
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // Hero card
                  GlassCard(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.purple.withOpacity(0.3),
                        AppColors.pink.withOpacity(0.2),
                      ],
                    ),
                    borderColor: AppColors.purple.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                gradient: AppColors.purpleGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Powered by Gemini', style: AppText.labelMedium),
                                Text('Your AI career assistant', style: AppText.bodySmall),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Get personalized career guidance, resume help, and interview prep — all powered by AI.',
                          style: AppText.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        GradientButton(
                          label: 'Start a conversation (Coming Soon)',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick prompts
                  const SectionHeader(title: 'Quick prompts'),
                  const SizedBox(height: 12),
                  ...[
                    '💡 Improve my resume for SDE roles',
                    '🎯 What skills do I need for backend roles?',
                    '📝 Write a cover letter for Razorpay',
                    '🤔 How do I negotiate my first offer?',
                  ].map((prompt) => GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(prompt, style: AppText.bodyMedium),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 14, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 24),

                  // Feature grid
                  const SectionHeader(title: 'AI features'),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: features.map((f) => _FeatureCard(feature: f)).toList(),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiFeature {
  final String emoji;
  final String title;
  final String description;
  final LinearGradient gradient;
  final String badge;
  _AiFeature(this.emoji, this.title, this.description, this.gradient, this.badge);
}

class _FeatureCard extends StatelessWidget {
  final _AiFeature feature;
  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(feature.emoji, style: const TextStyle(fontSize: 24)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: feature.gradient,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(feature.badge, style: GoogleFonts.plusJakartaSans(
                  fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white,
                )),
              ),
            ],
          ),
          const Spacer(),
          Text(feature.title, style: AppText.titleMedium.copyWith(fontSize: 13)),
          const SizedBox(height: 4),
          Text(feature.description,
              style: AppText.bodySmall.copyWith(fontSize: 11),
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
