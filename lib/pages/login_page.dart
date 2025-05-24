import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';  // Импортируем для хранения токена
import 'main_clien_page.dart'; // Главная страница после успешного логина

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController(); // Для телефона
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Функция для отправки данных на сервер (логин)
  Future<void> loginUser() async {
    final url = Uri.parse('http://10.0.2.2:3005/login'); // Адрес вашего сервера Node.js

    // Отправка запроса на сервер
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': _phoneController.text, // Отправляем номер телефона
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Если логин успешен, переход на главную страницу
      final data = jsonDecode(response.body);


      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainClientPage()),
      );
    } else {
      // Если ошибка при логине
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_back, size: 32),
                ),
                const SizedBox(height: 60),
                const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text('Your phone number:'), // Изменяем на номер телефона
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.lightBlue.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 10) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Your password:'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.lightBlue.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF044C70),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser(); // Вызываем функцию логина
                      }
                    },
                    child: const Text('Sign In'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
