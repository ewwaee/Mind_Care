// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class PsychologistSessionsPage extends StatefulWidget {
  final String token; // JWT токен
  const PsychologistSessionsPage({super.key, required this.token});

  @override
  State<PsychologistSessionsPage> createState() => _PsychologistSessionsPageState();
}

class _PsychologistSessionsPageState extends State<PsychologistSessionsPage> {
  List sessions = [];
  bool isLoading = true;

  Map<String, dynamic>? selectedClient;
  bool isClientLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    final response = await http.get(
      Uri.parse('http://localhost:3005/psychologist/upcoming-sessions'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      setState(() {
        sessions = json.decode(response.body);
        isLoading = false;
      });
    } else {
      // Обработка ошибки
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load sessions')),
      );
    }
  }

  Future<void> fetchClientProfile(String clientId) async {
    setState(() {
      isClientLoading = true;
    });
    final response = await http.get(
      Uri.parse('http://localhost:3005/client/$clientId'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      setState(() {
        selectedClient = json.decode(response.body);
        isClientLoading = false;
      });
      showClientProfileDialog();
    } else {
      setState(() {
        isClientLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client profile')),
      );
    }
  }

  void showClientProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final client = selectedClient!;
        final session = sessions.firstWhere(
          (s) => s['client']['_id'] == client['_id'],
          orElse: () => null,
        );
        return AlertDialog(
          title: const Text('Профиль клиента'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Имя: ${client['username']}'),
                const SizedBox(height: 8),
                Text('Телефон: ${client['phone']}'),
                const SizedBox(height: 8),
                if (session != null && session['zoomLink'] != null && session['zoomLink'].toString().isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ссылка Zoom:'),
                      GestureDetector(
                        onTap: () async {
                          final url = session['zoomLink'];
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Не удалось открыть ссылку')),
                            );
                          }
                        },
                        child: Text(
                          session['zoomLink'],
                          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  )
                else
                  const Text('Ссылка Zoom не доступна'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Закрыть'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget buildSessionCard(session) {
    final date = DateTime.parse(session['date']);
    final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text('Клиент: ${session['client']['username']}'),
        subtitle: Text('Дата: $formattedDate, Время: ${session['time']}'),
        trailing: ElevatedButton(
          child: const Text('Профиль клиента'),
          onPressed: () => fetchClientProfile(session['client']['_id']),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (sessions.isEmpty) return const Center(child: Text('Нет предстоящих сессий'));

    return Scaffold(
      appBar: AppBar(title: const Text('Предстоящие сессии')),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return buildSessionCard(sessions[index]);
        },
      ),
    );
  }
}
