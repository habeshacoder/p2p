import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:p2p/baseUrl.dart';
import 'package:p2p/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  Future<User> registerUser(registrationData) async {
    try {
      const uri =
          "https://seal-app-j8qc7.ondigitalocean.app/public/create-user";
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          "firstName": registrationData["firstName"],
          "lastName": registrationData["lastName"],
          "userName": registrationData["userName"],
          "userPassword": registrationData["userPassword"],
          "email": registrationData["email"],
          "address": {
            "street": registrationData["address"]["street"],
            "city": registrationData["address"]["city"],
          },
          "verifiedEmail": "string",
          "isEmailVerified": true
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("created user: ---- ${response.body}");
        return User.fromJson(jsonDecode(response.body));
      } else {
        // Handle other types of errors or unexpected response formats
        throw Exception(jsonDecode(response.body));
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<String>> login(Map<String, dynamic> requestData) async {
    print("login called");
    try {
      const uri =
          "https://seal-app-j8qc7.ondigitalocean.app/public/authenticate";
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("User authenticated successfully");
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(response.body);

        String token = jsonResponse['token'];
        String pid = jsonResponse['pid'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('pid', pid);
        await prefs.setString('token', token);
        await prefs.setString('signInTime', DateTime.now().toIso8601String());
        List<String> roles =
            (jsonResponse['roles'] as List<dynamic>).cast<String>();
        await prefs.setString('role', roles[0]);

        return roles;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error) {
      throw Exception("Failed to authenticate user: $error");
    }
  }

  Future<dynamic> resetPassword(Map<String, dynamic> requestData) async {
    print("password reset called");
    try {
      const uri =
          "https://seal-app-j8qc7.ondigitalocean.app/public/user-password-reset";
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("User authenticated successfully");
        }

        return response.body;
      } else {
        // Handle other types of errors or unexpected response formats
        throw Exception(jsonDecode(response.body));
      }
    } catch (error) {
      throw Exception("Failed to authenticate user");
    }
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('pid');
    await prefs.remove('token');
  }
}
