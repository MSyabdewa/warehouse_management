import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../env/constants/open_ai.dart';

class ChatBotController extends GetxController {
  TextEditingController userInput = TextEditingController();
  List<ChatMessage> responses = [];

  ChatUser myself = ChatUser(id: '1', firstName: 'You');
  ChatUser bot = ChatUser(id: '2', firstName: 'AI');

  submitForm(ChatMessage message) async {
    try {
      responses.insert(0, message);

      const apiUrl = 'https://api.openai.com/v1/chat/completions';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode(
          <String, dynamic>{
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content":
                    "Jika ada user yang menanyakan kamu siapa atau memberikan ucapan halo, kamu adalah AI yang membantu user untuk mengetahui tentang manajemen gudang (warehouse management) dan juga detail mengenai hal tersebut. Jika pertanyaan di luar dari topik manajemen gudang, tolak dengan halus. Saya ingin memahami lebih dalam tentang manajemen gudang. Bisakah Anda memberikan penjelasan terkait dengan pertanyaan ini: ${message.text}",
              }
            ],
            "max_tokens": 1000,
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['choices'] != null &&
            responseData['choices'].isNotEmpty) {
          final bestResponse = responseData['choices'][0]['message']['content'];

          responses.insert(
            0,
            ChatMessage(
              text: bestResponse,
              user: bot,
              createdAt: DateTime.now(),
            ),
          );
        } else {
          print('Gagal mendapatkan respons dari model.');
        }
      } else {
        print('Gagal mendapatkan respons. Kode status: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
    userInput.clear();
    update();
  }
}
