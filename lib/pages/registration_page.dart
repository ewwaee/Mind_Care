
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // Поле для телефона
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController(); // Дата рождения
  final TextEditingController _motivationController = TextEditingController(); // Мотивация для волонтера

  String _selectedRole = 'Client';
  bool _obscurePassword = true;

  // Функция для отправки данных на сервер
  Future<void> registerUser() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    final url = Uri.parse('http://10.0.2.2:3005/register'); // Ваш серверный адрес

    // Отправка данных на сервер
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _nameController.text,
        'phone': _phoneController.text, // Используем номер телефона вместо email
        'password': _passwordController.text,
        'role': _selectedRole,
        'specialization': _selectedRole == 'Psychologist' ? _specializationController.text : null,
        'experience': _selectedRole == 'Psychologist' ? _experienceController.text : null,
        'birthDate': _selectedRole == 'Psychologist' ? _birthDateController.text : null, // Дата рождения
        'motivation': _selectedRole == 'Volunteer' ? _motivationController.text : null, // Мотивация для волонтера
      }),
    );

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('User registered successfully!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // После регистрации перенаправляем на страницу логина
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to register user: ${response.body}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Center(
                  child: Text(
                    'Registration',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Роли
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRoleIcon('Psychologist', Icons.psychology),
                    _buildRoleIcon('Client', Icons.person),
                    _buildRoleIcon('Volunteer', Icons.volunteer_activism),
                  ],
                ),
                const SizedBox(height: 30),

                _buildInputField(_nameController, 'Name'),
                _buildInputField(_phoneController, 'Phone'), // Используем номер телефона вместо email
                _buildInputField(_passwordController, 'Password', isPassword: true),
                _buildInputField(_confirmPasswordController, 'Confirm your password', isPassword: true),

                // Условные поля для психолога и волонтера
                if (_selectedRole == 'Psychologist') ...[
                  _buildInputField(_specializationController, 'Your specialization'),
                  _buildInputField(_experienceController, 'Years of your experience'),
                  _buildInputField(_birthDateController, 'Date of birth (DD.MM.YYYY)'), // Дата рождения
                ],
                if (_selectedRole == 'Volunteer') ...[
                  _buildInputField(_motivationController, 'Your motivation (100 words)', maxLength: 100),
                ],

                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044C70),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: registerUser,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, {bool isPassword = false, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        maxLength: maxLength,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          if (label == 'Phone' && value.length < 10) return 'Invalid phone number';
          if (label == 'Email' && !value.contains('@')) return 'Invalid email';
          if (label.contains('Password') && value.length < 6) return 'Password too short';
          if (label == 'Confirm your password' && value != _passwordController.text) return 'Passwords don’t match';
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFD4F0F7),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleIcon(String role, IconData iconData) {
    final bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: isSelected ? const Color(0xFF044C70) : Colors.grey[300],
            child: Icon(iconData, color: isSelected ? Colors.white : Colors.black54, size: 28),
          ),
          const SizedBox(height: 6),
          Text(role, style: TextStyle(color: isSelected ? const Color(0xFF044C70) : Colors.black)),
        ],
      ),
    );
  }
}
