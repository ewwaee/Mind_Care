import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'VolunteerProfilePage.dart';

class VolunteerPage extends StatefulWidget {
  const VolunteerPage({super.key});

  @override
  State<VolunteerPage> createState() => _VolunteerPageState();
}

class _VolunteerPageState extends State<VolunteerPage> {
  File? selectedFile;
  final TextEditingController motivationController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController majorController = TextEditingController();

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

  void submitForm() {
  if (countWords(motivationController.text) > 50) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Слишком много слов в мотивации")),
    );
    return;
  }

  if (selectedFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Пожалуйста, загрузите ID-карту")),
    );
    return;
  }

  // Переход на страницу профиля волонтера
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VolunteerProfilePage(
        name: "Иван Иванов", // Имя можно получать от пользователя
        gender: "Мужской", // Здесь можно сделать выбор пола в будущем
        email: "ivan@example.com", // Или взять с формы
        organization: universityController.text,
        documents: [selectedFile!.path.split('/').last],
        events: const ["Благотворительный марафон", "Психологическая помощь детям"],
        feedbacks: const ["Очень отзывчивый!", "Помог организовать ивент"],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Volunteer Registration")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text("Upload your student ID card:"),
            ElevatedButton(
              onPressed: pickFile,
              child: Text(selectedFile == null
                  ? "Choose File"
                  : "Selected: ${selectedFile!.path.split('/').last}"),
            ),
            const SizedBox(height: 20),
            const Text("Enter your motivation and short info:"),
            TextField(
              controller: motivationController,
              maxLines: 4,
              decoration: InputDecoration(fillColor: Colors.blue[100], filled: true),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: universityController,
              decoration: InputDecoration(labelText: "Your university", fillColor: Colors.blue[100], filled: true),
            ),
            TextField(
              controller: courseController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: "Your course", fillColor: Colors.blue[100], filled: true),
            ),
            TextField(
              controller: majorController,
              decoration: InputDecoration(labelText: "Your major", fillColor: Colors.blue[100], filled: true),
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: submitForm, child: const Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}
