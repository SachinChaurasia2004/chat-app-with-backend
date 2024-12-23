import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/convo_model.dart';
import 'package:http/http.dart' as http;

class ConversationRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:2000/conversations';
  final _storage = FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversations() async {
    String token = await _storage.read(key: 'token') ?? '';

    try {
      final response =
          await http.get(Uri.parse('$baseUrl/getAllConversations'), headers: {
        'Authorization': 'Bearer $token',
      });

      print(response.body);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((json) => ConversationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch conversations');
      }
    } catch (e) {
      print("Error in fetching Conversations: $e");
      rethrow;
    }
  }
}
