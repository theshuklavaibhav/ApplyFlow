// import 'package:applyflow/screens/add_edit_job_screen.dart';
// import 'package:applyflow/screens/ai_screen.dart';
// import 'package:applyflow/screens/analytics_screen.dart';
// import 'package:applyflow/screens/home_screen.dart';
// import 'package:applyflow/screens/job_list_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'providers/auth_provider.dart';
// import 'providers/job_provider.dart';
// import 'screens/login_screen.dart';
// import 'screens/main_shell.dart';
// import 'utils/constants.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Force portrait, set status bar style
//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ),
//   );

//   runApp(const ApplyFlow());
// }

// class ApplyFlow extends StatelessWidget {
//   const ApplyFlow({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()..tryAutoLogin()),
//         ChangeNotifierProvider(create: (_) => JobProvider()),
//       ],
//       child: MaterialApp(
//         title: 'ApplyFlow',
//         debugShowCheckedModeBanner: false,
//         theme: AppTheme.dark,
//         home: const AuthGate(),
//       ),
//     );
//   }
// }

// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, auth, _) {
//         if (auth.isLoggedIn) return const MainShell();
//         return const LoginScreen();
//       },
//     );
//   }
// }

import 'package:applyflow/screens/home_screen.dart';
import 'package:applyflow/screens/job_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/job_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ApplyFlow());
}

class ApplyFlow extends StatelessWidget {
  const ApplyFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..tryAutoLogin()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'ApplyFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            // themeMode: themeProvider.themeMode,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // if (auth.isLoggedIn) return const MainShell();
        // return const LoginScreen();
        return const MainShell() ; 
      },
    );
  }
}