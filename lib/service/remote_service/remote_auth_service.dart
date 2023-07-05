import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lalaco/const.dart';

class RemoteAuthService {
  var client = http.Client();

  Future<dynamic> signUp({
    required String email,
    required String password,
    required String name,
    required String user_type,
    required String phone,
  }) async {
    var body = {
      "user_type": user_type,
      "name": name,
      "email": email,
      "password": password,
      "phone_number": phone
    };
    var response = await client.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print(response.body);
    return response;
  }

  Future<dynamic> createProfile({
    required String name,
    required String token,
  }) async {
    var body = {"name": name};
    var response = await client.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    var body = {"email": email, "password": password};
    var response = await client.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<dynamic> getProfile({
    required String token,
  }) async {
    var response = await client.get(
      Uri.parse('$baseUrl/api/auth/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    return response;
  }
}
