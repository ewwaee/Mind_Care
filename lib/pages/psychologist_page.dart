import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import 'PsychologistProfilePage.dart'; // Не забудь создать эту страницу отдельно

class PsychologistPage extends StatefulWidget {
  const PsychologistPage({super.key});

  @override
  State<PsychologistPage> createState() => _PsychologistPageState();
}

class _PsychologistPageState extends State<PsychologistPage> {
  File? selectedFile;
  final TextEditingController infoController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  int countWords(String text) {
    return text.trim().split(RegExp(r"\s+")).length;
  }

  Future<void> submitForm() async {
    if (countWords(infoController.text) > 50 ||
        countWords(experienceController.text) > 30 ||
        countWords(specializationController.text) > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Слишком много слов в одном из полей")),
      );
      return;
    }

    // ВРЕМЕННЫЙ ПЕРЕХОД НА ПРОФИЛЬ (без бэка)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PsychologistProfilePage(
          name: "Dr. Flutter",
          gender: "Female",
          email: "flutter@example.com",
          specialization: specializationController.text,
          documents: [selectedFile?.path.split('/').last ?? 'No Document'],
          clients: const ["Client A", 'Client B'],
          sessions: const ['Session 1 on Zoom', 'Session 2 offline'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Psychologist Registration")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text("Upload your certificates and documents:"),
            ElevatedButton(
              onPressed: pickFile,
              child: Text(selectedFile == null
                  ? "Choose File"
                  : "Selected: ${selectedFile!.path.split('/').last}"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: infoController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "About you",
                fillColor: Colors.blue[100],
                filled: true,
              ),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Your age",
                fillColor: Colors.blue[100],
                filled: true,
              ),
            ),
            TextField(
              controller: experienceController,
              decoration: InputDecoration(
                labelText: "Years of experience",
                fillColor: Colors.blue[100],
                filled: true,
              ),
            ),
            TextField(
              controller: specializationController,
              decoration: InputDecoration(
                labelText: "Specialization",
                fillColor: Colors.blue[100],
                filled: true,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: submitForm,
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
