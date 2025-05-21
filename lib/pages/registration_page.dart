
import 'package:flutter/material.dart';

// Импортируем экраны
import 'volunteer_page.dart';
// ignore: unused_import
import 'psychologist_page.dart'; // или правильный путь
import 'main_clien_page.dart';










class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _selectedRole = 'Client';
  final bool _obscurePassword = true;

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
                _buildInputField(_emailController, 'Email'),
                _buildInputField(_passwordController, 'Password', isPassword: true),
                _buildInputField(_confirmPasswordController, 'Confirm your password', isPassword: true),

                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044C70),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registration successful!')),
                      );

                      // Переход на страницу в зависимости от роли
                      if (_selectedRole == 'Psychologist') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PsychologistPage ()),
                        );
                      } else if (_selectedRole == 'Client') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainClientPage()),
                        );
                      } else if (_selectedRole == 'Volunteer') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const VolunteerPage()),
                        );
                      }
                    }
                  },
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

  Widget _buildInputField(TextEditingController controller, String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
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
