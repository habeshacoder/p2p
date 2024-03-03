import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:p2p/baseUrl.dart';
import 'package:p2p/models/agent_model.dart';
import 'package:p2p/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService with ChangeNotifier {
  static String routeName = "/orderService";
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  Future<String?> getPid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('pid');
  }

  Future<String?> getSignInTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('signInTime');
  }

  Future<int> sendOrder(Order orderData) async {
    final pid = await getPid();
    final token = await getToken();
    final signInTimeString = await getSignInTime();
    try {
      if (signInTimeString != null || token == null) {
        DateTime signInTime = DateTime.parse(signInTimeString.toString());
        DateTime currentTime = DateTime.now();
        Duration timeDifference = currentTime.difference(signInTime);

        if (timeDifference.inHours >= 4) {
          throw Exception("Your aren't authenticated. Please Sign In  again");
          // Order request is allowed
        }
      }
      print(token);
      print(pid);
      orderData.deliveryItem.forEach((element) {
        print(
            "item description before order is sent---------------:${element.description}");
      });
      final uri = "${BaseUrl.url}/user/order";
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode(orderData.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'pid': pid.toString(),
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("order inside: ---- ${response.body}");
        return response.statusCode;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<Order>> fetchMyOrder() async {
    final pid = await getPid();
    final token = await getToken();
    final signInTimeString = await getSignInTime();
    try {
      if (signInTimeString != null || token == null) {
        DateTime signInTime = DateTime.parse(signInTimeString.toString());
        DateTime currentTime = DateTime.now();
        Duration timeDifference = currentTime.difference(signInTime);

        if (timeDifference.inHours >= 4) {
          throw Exception("Your aren't authenticated. Please Sign In  again");
          // Order request is allowed
        }
      }
      print(token);
      print(pid);
      final uri = "${BaseUrl.url}/user/orders-list";
      final response = await http.get(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          'pid': pid.toString(),
          'Authorization': 'Bearer $token'
        },
      );
      print("my order: ---- ${response.body}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        final decodedResult = jsonDecode(response.body);
        print(
            "my order response content 200:.......${decodedResult["content"]}");
        // return decodedResult["content"]
        //     .map((orderJson) => Order.fromJson(orderJson))
        //     .toList();
        final List<Order> orders = (decodedResult["content"] as List<dynamic>)
            .map((orderJson) => Order.fromJson(orderJson))
            .toList();
        print('myorder item decription:--------------:');
        orders.forEach((element) {
          element.deliveryItem.forEach((element) {
            print('item description--------------:${element.description}');
          });
        });
        return orders;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error) {
      throw Exception(error);
    }
  }

//update order
  Future<int> updateOrder(Order orderData) async {
    final pid = await getPid();
    final token = await getToken();
    final signInTimeString = await getSignInTime();
    try {
      if (signInTimeString != null || token == null) {
        DateTime signInTime = DateTime.parse(signInTimeString.toString());
        DateTime currentTime = DateTime.now();
        Duration timeDifference = currentTime.difference(signInTime);

        if (timeDifference.inHours >= 4) {
          throw Exception("Your aren't authenticated. Please Sign In  again");
          // Order request is allowed
        }
      }

      final uri = "${BaseUrl.url}/user/order";
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode(orderData.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'pid': pid.toString(),
          'Authorization': 'Bearer $token'
        },
      );
      //
      print("edited oder json: ---- ${orderData.toJson()}");
      print("edited oder status code: ---- ${response.statusCode}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("order inside: ---- ${response.body}");
        return response.statusCode;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error) {
      throw Exception(error);
    }
  }

//delete order
  Future<int> deleteOrder(int? orderID) async {
    final pid = await getPid();
    final token = await getToken();
    final signInTimeString = await getSignInTime();
    try {
      if (signInTimeString != null || token == null) {
        DateTime signInTime = DateTime.parse(signInTimeString.toString());
        DateTime currentTime = DateTime.now();
        Duration timeDifference = currentTime.difference(signInTime);

        if (timeDifference.inHours >= 4) {
          throw Exception("Your aren't authenticated. Please Sign In  again");
          // Order request is allowed
        }
      }
      print(token);
      print(pid);
      //

      final uri = "${BaseUrl.url}/user/$orderID/delete";
      final response = await http.delete(
        Uri.parse(uri),
        headers: {'pid': pid.toString(), 'Authorization': 'Bearer $token'},
      );
      //
      print("order: ---- ${response.body}");
      print("order: ---- ${response.statusCode}");
      if (response.statusCode == 204 || response.statusCode == 202) {
        print("order inside: ---- ${response.body}");
        return response.statusCode;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
