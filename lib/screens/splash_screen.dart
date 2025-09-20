import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../core/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _logoExists = false;

  @override
  void initState() {
    super.initState();
    _checkLogo();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  void _checkLogo() {
    // Cek apakah file logo ada di folder assets/images
    final file = File('assets/images/logo.png');
    setState(() {
      _logoExists = file.existsSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau placeholder
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: _logoExists
                    ? Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.teal,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'QURANKOE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}