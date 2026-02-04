import 'package:flutter/material.dart';
import 'home_shell.dart';

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7F9);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Fitness',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
      ),
      home: const HomeShell(),
    );
  }
}
