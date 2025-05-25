import 'package:flutter/material.dart';
import 'login_page.dart';
import 'registration_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF94B3C2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const Padding(
              padding: EdgeInsets.only(top: 180), // ↖️ Поставь любое число
              child: Image(
                image: AssetImage('assets/logo.png'),
                height: 200,
              ),
            ),

            const SizedBox(height: 50),

            const Text(
              'Mindcare — taking care of the soul starts here.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 9, 51, 72),
                fontFamily: 'InclusiveSans',
              ),
            ),

            const SizedBox(height: 60),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250,50),
                backgroundColor: const Color.fromARGB(255, 9, 51, 72),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: const Text('Войти'),
            ),

            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegistrationPage()),
                );
              },
              style: OutlinedButton.styleFrom(
              
                minimumSize: const Size(250,50),
                backgroundColor: const Color.fromARGB(255, 4, 76, 112),
              ),
              child: const Text(
                'Зарегистрироваться',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
