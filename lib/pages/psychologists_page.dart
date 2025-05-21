import 'package:flutter/material.dart';
import 'confirm_session_page.dart';

class PsychologistsPage extends StatelessWidget {
  final List<Map<String, dynamic>> psychologists = [
    {
      'name': 'Dinara Satybayeva',
      'experience': 3,
      'description': '15 y. experience, Gestalt psychologist',
      'rating': 4.85,
    },
    {
      'name': 'Dinara Satybayeva',
      'experience': 10,
      'description': '15 y. experience, Gestalt psychologist',
      'rating': 5.00,
    },
    {
      'name': 'Dinara Satybayeva',
      'experience': 7,
      'description': '15 y. experience, Gestalt psychologist',
      'rating': 3.10,
    },
    {
      'name': 'Dinara Satybayeva',
      'experience': 6,
      'description': '15 y. experience, Gestalt psychologist',
      'rating': 4.55,
    },
    {
      'name': 'Dinara Satybayeva',
      'experience': 5,
      'description': '15 y. experience, Gestalt psychologist',
      'rating': 1.00,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find your Psychologist'),
        leading: BackButton(),
      ),
      body: ListView.builder(
        itemCount: psychologists.length,
        itemBuilder: (context, index) {
          final psych = psychologists[index];
          return Card(
            color: Colors.blueGrey.shade200,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(psych['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(psych['description']),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 5),
                      Text(psych['rating'].toString()),
                    ],
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${psych['experience']} years'),
                  Text('of experience'),
                ],
              ),
              onTap: () async {
                final session = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmSessionPage(psychologist: psych),
                  ),
                );
                if (session != null) {
                  Navigator.pop(context, session);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
