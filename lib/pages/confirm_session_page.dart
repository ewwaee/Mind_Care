// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_clien_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ConfirmSessionPage extends StatefulWidget {
  final Map<String, dynamic> psychologist;
  const ConfirmSessionPage({required this.psychologist});

  @override
  _ConfirmSessionPageState createState() => _ConfirmSessionPageState();
}

class _ConfirmSessionPageState extends State<ConfirmSessionPage> {
  String? selectedTime;
  DateTime? selectedDate;
  final TextEditingController concernController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Map<String, List<String>> availableSlots = {};
  List<String> timesForSelectedDate = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableSlots(); // загрузить расписание при старте
  }

  Future<void> fetchAvailableSlots() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('Token is null, user should login');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:3005/psychologist-schedule/${widget.psychologist['_id']}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> slotsJson = jsonDecode(response.body);
      availableSlots = slotsJson.map((key, value) => MapEntry(key, List<String>.from(value)));

      if (availableSlots.isNotEmpty) {
        String firstDateKey = availableSlots.keys.first;
        selectedDate = DateTime.parse(firstDateKey);
        timesForSelectedDate = availableSlots[firstDateKey]!;
        selectedTime = timesForSelectedDate.isNotEmpty ? timesForSelectedDate[0] : null;
      } else {
        selectedDate = null;
        timesForSelectedDate = [];
        selectedTime = null;
      }

      print('Available slots: $availableSlots');
      print('Slots for selected date (${DateFormat('yyyy-MM-dd').format(selectedDate!)}): $timesForSelectedDate');

      setState(() {});
    } else {
      print('Failed to load available slots, status: ${response.statusCode}');
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
        timesForSelectedDate = availableSlots[DateFormat('yyyy-MM-dd').format(date)] ?? [];
        selectedTime = timesForSelectedDate.isNotEmpty ? timesForSelectedDate[0] : null;

      });
      await fetchAvailableSlots(); // обновить расписание при смене даты
    }
  }

  String get formattedDate {
    if (selectedDate == null) return "Choose Date";
    return "${selectedDate!.day.toString().padLeft(2, '0')} ${_monthName(selectedDate!.month)} ${selectedDate!.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  bool get isFormValid =>
      

          selectedDate != null &&
          phoneController.text.trim().isNotEmpty;


  Future<void> _confirmSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User token is missing, please login again')),
      );
      return;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final clientName = decodedToken['username'];

    final sessionData = {
      'psychologistId': widget.psychologist['_id'],
      'date': DateFormat('yyyy-MM-dd').format(selectedDate!),
      'time': selectedTime,
      'phone': phoneController.text,
      'concern': concernController.text,
      'clientName': clientName,
      'psychologistName': widget.psychologist['username'],
    };

    final url = Uri.parse('http://10.0.2.2:3005/sessions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(sessionData),
    );

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainClientPage(),
        ),
      );

    } else {
      print('Error: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to confirm session')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm your session'),
        leading: const BackButton(),
        backgroundColor: const Color(0xFF174754),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Session details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formattedDate,
                        style: TextStyle(
                            fontSize: 16,
                            color: selectedDate == null ? Colors.grey : Colors.black)),
                    const Icon(Icons.calendar_today, color: Color(0xFF174754)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            timesForSelectedDate.isEmpty
                ? Text(
              selectedDate == null
                  ? 'Please select a date to see available times'
                  : 'No available slots for this date',
              style: const TextStyle(color: Colors.red),
            )
                : Wrap(
              spacing: 8,
              children: timesForSelectedDate.map((time) {
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.psychologist['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.psychologist['description']),
                      ],
                    ),
                  ),
                  Text('${widget.psychologist['experience']} years'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: concernController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Feel free to share your emotion and thoughts here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Text('After confirmation you will get message with zoom link'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isFormValid ? _confirmSession : null,
              child: const Text('Confirm session'),
            ),
          ],
        ),
      ),
    );
  }
}
