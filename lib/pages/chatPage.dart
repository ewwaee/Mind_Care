import 'package:flutter/material.dart';
import 'huggingface_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final HuggingFaceService _huggingFaceService = HuggingFaceService();

  final List<Map<String, String>> messages = [
    {'role': 'assistant', 'content': 'Привет! Я здесь, чтобы выговориться и помочь ❤️'},
  ];

  bool isLoading = false;

  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': userMessage});
      _controller.clear();
      isLoading = true;
    });

    final reply = await _huggingFaceService.sendMessage(userMessage);

    setState(() {
      messages.add({'role': 'assistant', 'content': reply});
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

            // Bottom nav bar icons
            
          ],
        ),
      ),
    );
  }
}

