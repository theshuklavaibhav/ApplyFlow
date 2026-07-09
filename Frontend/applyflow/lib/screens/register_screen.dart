import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  Future<void> _register() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('All fields are required'),
          backgroundColor: AppColors.rejectedColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService().register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
      if (mounted) {
        await context.read<AuthProvider>().tryAutoLogin();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: AppColors.rejectedColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -80, right: -80,
            child: Container(
              width: 260, height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.cyan.withOpacity(0.2), Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: AppColors.textPrimary, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (b) => AppColors.cyanGradient.createShader(b),
                    child: Text('Create account',
                      style: AppText.displayLarge.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Start tracking your career journey today.',
                      style: AppText.bodyMedium),
                  const SizedBox(height: 40),

                  _label('Full name'),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary, fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Vaibhav Shukla',
                      prefixIcon: Icon(Icons.person_outline,
                          color: AppColors.textMuted, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _label('Email'),
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

                  _label('Password'),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary, fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Min 8 characters',
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
                  const SizedBox(height: 36),

                  GradientButton(
                    label: 'Create account',
                    onTap: _register,
                    isLoading: _isLoading,
                    gradient: AppColors.cyanGradient,
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          style: AppText.bodyMedium,
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Sign in',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: AppColors.cyan,
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

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: AppText.labelMedium),
  );
}
