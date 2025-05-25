import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchPsychologists();
    fetchArticles();
  }

  Future<void> loadUserData() async {
    // Здесь можно загрузить имя пользователя из токена или отдельного API
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // Например, декодировать JWT (если используешь jwt_decoder)
      // Или просто сделать запрос к API для получения профиля
      // Для примера просто зададим имя:
      setState(() {
        username = "Волонтер"; // Замени на настоящее имя из профиля
      });
    }
  }

  Future<void> fetchPsychologists() async {
    final url = Uri.parse('http://10.0.2.2:3005/psychologists'); // Твой API эндпоинт для психологов
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        psychologists = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      // обработка ошибки
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchArticles() async {
    final url = Uri.parse('http://10.0.2.2:3005/articles'); // Твой API эндпоинт для статей
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        articles = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      // обработка ошибки
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная - Волонтер'),
        backgroundColor: const Color(0xFF044C70),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    'Привет, ${username ?? 'Волонтер'}!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Психологи:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ...psychologists.map((psych) => ListTile(
                        title: Text(psych['username'] ?? 'Имя'),
                        subtitle: Text(psych['specialization'] ?? ''),
                        leading: const Icon(Icons.person),
                      )),

                  const SizedBox(height: 30),
                  const Text(
                    'Статьи:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ...articles.map((article) => ListTile(
                        title: Text(article['title'] ?? 'Без названия'),
                        subtitle: Text(
                          article['summary'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: const Icon(Icons.article),
                        onTap: () {
                          // Можно добавить переход к полному тексту статьи
                        },
                      )),
                ],
              ),
            ),
    );
  }
}
