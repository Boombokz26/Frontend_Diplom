import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../services/api_client.dart';
class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  String result = 'Press button to test backend';

  Future<void> testBackend() async {
    try {
      final dio = ApiClient().dio;
      final response =
      await dio.get('http://10.0.2.2:8000/api/sessions/');
      setState(() {
        result = response.data.toString();
      });
    } catch (e) {
      setState(() {
        result = 'ERROR:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: testBackend,
              child: const Text('TEST BACKEND'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
