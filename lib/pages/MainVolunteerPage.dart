import 'package:flutter/material.dart';

class MainVolunteerPage extends StatelessWidget {
  const MainVolunteerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9FB6C6),
        title: const Text('Volunteer Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Welcome, Volunteer!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'InclusiveSans',
              ),
            ),
            const SizedBox(height: 30),
            _buildCard(
              icon: Icons.calendar_today,
              title: 'View Upcoming Sessions',
              subtitle: 'Assist in scheduled support sessions',
              onTap: () {
                // Переход на экран поддержки
              },
            ),
            const SizedBox(height: 20),
            _buildCard(
              icon: Icons.article,
              title: 'Educational Materials',
              subtitle: 'Read articles and guidelines',
              onTap: () {
                // Переход к обучающим материалам
              },
            ),
            const SizedBox(height: 20),
            _buildCard(
              icon: Icons.person,
              title: 'My Profile',
              subtitle: 'View and update your profile',
              onTap: () {
                // Переход к профилю
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF9FB6C6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF7592A7),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        onTap: onTap,
      ),
    );
  }
}
