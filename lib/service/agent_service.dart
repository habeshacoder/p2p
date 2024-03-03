import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p2p/baseUrl.dart';
import 'package:p2p/models/agent_model.dart';
import 'package:p2p/models/areaofcoverage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentService with ChangeNotifier {
  List<AreaOfCoverage> AreasOfCoverage = [];
  List<AreaOfCoverage> getAreasOfCoverage() {
    return AreasOfCoverage;
  }

  List<bool> isLoadinListAllWidget = [];
  List<bool> getisLoadinListAllWidget() {
    return isLoadinListAllWidget;
  }

  Future<int> becomeAgent({required DeliveryAgentModel agentData}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final pid = prefs.getString("pid");
    final token = prefs.getString("token");
    print('pid:$pid');
    print(token);
    try {
      if (token == null || token.isEmpty) {
        throw Exception("you are not authenticated");
      }
      final baseUrl = BaseUrl.url;
      String url = "$baseUrl/user/agent";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'pid': pid!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(agentData.toJson()),
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        return response.statusCode;
      } else {
        throw Exception("request filed");
      }
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }

  Future<List<DeliveryAgentModel>> fetchAllAgents({
    bool isFromAll = false,
    bool isFromApproved = false,
    bool isFromPending = false,
    bool isFromRejected = false,
  }) async {
    try {
      final uri = "${BaseUrl.url}/public/agents";
      final response = await http.get(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final decodedResult = jsonDecode(response.body);
        print(
            "all agent response content 200:.......${decodedResult["content"]}");
        List<DeliveryAgentModel> agents = [];

        if (isFromAll) {
          agents = (decodedResult["content"] as List<dynamic>)
              .map((agentJson) => DeliveryAgentModel.fromMap(agentJson))
              .toList();
        }
        if (isFromApproved) {
          agents = (decodedResult["content"] as List<dynamic>)
              .map((agentJson) => DeliveryAgentModel.fromMap(agentJson))
              .toList();
          agents = agents
              .where((agent) => agent.approvedStatus == 'APPROVED')
              .toList();
        }
        if (isFromPending) {
          agents = (decodedResult["content"] as List<dynamic>)
              .map((agentJson) => DeliveryAgentModel.fromMap(agentJson))
              .toList();
          agents = agents
              .where((agent) => agent.approvedStatus == 'PENDING')
              .toList();
        }
        if (isFromRejected) {
          agents = (decodedResult["content"] as List<dynamic>)
              .map((agentJson) => DeliveryAgentModel.fromMap(agentJson))
              .toList();
          agents = agents
              .where((agent) => agent.approvedStatus == 'REJECTED')
              .toList();
        }

        return agents;
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (error) {
      throw Exception("error:$error");
    }
  }

  Future<int> approveAgent(
      {required String agentIdNumber, required String approvedStatus}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final pid = prefs.getString("pid");
    final token = prefs.getString("token");
    print('pid:$pid');
    print(token);
    try {
      if (token == null || token.isEmpty) {
        throw Exception("you are not authenticated");
      }
      final baseUrl = BaseUrl.url;
      String url = "$baseUrl/admin/agent/approve";
      Uri fullUrl = Uri.parse(url).replace(queryParameters: {
        'agentIdNumber': agentIdNumber,
        'approvedStatus': approvedStatus,
      });

      final response = await http.get(
        fullUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'pid': pid!,
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        return response.statusCode;
      } else {
        throw Exception("request filed");
      }
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }

  Future<void> getAreaOfCoverage() async {
    print('started.................');
    try {
      final baseUrl = BaseUrl.url;
      String url = "$baseUrl/public/area-of-coverages";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('started.................${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final getAreasOfCoverage = jsonDecode(response.body);

        for (var json in getAreasOfCoverage) {
          AreasOfCoverage.add(AreaOfCoverage.fromJson(json));
        }
        print('areasOfCoverageSlist.................$AreasOfCoverage');
      } else {
        throw Exception("request filed");
      }
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }

  Future<int> rejectAgent({
    required Map<String, dynamic> rejectionReason,
    required String agentIdNumber,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final pid = prefs.getString("pid");
    final token = prefs.getString("token");
    print('pid:$pid');
    print(token);
    try {
      if (token == null || token.isEmpty) {
        throw Exception("you are not authenticated");
      }
      final baseUrl = BaseUrl.url;
      String url = "$baseUrl/admin/agent/reject";
      Uri fullUrl = Uri.parse(url).replace(queryParameters: {
        'agentIdNumber': agentIdNumber,
      });

      final response = await http.post(
        fullUrl,
        body: jsonEncode(rejectionReason),
        headers: {
          'Authorization': 'Bearer $token',
          'PID': pid!,
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        return response.statusCode;
      } else {
        throw Exception("request filed");
      }
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  }
}
