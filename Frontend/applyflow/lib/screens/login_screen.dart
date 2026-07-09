import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Login failed'),
          backgroundColor: AppColors.rejectedColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.purple.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50, right: -80,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.pink.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // Logo
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.rocket_launch_outlined,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 32),

                  ShaderMask(
                    shaderCallback: (b) => AppColors.purpleGradient.createShader(b),
                    child: Text('Welcome back',
                      style: AppText.displayLarge.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Sign in to track your career journey.',
                      style: AppText.bodyMedium),
                  const SizedBox(height: 40),

                  // Email
                  Text('Email', style: AppText.labelMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary, fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.email_outlined,
                          color: AppColors.textMuted, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  Text('Password', style: AppText.labelMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary, fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.textMuted, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textMuted, size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  GradientButton(
                    label: 'Sign in',
                    onTap: _login,
                    isLoading: auth.isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('or', style: AppText.bodySmall),
                      ),
                      Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: RichText(
                        text: TextSpan(
                          style: AppText.bodyMedium,
                          children: [
                            const TextSpan(text: "New here? "),
                            TextSpan(
                              text: 'Create account',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: AppColors.purple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
