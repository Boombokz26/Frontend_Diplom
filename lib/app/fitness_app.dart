import 'package:flutter/material.dart';
import '../services//auth_gate.dart';
import '../../main.dart';

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Mobile Fitness',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
      ),
      home: const AuthGate(),
    );
  }
}