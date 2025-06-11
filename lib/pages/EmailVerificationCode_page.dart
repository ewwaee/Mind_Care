import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> userData;

  const EmailVerificationPage({
    super.key,
    required this.email,
    required this.userData,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _verifying = false;

  Future<void> verifyCode() async {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the verification code')),
      );
      return;
    }

    setState(() => _verifying = true);

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3005/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'code': _codeController.text,
      }),
    );

    if (response.statusCode == 200) {
      final registerResponse = await http.post(
        Uri.parse('http://10.0.2.2:3005/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(widget.userData),
      );

      setState(() => _verifying = false);

      if (registerResponse.statusCode == 201) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${registerResponse.body}')),
        );
      }
    } else {
      setState(() => _verifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid verification code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8BA8B5), // голубой фон
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 10),
              const Text(
                'Forgot password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Enter your email to receive a verification code',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Verification Code',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifying ? null : verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044C70),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _verifying
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Send verification code',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

