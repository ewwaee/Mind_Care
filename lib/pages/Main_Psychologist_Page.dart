import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';  // Для форматирования даты
import 'package:shared_preferences/shared_preferences.dart';

import 'psychologists_page.dart';
import 'blogpage.dart';
import 'SessionDetailsPage.dart';
import 'welcome_page.dart';

class HomeScreen extends StatelessWidget {
final String name;

const psychologist_home_page.dart({super.key, required this.name});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF8F7FA),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_buildGreeting(name),
const SizedBox(height: 20),
_buildSectionTitle("Upcoming sessions"),
const SizedBox(height: 10),
_buildSessionCard("Dinara Satybayeva", "15 y. experience, Gestalt psychologist"),
const SizedBox(height: 30),
_buildWriteArticleButton(),
const SizedBox(height: 20),
_buildArticleCard("my article anananan"),
const SizedBox(height: 10),
_buildArticleCard("my article anananan"),
const SizedBox(height: 30),
_buildSectionTitle("Upcoming sessions"),
const SizedBox(height: 10),
_buildSessionCard("Dinara Satybayeva", "15 y. experience, Gestalt psychologist"),
const SizedBox(height: 10),
_buildSessionCard("Dinara Satybayeva", "15 y. experience, Gestalt psychologist"),
const SizedBox(height: 30),
_buildSectionTitle("AI chat"),
const SizedBox(height: 10),
_buildChatButton(context),
],
),
),
),
);
}

Widget _buildGreeting(String name) {
return Row(
children: [
const CircleAvatar(
radius: 20,
backgroundColor: Colors.grey,
child: Icon(Icons.person, color: Colors.white),
),
const SizedBox(width: 12),
Text(
"Good morning, $name!",
style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
),
],
);
}

Widget _buildSectionTitle(String title) {
return Text(
title,
style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
);
}

Widget _buildSessionCard(String name, String details) {
return Card(
color: const Color(0xFFBFD7EA),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(
padding: const EdgeInsets.all(12),
child: Row(
children: [
const CircleAvatar(
radius: 24,
backgroundColor: Colors.black54,
child: Icon(Icons.person, color: Colors.white),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(name,
style: const TextStyle(
fontSize: 16, fontWeight: FontWeight.bold)),
const SizedBox(height: 4),
Text(details,
style: const TextStyle(
fontSize: 14, color: Colors.black87)),
],
),
),
],
),
),
);
}

Widget _buildWriteArticleButton() {
return Center(
child: ElevatedButton(
onPressed: () {},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.indigo[800],
padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10)),
),
child: const Text("write new articles",
style: TextStyle(fontSize: 16, color: Colors.white)),
),
);
}

Widget _buildArticleCard(String title) {
return Card(
color: const Color(0xFFDBE2EF),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
child: Padding(
padding: const EdgeInsets.all(14),

child: Text(
title,
style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
),
),
);
}

Widget _buildChatButton(BuildContext context) {
return Center(
child: ElevatedButton.icon(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(builder: (_) => const ChatPage()),
);
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.indigo[100],
foregroundColor: Colors.indigo[900],
shape:
RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
),
icon: const Icon(Icons.chat),
label: const Text("Open AI Chat"),
),
);
}
}