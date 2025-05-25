import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_clien_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController phoneController = TextEditingController();

  Map<String, List<String>> availableSlots = {};
  List<String> timesForSelectedDate = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableSlots();
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
      lastDate: now.add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
        timesForSelectedDate = availableSlots[DateFormat('yyyy-MM-dd').format(date)] ?? [];
        selectedTime = timesForSelectedDate.isNotEmpty ? timesForSelectedDate[0] : null;
      });
    }
  }

  bool get isFormValid =>
      selectedTime != null &&
          selectedDate != null &&
          phoneController.text.trim().isNotEmpty;

  Future<void> _confirmSession() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User token is missing, please login again')),
      );
      return;
    }

    final sessionData = {
      'psychologistId': widget.psychologist['_id'],
      'date': DateFormat('yyyy-MM-dd').format(selectedDate!),
      'time': selectedTime,
      'phone': phoneController.text.trim(),
      'concern': concernController.text.trim(),
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
      print('Error response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm session: ${response.body}')),
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
                    Text(
                      selectedDate == null ? "Choose Date" : "${selectedDate!.day.toString().padLeft(2, '0')} ${_monthName(selectedDate!.month)} ${selectedDate!.year}",
                      style: TextStyle(
                          fontSize: 16,
                          color: selectedDate == null ? Colors.grey : Colors.black),
                    ),
                    Icon(Icons.calendar_today, color: Color(0xFF174754)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            timesForSelectedDate.isEmpty
                ? Text(
              selectedDate == null
                  ? 'Please select a date to see available times'
                  : 'No available slots for this date',
              style: TextStyle(color: Colors.red),
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
            SizedBox(height: 16),
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
                        Text(widget.psychologist['name'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.psychologist['description']),
                      ],
                    ),
                  ),
                  Text('${widget.psychologist['experience']} years'),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
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
            ElevatedButton(
              onPressed: isFormValid ? _confirmSession : null,
              child: Text('Confirm session'),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }
}
