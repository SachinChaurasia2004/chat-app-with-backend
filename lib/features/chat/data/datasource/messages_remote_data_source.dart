import 'dart:convert';
import 'package:chat_app/features/chat/data/model/message_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MessagesRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:2000/messages';
  final _storage = FlutterSecureStorage();

  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.get(
        Uri.parse('$baseUrl/getMessages/$conversationId'),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch messages");
    }
  }

  /*
    try {
      String token = await _storage.read(key: 'token') ?? '';

      final payload = {
        "content": content,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/send/$receiverId'),
        body: jsonEncode(payload),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 201) {
        print('Message sent successfully: ${response.body}');
      } else {
        print('Failed to send message: ${response.body}');
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while sending the message: $e');
    }
  }*/
}
