// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'psychologists_page.dart';
import 'blogpage.dart';

class MainVolunteerPage extends StatefulWidget {
  const MainVolunteerPage({super.key});

  @override
  _MainVolunteerPageState createState() => _MainVolunteerPageState();
}

class _MainVolunteerPageState extends State<MainVolunteerPage> {
  String? username;
  List<dynamic> psychologists = [];
  List<dynamic> articles = [];
  bool isLoading = true;

  final Color backgroundColor = const Color(0xFFF3F6F9);
  final Color cardColor1 = const Color(0xFF9FB6C6);
  final Color cardColor2 = const Color(0xFF7592A7);
  final Color textColor1 = const Color(0xFF1B1B1B);
  final Color textColor2 = Colors.white;
  final Color accentColor = const Color(0xFF2F4179);

  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchPsychologists();
    fetchArticles();
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

  Future<void> fetchPsychologists() async {
    final url = Uri.parse('http://10.0.2.2:3005/psychologists');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        psychologists = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchArticles() async {
    final url = Uri.parse('http://10.0.2.2:3005/articles');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        articles = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                // Навигация в профиль (если нужно)
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Log out"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/welcome');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor1)),
          TextButton(
            onPressed: onViewAll,
            child: Text('Все', style: TextStyle(color: accentColor, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor1,
        title: const Text('Главная - Волонтер'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _openMenu(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: cardColor1,
                          child: const Icon(Icons.volunteer_activism, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Привет, ${username ?? "Волонтер"}!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Психологи с кнопкой "Все"
                    _buildSectionHeader('Психологи', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PsychologistsPage()),
                      );
                    }),
                    ...psychologists.take(3).map((psych) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: cardColor1,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: cardColor1.withOpacity(0.5),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: cardColor2,
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              psych['username'] ?? 'Имя',
                              style: TextStyle(fontWeight: FontWeight.bold, color: textColor1),
                            ),
                            subtitle: Text(
                              psych['specialization'] ?? '',
                              style: TextStyle(color: cardColor2),
                            ),
                            onTap: () {
                              // Открыть психолога
                            },
                          ),
                        )),

                    const SizedBox(height: 30),

                    // Статьи с кнопкой "Все"
                    _buildSectionHeader('Статьи', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BlogPage()),
                      );
                    }),
                    ...articles.take(3).map((article) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: cardColor2,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: cardColor2.withOpacity(0.5),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.article, color: Colors.white),
                            title: Text(
                              article['title'] ?? 'Без названия',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            subtitle: Text(
                              article['summary'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            onTap: () {
                              // Открыть статью
                            },
                          ),
                        )),

                    const SizedBox(height: 20),

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
                                MaterialPageRoute(builder: (context) => const BlogPage()),
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


