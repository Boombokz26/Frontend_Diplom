import 'package:flutter/material.dart';
import '../services/auth_gate.dart';
import '../services/token_storage.dart';
import 'home_shell.dart';
import '../ui/screens/login_screen.dart';

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {

  Widget startScreen = const AuthGate();

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future<void> checkToken() async {

    final token = await TokenStorage.getToken();

    if (token != null) {
      setState(() {
        startScreen = const HomeShell();
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Fitness',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
      ),
      home: startScreen,
    );

  }

}