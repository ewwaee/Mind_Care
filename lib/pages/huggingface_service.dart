import 'dart:convert';
import 'package:http/http.dart' as http;

class HuggingFaceService {
  final String _apiUrl = 'https://api-inference.huggingface.co/openai/mistralai/Devstral-Small-2505';
  final String _apiKey = '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'; // Спрячь в проде

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': "You are a helpful psychologist. A client says: $message",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty && data[0]['generated_text'] != null) {
          return data[0]['generated_text'].trim();
        } else {
          return '❌ Ответ пустой или непонятный.';
        }
      } else {
        print('❌ Ошибка Hugging Face: ${response.statusCode}\n${response.body}');
        return '❌ Ошибка ответа от модели.';
      }
    } catch (e) {
      print('❌ Exception: $e');
      return '❌ Произошла ошибка.';
    }
  }
}

