import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './providers/job_provider.dart';
import 'screens/job_list_screen.dart';
import './screens/login_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const  ApplyFlow());
}

class ApplyFlow extends StatelessWidget {
  const ApplyFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final auth = AuthProvider();
            auth.tryAutoLogin();
            return auth;
          },
        ),
        ChangeNotifierProvider(create: (_) => JobProvider()),
      ],
      child: MaterialApp(
        title: "Job Tracker",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

// Decides which screen to show based on login state - this is the "router" logic
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoggedIn) {
          return const JobListScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
