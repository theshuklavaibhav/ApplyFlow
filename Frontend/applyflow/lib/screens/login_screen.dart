import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    final auth =  context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (!success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(auth.error ?? 'Login Failed')));
    }
    // No navigation needed here - AuthGate in main.dart automatically
    // switches to JobListScreen because notifyListners() fired inside login()
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 48 , height: 48,
                decoration: BoxDecoration(
                  color: AppColors.ink ,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.work_outline , color: Colors.white,),
              ),
              const SizedBox(height: 24) ,
              const Text('Welcome back' , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.w600, color: AppColors.ink),), 
              const SizedBox(height: 4,) ,
              const Text('Sign in to track your applications.', style: TextStyle(fontSize: 13,color: AppColors.textSecondary),),
              const SizedBox(height: 28) , 
              const Text('Email',style: TextStyle(fontSize: 12,color: AppColors.ink , fontWeight: FontWeight.w500),) , 
              const SizedBox(height: 6) ,
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('you@example.com'),
              ),
              const SizedBox(height: 14) , 
              Text('Password' , style: TextStyle(fontSize: 12, color: AppColors.ink, fontWeight: FontWeight.w500 ),) , 
              const SizedBox(height : 6) ,
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _inputDecoration('•••••••••••••').copyWith(
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        _obscurePassword = !_obscurePassword ;  
                      }) ; 
                    } ,
                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    iconSize: 18 ,
                    color: AppColors.textMuted,
                  )
                ),
              ),
              const SizedBox(height: 24,) , 
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary , 
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8))
                    ) , 
                    onPressed: auth.isLoading ? null : _handleLogin,
                    child: auth.isLoading ? const SizedBox(
                      height: 18 , width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,),
                    )
                    : const Text('Sign in', style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500) ,)
                  )
                ),

                const Spacer() ,
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=> const RegisterScreen())
                  ),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13 , color: AppColors.textSecondary) , 
                      children: [
                        TextSpan(text: 'New here?') , 
                        TextSpan(text: 'Create account' , 
                          style: TextStyle(color: AppColors.primary , 
                            fontWeight: FontWeight.w500
                          )
                        )
                      ]
                    ) 
                    ),
                  ),
                ) , 
              const SizedBox(height: 24,)
            ],
          ),
          ),
      ),
    );
  }
}


InputDecoration _inputDecoration(String hint){
  return InputDecoration(
    hintText: hint , 
    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
    filled: true , 
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 12) ,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border)
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border)
    ), 
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary)
    )
  ) ; 
}
