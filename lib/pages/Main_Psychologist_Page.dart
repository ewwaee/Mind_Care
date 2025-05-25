import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'Schedule_Page.dart';  // Импорт страницы расписания

class MainPsychologistPage extends StatefulWidget {
  @override
  _MainPsychologistPageState createState() => _MainPsychologistPageState();
}

class _MainPsychologistPageState extends State<MainPsychologistPage> {
  String username = '';  // Изначально пустая строка
  List<Map<String, dynamic>> upcomingSessions = [];
  bool isLoadingSessions = true;

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchUpcomingSessions();
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
          username = payloadMap['username'] ?? '';
        });
      }
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchUpcomingSessions() async {
    final token = await getToken();
    if (token == null) return;

    final url = Uri.parse('http://10.0.2.2:3005/psychologist/upcoming-sessions');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> sessionsJson = jsonDecode(response.body);
      setState(() {
        upcomingSessions = sessionsJson.cast<Map<String, dynamic>>();
        isLoadingSessions = false;
      });
    } else {
      setState(() {
        isLoadingSessions = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load upcoming sessions')),
      );
    }
  }

  void goToClientProfile(String clientId) {
    // Здесь надо реализовать переход на профиль клиента
    // Например, если есть страница ClientProfilePage:
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClientProfilePage(clientId: clientId)),
    );
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
    final client = session['clientId'] ?? {};
    final clientName = client['username'] ?? 'Unknown client';
    final clientInfo = client['phone'] ?? '';
    final date = DateTime.parse(session['date']);
    final time = session['time'] ?? '';

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
                Text(clientName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(clientInfo, style: TextStyle(fontSize: 12, color: Colors.black87)),
                Text('$time, ${DateFormat('d MMM yyyy').format(date)}',
                    style: TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: client['_id'] != null ? () => goToClientProfile(client['_id']) : null,
            child: Text('Profile'),
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
            'Good morning, ${username.isNotEmpty ? username : 'User'}!',
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

            Text('Upcoming sessions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor1)),

            isLoadingSessions
                ? Center(child: CircularProgressIndicator())
                : upcomingSessions.isEmpty
                ? Center(child: Text('No upcoming sessions'))
                : Expanded(
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

// Заглушка страницы профиля клиента — реализуй по своему
class ClientProfilePage extends StatelessWidget {
  final String clientId;
  const ClientProfilePage({required this.clientId});

  @override
  Widget build(BuildContext context) {
    // Логика загрузки профиля клиента по clientId
    return Scaffold(
      appBar: AppBar(title: Text('Client Profile')),
      body: Center(child: Text('Profile for client $clientId')),
    );
  }
}
