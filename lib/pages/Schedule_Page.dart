// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<dynamic> slots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSlots();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserId() async {
    final token = await getToken();
    if (token == null) return null;
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final Map<String, dynamic> payloadMap = json.decode(payload);
    return payloadMap['userId'];
  }

  Future<void> fetchSlots() async {
    final token = await getToken();
    final userId = await getUserId();
    if (token == null || userId == null) return;

    final url = Uri.parse('http://10.0.2.2:3005/slots/$userId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      setState(() {
        slots = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load schedule')),
      );
    }
  }

  Future<void> addSlot(DateTime date, String time) async {
    final token = await getToken();
    final userId = await getUserId();
    if (token == null || userId == null) return;

    final dateToSend = DateTime(date.year, date.month, date.day);

    final url = Uri.parse('http://10.0.2.2:3005/slots');
    final body = jsonEncode({
      'psychologistId': userId,
      'date': dateToSend.toIso8601String(),
      'time': time,
    });

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    if (response.statusCode == 201) {
      await fetchSlots();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slot added')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add slot')),
      );
    }
  }

  Future<void> deleteSlot(String slotId) async {
    final token = await getToken();
    if (token == null) return;

    final url = Uri.parse('http://10.0.2.2:3005/slots/$slotId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slot deleted')),
      );
      await fetchSlots();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete slot')),
      );
    }
  }

  void _showAddSlotDialog() async {
    DateTime? selectedDate = DateTime.now();
    String? selectedTime;

    final times = ['10:00', '11:00', '12:00', '14:00', '16:00', '18:00'];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            bool isAddEnabled = selectedTime != null && selectedDate != null;

            return AlertDialog(
              title: const Text('Add new slot'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title:
                        Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate!,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setStateDialog(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                  DropdownButton<String>(
                    hint: const Text('Select time'),
                    value: selectedTime,
                    items: times.map((time) {
                      return DropdownMenuItem(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedTime = val;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isAddEnabled
                      ? () {
                          Navigator.pop(context);
                          addSlot(selectedDate!, selectedTime!);
                        }
                      : null,
                  child: const Text('Add'),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget buildSlotTile(Map slot) {
    final dateFormatted =
        DateFormat('dd MMM yyyy').format(DateTime.parse(slot['date']));
    final isBooked = slot['isBooked'] ?? false;
    return Card(
      color: isBooked ? Colors.red.shade200 : Colors.green.shade200,
      child: ListTile(
        title: Text('$dateFormatted at ${slot['time']}'),
        subtitle: Text(isBooked ? 'Booked' : 'Available'),
        trailing: isBooked
            ? null
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete slot?'),
                      content: const Text('Are you sure you want to delete this slot?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              deleteSlot(slot['_id']);
                            },
                            child: const Text('Delete')),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: const Color(0xFF9FB6C6),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : slots.isEmpty
              ? const Center(child: Text('No slots available'))
              : ListView.builder(
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    return buildSlotTile(slots[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSlotDialog,
        backgroundColor: const Color(0xFF7592A7),
        child: const Icon(Icons.add),
      ),
    );
  }
}
