import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'main_clien_page.dart';  // Главная страница клиента
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ConfirmSessionPage extends StatefulWidget {
  final Map<String, dynamic> psychologist;
  ConfirmSessionPage({required this.psychologist});

  @override
  _ConfirmSessionPageState createState() => _ConfirmSessionPageState();
}

class _ConfirmSessionPageState extends State<ConfirmSessionPage> {
  String? selectedTime;
  DateTime? selectedDate;
  final TextEditingController concernController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<String> times = ['10:00', '11:00', '12:00', '14:00', '16:00', '18:00'];

  // Функция выбора даты
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  String get formattedDate {
    if (selectedDate == null) return "Choose Date";
    return "${selectedDate!.day.toString().padLeft(2, '0')} "
        "${_monthName(selectedDate!.month)} "
        "${selectedDate!.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  bool get isFormValid =>
      selectedTime != null &&
          selectedDate != null &&
          nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty;


  Future<void> _confirmSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Получаем токен из памяти

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User token is missing, please login again')),
      );
      return;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final clientName = decodedToken['username'];

    final sessionData = {
      'psychologistId': widget.psychologist['_id'],
      'date': selectedDate!.toIso8601String(),
      'time': selectedTime,
      'phone': phoneController.text,
      'concern': concernController.text,
      'clientName': clientName,
      'psychologistName': widget.psychologist['username'],  // или 'name'
    };

    final url = Uri.parse('http://10.0.2.2:3005/sessions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(sessionData),
    );

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainClientPage()),
      );
    } else {
      print('Error: ${response.body}'); // Для отладки
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm session')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm your session'),
        leading: BackButton(),
        backgroundColor: Color(0xFF174754),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            SizedBox(height: 8),

            // Выбор времени
            Wrap(
              spacing: 8,
              children: times.map((time) {
                final isSelected = time == selectedTime;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 16),

            // Выбор даты
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formattedDate, style: TextStyle(fontSize: 16, color: selectedDate == null ? Colors.grey : Colors.black)),
                    Icon(Icons.calendar_today, color: Color(0xFF174754)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Профиль психолога
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(child: Icon(Icons.person)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.psychologist['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.psychologist['description']),
                      ],
                    ),
                  ),
                  Text('${widget.psychologist['experience']} years'),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Поле для имени
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            // Поле для номера телефона
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            // Поле для комментариев
            TextField(
              controller: concernController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Feel free to share your emotion and thoughts here',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 8),

            Text('After confirmation you will get message with zoom link'),

            SizedBox(height: 16),

            // Кнопка подтверждения записи
            ElevatedButton(
              onPressed: isFormValid ? _confirmSession : null,
              child: Text('Confirm session'),
            ),
          ],
        ),
      ),
    );
  }
}
