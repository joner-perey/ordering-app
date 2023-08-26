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

  Future<dynamic> getUser({
    required int userId,
  }) async {
    var response = await client.get(
      Uri.parse('$baseUrl/api/users/$userId'),
      headers: {
        "Content-Type": "application/json"
      },
    );
    return response;
  }

  Future<dynamic> updateProfile(
      {required String? token,
      required id,
      required name,
      required email,
      required phone_number}) async {
    var body = {"name": name, "email": email, "phone_number": phone_number};
    final response = await http.post(
      Uri.parse('$baseUrl/api/update/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<dynamic> updatePassword({
    required String? token,
    required id,
    required current_password,
    required new_password,
  }) async {
    var body = {
      "current_password": current_password,
      "new_password": new_password
    };
    final response = await http.post(
      Uri.parse('$baseUrl/api/update/$id/update_password'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );
    print(response.body);
    return response;
  }

  Future<dynamic> updateFcmToken({
    required String? auth_token,
    required String fcm_token,
  }) async {
    var body = {
      "fcm_token": fcm_token
    };
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/update_fcm_token'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $auth_token"
      },
      body: jsonEncode(body),
    );
    print(response.body);
    return response;
  }

  Future<dynamic> updateLocation({
    required String? auth_token,
    required String latitude,
    required String longitude,
  }) async {
    var body = {
      "latitude": latitude,
      "longitude": longitude,
    };
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/update_location'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $auth_token"
      },
      body: jsonEncode(body),
    );
    print(response.body);
    return response;
  }

  Future<dynamic> updateWalkThrough({
    required String? auth_token,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/update_walk_through'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $auth_token"
      },
    );
    print(response.body);
    return response;
  }

  Future<dynamic> deleteUser(int user_id) async {
    var response = await client.delete(
      Uri.parse('$baseUrl/api/users/$user_id'),
    );
    print(response.body);
    return response;
  }
}
