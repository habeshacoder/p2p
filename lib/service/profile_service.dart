import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:p2p/baseUrl.dart';
import 'package:p2p/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileService with ChangeNotifier {
  Future<User> getUser({String? token, String? pid}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pid = prefs.getString("pid");
    token = prefs.getString("token");
    print(pid);
    print(token);
    try {
      if (token == null || token.isEmpty) {
        throw Exception("Failed to get user");
      }
      final baseUrl = BaseUrl.url;
      String url = "$baseUrl/user";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'pid': pid!,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        User user = User.fromJson(jsonResponse, token);
        print(response);
        return user;
      } else {
        // Handle other types of errors or unexpected response formats
        throw Exception("Failed to get user");
      }
    } catch (error) {
      throw Exception("Failed to get user");
    }
  }
}
