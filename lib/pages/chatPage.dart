// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> messages = [
    {'role': 'assistant', 'content': 'Привет! Я здесь, чтобы выговориться и помочь ❤️'},
  ];

  bool isLoading = false;

  final String apiKey = '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';
  final String model = 'microsoft/DialoGPT-medium';

  Future<String> sendMessageToAPI(String message) async {
    final url = Uri.parse('https://api-inference.huggingface.co/models/$model');

    final prompt = "Ты добрый и понимающий психолог. Ответь поддерживающе и с эмпатией: $message";

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'inputs': prompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List && data.isNotEmpty && data[0]['generated_text'] != null) {
        return data[0]['generated_text'];
      } else if (data is Map && data['generated_text'] != null) {
        return data['generated_text'];
      } else {
        return 'Извините, не смог ответить.';
      }
    } else {
      return 'Ошибка сервера: ${response.statusCode}';
    }
  }

  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': userMessage});
      _controller.clear();
      isLoading = true;
    });


    setState(() {

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9AB7C7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(Icons.arrow_back, color: Colors.blueAccent),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'AI Chat',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            ),

            // Chat messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message['role'] == 'user';

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.white : const Color(0xFFE5F0F8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message['content']!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Georgia',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Loading indicator
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // Input area
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCE7F0),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(fontFamily: 'Georgia'),
                        decoration: const InputDecoration(
                          hintText: 'Напиши сюда...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFFD9D9D9),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


