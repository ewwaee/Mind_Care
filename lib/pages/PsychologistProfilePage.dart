// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'confirm_session_page.dart'; // Import the ConfirmSessionPage

class PsychologistProfilePage extends StatelessWidget {
  final Map<String, dynamic> psychologist;

  const PsychologistProfilePage({super.key, required this.psychologist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B6F8C), // Matching background color
        title: Text('${psychologist['name']}\'s Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF9FB6C6),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Psychologist Name and Rating
            Text(
              psychologist['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B1B1B),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 5),
                Text(
                  '${psychologist['rating']}',
                  style: const TextStyle(fontSize: 18, color: Color(0xFF1B1B1B)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Psychologist Experience
            Text(
              'Experience: ${psychologist['experience']} years',
              style: const TextStyle(fontSize: 18, color: Color(0xFF1B1B1B)),
            ),
            const SizedBox(height: 8),

            // Psychologist Description
            Text(
              'Description: ${psychologist['description']}',
              style: const TextStyle(fontSize: 18, color: Color(0xFF1B1B1B)),
            ),
            const SizedBox(height: 30),

            // Schedule Consultation Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B6F8C), // Button color
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmSessionPage(psychologist: psychologist),
                    ),
                  );
                },
                child: const Text(
                  'Schedule Consultation',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
