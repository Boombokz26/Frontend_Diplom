import 'package:flutter/material.dart';
import '../../common/app_widgets.dart';
import '../../../services/auth_service.dart';
import 'height_screen.dart';
import '../../common/onboarding_progress.dart';
import '../../../models/onboarding_data.dart';

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

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  bool isTypingEmail = false;
  bool isTypingPassword = false;

  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z]).{6,}$');
    return regex.hasMatch(password);
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void validateFields() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      emailError = isValidEmail(email)
          ? null
          : "Invalid email format";

      passwordError = isValidPassword(password)
          ? null
          : "Must be 6+ chars and include 1 uppercase";

      confirmPasswordError = password == confirmPassword
          ? null
          : "Passwords do not match";
    });
  }

  void register() {

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    validateFields();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
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
                  onTap: () {
                    setState(() => isTypingEmail = true);
                  },
                  onChanged: (_) {
                    validateFields();
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    helperText: !isTypingEmail
                        ? "example@email.com"
                        : null,
                    errorText: isTypingEmail ? emailError : null,
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: passwordController,
                  obscureText: !passwordVisible,
                  onTap: () {
                    setState(() => isTypingPassword = true);
                  },
                  onChanged: (_) {
                    validateFields();
                  },
                  decoration: InputDecoration(
                    labelText: "Password",
                    helperText: !isTypingPassword
                        ? "6+ characters, at least 1 uppercase" : null,
                    errorText: isTypingPassword ? passwordError : null,
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: confirmPasswordController,
                  obscureText: !confirmPasswordVisible,
                  onChanged: (_) => validateFields(),
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    errorText: confirmPasswordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          confirmPasswordVisible =
                          !confirmPasswordVisible;
                        });
                      },
                    ),
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