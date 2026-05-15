import 'dart:async';

import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const AuraApp());
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'AURA',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      themeMode: ThemeMode.system,

      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors:
                isDark
                    ? [Colors.black, const Color(0xFF1A1A1A)]
                    : [Colors.white, const Color(0xFFF5F0E8)],
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.watch_rounded,
              size: 110,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 25),

            Text(
              'AURA',
              style: TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Luxury Watch Collection',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),

            const SizedBox(height: 50),

            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
