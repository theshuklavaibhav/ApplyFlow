import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
    ).hasMatch(email);
  }

  Future<void> _handleRegisted() async{
    // Input Validation
    if (_fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
        );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() {
      _isLoading = true ; 
    });
    try{
      // Calling Auth_Service directly here , them refreshing AuthProvider
      await AuthService().register(_emailController.text, _passwordController.text, _fullNameController.text) ;
      if(mounted){
        context.read<AuthProvider>().tryAutoLogin() ;
        Navigator.pop(context) ; 
      } 
    }
    catch(e){
      setState(() {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$e')
            )
          ) ;
        } 
      }
      );
    }
    finally{
      if(mounted){
        setState(() {
          _isLoading = false ; 
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.white,), 
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create account",
            style: TextStyle(
              fontSize: 25 , 
              fontWeight: FontWeight.bold,
              color: AppColors.ink
            ),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                label: Text('Full Name') ,
              ),
            ),
            const SizedBox(height: 12,),
            // TextField(
            //   controller: _emailController,
            //   decoration: const InputDecoration(
            //     label: Text('Email') ,
            //   ),
            // ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 12,),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                label: Text('Password') ,
              ),
            ),
            const Spacer() ,
             
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Expanded(
                    child:FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    onPressed: _isLoading ? null : _handleRegisted,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white,) : const Text('Create account', style: TextStyle(color: Colors.white),),
                  ),
              ),
              ]
            ),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    ); 

  }
}
