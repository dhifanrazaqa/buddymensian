import 'dart:convert';

import 'package:buddymensia/models/chat_message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SpeakServices {
  Future<String?> sendToGPT(List<ChatMessage> conversationHistory) async {

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['SECRET_GPT']}',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": conversationHistory.map((msg) => msg.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final gptResponse = data['choices'][0]['message']['content'];
      return gptResponse;
    } else {
      print('Failed to get response from GPT: ${response.statusCode}');
      return null;
    }
  }
}
