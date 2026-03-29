import 'package:flutter/material.dart';
import '../../services/token_storage.dart';
import '../../ui/screens/login_screen.dart';
import 'package:untitled1/app/home_shell.dart';
import '../../services/api_client.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  bool loading = true;
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future<void> checkToken() async {
    final token = await TokenStorage.getToken();


    if (token == null) {
      if (!mounted) return;

      setState(() {
        loggedIn = false;
        loading = false;
      });
      return;
    }


    try {
      await ApiClient().dio.get("/profile/");

      if (!mounted) return;

      setState(() {
        loggedIn = true;
        loading = false;
      });

    } catch (e) {
      /// ❌ токен невалидный
      await TokenStorage.clearToken();

      if (!mounted) return;

      setState(() {
        loggedIn = false;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (loggedIn) {
      return const HomeShell();
    }

    return const LoginScreen();
  }
}