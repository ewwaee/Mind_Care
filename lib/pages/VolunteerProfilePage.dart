import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VolunteerProfilePage extends StatelessWidget {
  final String name;
  final String gender;
  final String email;
  final String organization;
  final List<String> documents;
  final List<String> events;
  final List<String> feedbacks;

  const VolunteerProfilePage({
    super.key,
    required this.name,
    required this.gender,
    required this.email,
    required this.organization,
    required this.documents,
    required this.events,
    required this.feedbacks,
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
            if (items.isEmpty)
              const Text("Нет данных"),
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
        Icon(icon, color: Colors.green),
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
        title: const Text("Профиль Волонтёра"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.green,
                child: Icon(FontAwesomeIcons.handsHelping,
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
            profileRow(Icons.location_city, "Организация", organization),
            const SizedBox(height: 20),

            sectionCard("Документы", documents),
            sectionCard("Мероприятия", events),
            sectionCard("Отзывы", feedbacks),
          ],
        ),
      ),
    );
  }
}
