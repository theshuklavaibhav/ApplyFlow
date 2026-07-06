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

  Future<void> _handleRegisted() async{
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
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email') ,
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
