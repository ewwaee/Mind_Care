// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'EmailVerificationCode_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _motivationController = TextEditingController();

  String _selectedRole = 'Client';
  String? _selectedGender;
  List<String> _selectedTopics = [];

  final List<String> _availableTopics = [
    'Отношения',
    'Стресс',
    'Учёба',
    'Работа',
    'Самооценка',
    'Тревога',
    'Депрессия'
  ];

  final bool _obscurePassword = true;

  Future<void> registerUser() async {
  if (_nameController.text.isEmpty ||
      _phoneController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _selectedGender == null ||
      (_selectedRole == 'Client' && _birthDateController.text.isEmpty)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All required fields must be filled!')),
    );
    return;
  }

  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passwords do not match!')),
    );
    return;
  }

  Map<String, dynamic> userData = {
    'username': _nameController.text,
    'phone': _phoneController.text,
    'email': _emailController.text,
    'gender': _selectedGender,
    'password': _passwordController.text,
    'role': _selectedRole,
    'topics': _selectedTopics,
  };

  if (_selectedRole == 'Psychologist') {
    userData['specialization'] = _specializationController.text;
    userData['experience'] = _experienceController.text;
    userData['birthDate'] = _birthDateController.text;
  }

  if (_selectedRole == 'Client') {
    userData['birthDate'] = _birthDateController.text;
  }

  if (_selectedRole == 'Volunteer') {
    userData['motivation'] = _motivationController.text;
  }

  final response = await http.post(
    Uri.parse('http://10.0.2.2:3005/send-verification'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': _emailController.text}),
  );

  if (response.statusCode == 200) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmailVerificationPage(
          email: _emailController.text,
          userData: userData,
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send verification code: ${response.body}')),
    );
  }
}


  Widget _buildTopicSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Выберите интересующие темы:', style: TextStyle(fontSize: 16)),
          Wrap(
            spacing: 10.0,
            children: _availableTopics.map((topic) {
              final isSelected = _selectedTopics.contains(topic);
              return FilterChip(
                label: Text(topic),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTopics.add(topic);
                    } else {
                      _selectedTopics.remove(topic);
                    }
                  });
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {bool isPassword = false, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        maxLength: maxLength,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          if (label == 'Phone' && value.length < 10) return 'Invalid phone number';
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
                _buildInputField(_phoneController, 'Phone'),
                _buildInputField(_emailController, 'Email'),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: ['Male', 'Female'].map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD4F0F7),
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select gender';
                      }
                      return null;
                    },
                  ),
                ),

                if (_selectedRole != 'Volunteer') _buildTopicSelector(),

                _buildInputField(_passwordController, 'Password', isPassword: true),
                _buildInputField(_confirmPasswordController, 'Confirm your password', isPassword: true),

                if (_selectedRole == 'Psychologist') ...[
                  _buildInputField(_specializationController, 'Your specialization'),
                  _buildInputField(_experienceController, 'Years of your experience'),
                  _buildInputField(_birthDateController, 'Date of birth (DD.MM.YYYY)'),
                ],

                if (_selectedRole == 'Client') ...[
                  _buildInputField(_birthDateController, 'Date of birth (DD.MM.YYYY)'),
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
}
