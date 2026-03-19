import 'package:flutter/material.dart';
import '../common/app_widgets.dart';
import '../../services/auth_service.dart';
import 'height_screen.dart';
import '../common/onboarding_progress.dart';
import '../../models/onboarding_data.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final auth = AuthService();

  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z]).{6,}$');
    return regex.hasMatch(password);
  }
  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void register() {

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showError("All fields must be filled");
      return;
    }

    if (password != confirmPassword) {
      showError("Passwords do not match");
      return;
    }

    if (!isValidEmail(email)) {
      showError("Enter valid email");
      return;
    }

    if (!isValidPassword(password)) {
      showError("Password must contain at least 6 characters and 1 capital letter");
      return;
    }

    final data = OnboardingData();

    data.name = name;
    data.email = email;
    data.password = password;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HeightScreen(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 60, 18, 18),
        children: [

          const Text(
            "Create Account",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Start your fitness journey",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF64748B),
            ),
          ),

          const OnboardingProgress(
            step: 1,
            total: 4,
          ),

          const SizedBox(height: 28),

          CardShell(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
            child: Column(
              children: [

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                ),

                const SizedBox(height: 26),

                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                  ),
                ),

                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009B87),
                    ),
                    onPressed: register,
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}