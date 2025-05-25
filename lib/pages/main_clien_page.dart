import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';  // Для форматирования даты
import 'package:shared_preferences/shared_preferences.dart';

import 'psychologists_page.dart';
import 'blogpage.dart';
import 'SessionDetailsPage.dart';
import 'welcome_page.dart';

class MainClientPage extends StatefulWidget {
  const MainClientPage({super.key});

  @override
  _MainClientPageState createState() => _MainClientPageState();
}

class _MainClientPageState extends State<MainClientPage> {
  Map<String, dynamic>? upcomingSession;

  // Функция для установки данных о предстоящей сессии
  void setUpcomingSession(Map<String, dynamic> session) {
    setState(() {
      upcomingSession = session;
    });
  }
  String? username;
  Future<void> fetchUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
        final Map<String, dynamic> payloadMap = json.decode(payload);
        setState(() {
          username = payloadMap['username']; // имя пользователя из токена
        });
      }
    }
  }

  // Функция для открытия меню
  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text("Psychologists"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PsychologistsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text("Articles"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Log out"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUpcomingSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('http://10.0.2.2:3005/upcoming-session');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        upcomingSession = data.isNotEmpty ? data[0] : null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load upcoming session')),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchUpcomingSession();  // Загрузка данных о предстоящей сессии при старте
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF3F6F9);
    const cardColor1 = Color(0xFF9FB6C6);
    const cardColor2 = Color(0xFF7592A7);
    const textColor1 = Color(0xFF1B1B1B);
    const textColor2 = Colors.white;
    const accentColor = Color(0xFF2F4179);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor1,
        title: const Text('Main Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _openMenu(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Приветствие и аватарка
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePage(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: cardColor1,
                      child: Icon(Icons.person, color: textColor2, size: 32),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Good morning, ${username ?? 'User'}!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor1,
                      fontFamily: 'InclusiveSans',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // Предстоящая сессия
              if (upcomingSession != null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SessionDetailsPage(session: upcomingSession!),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor1,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: cardColor1.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: cardColor2,
                          child: Icon(Icons.person, color: textColor2, size: 36),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                upcomingSession!['psychologistName'], // Имя психолога
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: textColor1,
                                  fontFamily: 'InclusiveSans',
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                upcomingSession!['concern'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: cardColor2,
                                  fontFamily: 'InclusiveSans',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: cardColor2,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                DateFormat('dd MMM yyyy').format(DateTime.parse(upcomingSession!['date'])),
                                style: TextStyle(
                                  color: textColor2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'InclusiveSans',
                                ),
                              ),
                              Text(
                                upcomingSession!['time'],
                                style: TextStyle(color: textColor2, fontSize: 14, fontFamily: 'InclusiveSans'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: cardColor1,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cardColor1.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: cardColor2,
                        child: Icon(Icons.person, color: textColor2, size: 36),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'No Upcoming Session',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: cardColor2,
                          fontFamily: 'InclusiveSans',
                        ),
                      ),
                    ],
                  ),
                ),

              // Поиск психолога
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: cardColor1,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: cardColor1.withOpacity(0.7),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find best therapist for you and schedule a session!',
                      style: TextStyle(fontSize: 17, color: textColor1, fontFamily: 'InclusiveSans'),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        shadowColor: accentColor.withOpacity(0.6),
                        elevation: 6,
                      ),
                      onPressed: () async {
                        final session = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PsychologistsPage()),
                        );
                        if (session != null) {
                          setUpcomingSession(session);
                        }
                      },
                      child: const Text(
                        "Let's do it!",
                        style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'InclusiveSans'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Кнопка для чтения статей
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: cardColor2,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: cardColor2.withOpacity(0.7),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Read articles based on your interests and needs!",
                      style: TextStyle(fontSize: 17, color: textColor2, fontFamily: 'InclusiveSans'),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        shadowColor: accentColor.withOpacity(0.6),
                        elevation: 6,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BlogPage()),
                        );
                      },
                      child: const Text(
                        "Let's see!",
                        style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'InclusiveSans'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
