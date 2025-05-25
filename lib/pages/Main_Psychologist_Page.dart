import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'Schedule_Page.dart';  // Импорт страницы расписания

class MainPsychologistPage extends StatefulWidget {
  @override
  _MainPsychologistPageState createState() => _MainPsychologistPageState();
}

class _MainPsychologistPageState extends State<MainPsychologistPage> {
  String? username;

  List<Map<String, dynamic>> upcomingSessions = [
    {
      'clientName': 'Aselka Alibekova',
      'clientInfo': 'Client, 22 years old',
      'time': '12:00',
      'date': DateTime.now().add(Duration(days: 4)),
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
        final Map<String, dynamic> payloadMap = json.decode(payload);
        setState(() {
          username = payloadMap['username'];
        });
      }
    }
  }

  Widget buildActionCard(String title, String buttonText, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF9FB6C6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black87)),
          SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2F4179),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            onPressed: onPressed,
            child: Text(buttonText, style: TextStyle(fontSize: 14)),
          )
        ],
      ),
    );
  }

  Widget buildSessionCard(Map<String, dynamic> session) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF9FB6C6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF7592A7),
            child: Icon(Icons.person, color: Colors.white, size: 32),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session['clientName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(session['clientInfo'], style: TextStyle(fontSize: 12, color: Colors.black87)),
                Text(session['time'], style: TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          Text(
            DateFormat('d\nMMM').format(session['date']),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget buildGreeting() {
    final cardColor1 = Color(0xFF9FB6C6);
    final textColor2 = Colors.white;
    final textColor1 = Color(0xFF1B1B1B);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF7592A7),
            child: Icon(Icons.person, color: textColor2, size: 32),
          ),
          SizedBox(width: 16),
          Text(
            'Good morning, ${username ?? 'Psychologist'}!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor1 = Color(0xFF1B1B1B);

    return Scaffold(
      backgroundColor: Color(0xFFF3F6F9),
      appBar: AppBar(
        backgroundColor: Color(0xFF9FB6C6),
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildGreeting(),

            buildActionCard(
              'Manage your schedule and appointments.',
              'Go to Schedule',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SchedulePage()),
                );
              },
            ),

            buildActionCard(
              'Review client requests and manage consultations.',
              'View Requests',
                  () {
                // Навигация к странице запросов
              },
            ),

            buildActionCard(
              'Write articles and share your expertise.',
              'Write Article',
                  () {
                // Навигация к редактору статей
              },
            ),

            SizedBox(height: 20),
            Text('Upcoming sessions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor1)),

            Expanded(
              child: ListView(
                children: upcomingSessions.map(buildSessionCard).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
