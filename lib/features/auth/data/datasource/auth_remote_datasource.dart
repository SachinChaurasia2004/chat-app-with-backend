import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/features/auth/data/model/user_model.dart';

class AuthRemoteDatasource {
  final String baseUrl = 'http://10.0.2.2:2000/auth';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<UserModel> login(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    print("Response received: ${response.body}");

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Login failed: $error');
    }
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    print("Response received: ${response.body}");

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Registration failed: $error');
    }
  }

  Future<UserModel?> fetchUser() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/getUser'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        print("Unauthorized access. Please log in again.");
        return null;
      } else {
        throw Exception(
            'Failed to fetch user profile: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error in fetchUser: $e");
      rethrow;
    }
  }
}
