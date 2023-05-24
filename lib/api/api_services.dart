import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chat/controllers/ctrl.dart';

import '../models/model_response.dart';

class ApiService {
  Ctrl ctrl = Get.put(Ctrl());
  static const String urlLogin = "/api/plc/login";
  static const String urlGetMachines = "/api/plc/get-machines";
  static const String urlCheckCon = "/api/plc/check-status";
  static const String urlChangeStatus = "/api/plc/change-status";
  static const String urlStatusMachine = "/api/plc/list-status";

  Future<GlobalResponse> apiLogin(String username) async {
    try {
      var url = ctrl.httpMainUrl;
      Map data = {"Username": username};
      var body = jsonEncode(data);
      final response = await http
          .post(Uri.parse(url + urlLogin),
              headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'}, body: body)
          .timeout(const Duration(seconds: 15),
              onTimeout: () => throw TimeoutException('Can\'t connect in 30 seconds.'));
      if (response.statusCode == 200) {
        return GlobalResponse.fromJson(jsonDecode(response.body));
      } else {
        Map<String, dynamic> res = {};
        res['status'] = false;
        res['remarks'] = 'Failed to post error [Login]';
        return GlobalResponse.fromJson(res);
      }
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiGetMachine(String userlogin) async {
    try {
      var url = ctrl.httpMainUrl;
      Map data = {"UserLogin": userlogin};
      var body = jsonEncode(data);
      final response = await http
          .post(Uri.parse(url + urlGetMachines),
              headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'}, body: body)
          .timeout(const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Can\'t connect in 30 seconds.'));
      if (response.statusCode == 200) {
        return GlobalResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to post error [Get-Machine]');
      }
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiStatusMachine() async {
    try {
      var url = ctrl.httpMainUrl;
      final response = await http.post(Uri.parse(url + urlStatusMachine), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      }).timeout(const Duration(seconds: 30), onTimeout: () => throw TimeoutException('Can\'t connect in 30 seconds.'));
      if (response.statusCode == 200) {
        return GlobalResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to post error [Status-Machine]');
      }
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiCheckCon(String ipaddress) async {
    try {
      var url = ctrl.httpMainUrl;
      Map data = {"ipAddress": ipaddress};
      var body = jsonEncode(data);
      final response = await http
          .post(Uri.parse(url + urlCheckCon),
              headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'}, body: body)
          .timeout(const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Can\'t connect in 30 seconds.'));
      if (response.statusCode == 200) {
        return GlobalResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to post error [Check-Connection]');
      }
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChangeStatus(String ipaddress, int status) async {
    try {
      var url = ctrl.httpMainUrl;
      Map data = {"ipAddress": ipaddress, "status": status};
      var body = jsonEncode(data);
      final response = await http
          .post(Uri.parse(url + urlChangeStatus),
              headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'}, body: body)
          .timeout(const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('Can\'t connect in 30 seconds.'));
      if (response.statusCode == 200) {
        return GlobalResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to post error [Change-Status]');
      }
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }
}
