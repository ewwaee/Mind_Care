import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PsychologistProfilePage extends StatelessWidget {
  final String name;
  final String gender;
  final String email;
  final String specialization;
  final List<String> documents;
  final List<String> clients;
  final List<String> sessions;

  const PsychologistProfilePage({
    super.key,
    required this.name,
    required this.gender,
    required this.email,
    required this.specialization,
    required this.documents,
    required this.clients,
    required this.sessions,
  });

  Widget sectionCard(String title, List<String> items) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            ...items.map((item) => Row(
                  children: [
                    const Icon(Icons.circle, size: 8),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget profileRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Профиль Психолога"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blueAccent,
                child: Icon(FontAwesomeIcons.userDoctor,
                    size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            profileRow(Icons.person, "Имя", name),
            const SizedBox(height: 10),
            profileRow(Icons.wc, "Пол", gender),
            const SizedBox(height: 10),
            profileRow(Icons.email, "Email", email),
            const SizedBox(height: 10),
            profileRow(Icons.psychology, "Специализация", specialization),
            const SizedBox(height: 20),

            // Блоки-карточки
            sectionCard("Документы", documents),
            sectionCard("Клиенты", clients),
            sectionCard("Сессии", sessions),
          ],
        ),
      ),
    );
  }
}
