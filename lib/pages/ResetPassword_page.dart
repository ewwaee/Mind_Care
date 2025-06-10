import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();

  Future<void> verifyAndReset() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3005/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': widget.email, 'token': _codeController.text}),
    );

    if (response.statusCode == 200) {
      final reset = await http.post(
        Uri.parse('http://10.0.2.2:3005/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'newPassword': _newPasswordController.text,
        }),
      );

      if (reset.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error resetting: ${reset.body}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid code: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Enter the code sent to your email:'),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Verification Code'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyAndReset,
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}