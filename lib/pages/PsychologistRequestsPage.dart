import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PsychologistRequestsPage extends StatefulWidget {
  @override
  _PsychologistRequestsPageState createState() => _PsychologistRequestsPageState();
}

class _PsychologistRequestsPageState extends State<PsychologistRequestsPage> {
  List<Map<String, dynamic>> pendingSessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingSessions();
  }

  Future<void> fetchPendingSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('http://10.0.2.2:3005/psychologist/pending-sessions');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        pendingSessions = data.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> confirmOrReject(String sessionId, String action) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('http://10.0.2.2:3005/sessions/$sessionId/confirm');
    final response = await http.patch(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'action': action}),
    );

    if (response.statusCode == 200) {
      // Перезагрузить список
      fetchPendingSessions();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update session status'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Session Requests')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pendingSessions.isEmpty
          ? Center(child: Text('No pending requests'))
          : ListView.builder(
        itemCount: pendingSessions.length,
        itemBuilder: (context, index) {
          final session = pendingSessions[index];
          final client = session['clientId'] ?? {};
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(client['username'] ?? 'Unknown'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone: ${client['phone'] ?? ''}'),
                  Text('Date: ${session['date']?.toString()?.split('T')?.first ?? ''}'),
                  Text('Time: ${session['time'] ?? ''}'),
                  if (session['concern'] != null)
                    Text('Concern: ${session['concern']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () =>
                        confirmOrReject(session['_id'], 'confirm'),
                    tooltip: 'Confirm',
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () =>
                        confirmOrReject(session['_id'], 'reject'),
                    tooltip: 'Reject',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
