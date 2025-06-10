// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

// Функция для подключения к MongoDB и сохранения данных
Future<void> connectToMongoDB(Map<String, dynamic> session) async {
  final db = await Db.create(
      'mongodb+srv://avokebila11:<rZKobsf1leQItt5u>@cluster0.atjbtym.mongodb.net/?retryWrites=true&w=majority');
  await db.open();

  // Подключаемся к коллекции
  var collection = db.collection('sessions.client');
  await collection.insertOne(session);

  print("Session data saved to MongoDB!");
}

class SessionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> session;

  const SessionDetailsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final psychologist = session['psychologist'] ?? {};
    final date = session['date']?.toString() ?? '';
    final day = session['day']?.toString() ?? '';
    final time = session['time']?.toString() ?? 'Not selected';
    final concern = session['concern']?.toString() ?? '';

    final psychologistName = psychologist['name']?.toString() ?? 'Unknown';
    final psychologistDescription = psychologist['description']?.toString() ?? 'No description';
    final psychologistExperience = psychologist['experience'] != null
        ? psychologist['experience'].toString()
        : '0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session details'),
        backgroundColor: const Color(0xFF829CB0),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFEFF3F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Session details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'InclusiveSans', // Применение шрифта
              ),
            ),
            const SizedBox(height: 12),

            // Session time and date
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9FB6C6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['10:00', '11:00', '12:00', '14:00', '16:00', '18:00']
                          .map((t) {
                        final isSelected = t == time;
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF174754) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF174754) : Colors.black,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'InclusiveSans', // Применение шрифта
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9FB6C6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontFamily: 'InclusiveSans', // Применение шрифта
                            ),
                          ),
                          Text(
                            day,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontFamily: 'InclusiveSans', // Применение шрифта
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Psychologist info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9FB6C6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade400,
                    child: const Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          psychologistName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                            fontFamily: 'InclusiveSans', // Применение шрифта
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          psychologistDescription,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontFamily: 'InclusiveSans', // Применение шрифта
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$psychologistExperience years',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                      fontFamily: 'InclusiveSans', // Применение шрифта
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Concern field
            const Text(
              'What is concerning you?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'InclusiveSans', // Применение шрифта
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF9FB6C6), width: 2),
              ),
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Text(
                  concern.isEmpty ? 'This field is optional, type...' : concern,
                  style: TextStyle(
                    color: concern.isEmpty ? Colors.grey.shade600 : Colors.black87,
                    fontFamily: 'InclusiveSans', // Применение шрифта
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'After confirmation you will get message with zoom link',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'InclusiveSans', // Применение шрифта
              ),
            ),
          ],
        ),
      ),
    );
  }
}
