import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/audio_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/view_surah.dart';
import 'core/routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QURANKOE',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      // SplashScreen jadi halaman pertama
      home: const SplashScreen(),
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.viewSurah: (context) {
          final surahNumber = ModalRoute.of(context)!.settings.arguments as int;
          return ViewSurahScreen(surahNumber: surahNumber);
        },
      },
    );
  }
}