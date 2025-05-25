import 'package:flutter/material.dart';
import 'chatPage.dart';
import 'PsychologistProfilePage.dart';

class PsychologistHomePage extends StatelessWidget {
  const PsychologistHomePage({super.key});
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // светло-серый фон
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Приветствие и аватар
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Good morning, $name!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Upcoming sessions
              const Text(
                'Upcomming sessions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              sessionCard('Dinara Satybayeva', '15 y. experience, Gestalt psychologist'),
              const SizedBox(height: 16),

              // Button to write articles
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F4A7B), // темно-синий
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('write new articles'),
                ),
              ),
              const SizedBox(height: 16),

              // Статьи
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFDADADA),
                child: Column(
                  children: [
                    articleCard('my article anananan'),
                    const SizedBox(height: 8),
                    articleCard('my article anananan'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Повторяющиеся блоки с сессиями
              const Text(
                'Upcomming sessions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              sessionCard('Dinara Satybayeva', '15 y. experience, Gestalt psychologist'),
              const SizedBox(height: 8),
              sessionCard('Dinara Satybayeva', '15 y. experience, Gestalt psychologist'),
            ],
          ),
        ),
      ),
    );
  }

  Widget sessionCard(String name, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF91B8C9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget articleCard(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF91B8C9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }
}