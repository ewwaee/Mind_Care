import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PsychologistProfilePage.dart'; // Профиль психолога

class PsychologistsPage extends StatefulWidget {
  const PsychologistsPage({super.key});

  @override
  _PsychologistsPageState createState() => _PsychologistsPageState();
}

class _PsychologistsPageState extends State<PsychologistsPage> {
  List<Map<String, dynamic>> psychologists = [];

  @override
  void initState() {
    super.initState();
    fetchPsychologists();  // Загрузка психологов из БД
  }

  // Функция для загрузки психологов из базы данных
  Future<void> fetchPsychologists() async {
    final url = Uri.parse('http://10.0.2.2:3005/psychologists'); // Адрес сервера для получения списка психологов
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        psychologists = data.map((psych) {
          return {
            '_id': psych['_id'],  // Добавь это
            'name': psych['username'],
            'experience': psych['experience'],
            'description': psych['specialization'],
            'rating': psych['rating'] ?? 0.0,
          };

        }).toList();
      });
    } else {
      // Обработка ошибки при запросе
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load psychologists')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find your Psychologist'),
        leading: const BackButton(),
      ),
      body: psychologists.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Индикатор загрузки, если психологи еще не загружены
          : ListView.builder(
        itemCount: psychologists.length,
        itemBuilder: (context, index) {
          final psych = psychologists[index];
          return Card(
            color: Colors.blueGrey.shade200,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(psych['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(psych['description']), // Специализация психолога
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 5),
                      Text(psych['rating'].toString()), // Рейтинг психолога
                    ],
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${psych['experience']} years'),
                  const Text('of experience'),
                ],
              ),
              onTap: () {
                // Переход на страницу профиля психолога
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PsychologistProfilePage(
                      psychologist: psych, // Передаем данные психолога
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
