import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chat/controllers/ctrl.dart';

import '../models/model_response.dart';

class ApiService {
  var url = Get.put(Ctrl()).httpMainUrl;
  static const String urlSignUp = "/auth/sign-up";
  static const String urlSignIn = "/auth/sign-in";
  static const String urlForgotPassword = "/auth/forgot-password";
  static const String urlChangeForgotPassword = "/auth/change-forgot-password";
  static const String urlChangePassword = "/auth/change-password";
  static const String urlEditAccount = "/auth/edit-account";

  static const String urlChatListUser = "/chat/list-user";
  static const String urlChatListChatUser = "/chat/list-chat-user";
  static const String urlChatSendMessage = "/chat/send-message";
  static const String urlChatDeleteMssage = "/chat/delete-message";

  Future<GlobalResponse> fetchPost(String endPoint, dynamic auth, Map data) async {
    try {
      var body = jsonEncode(data);
      final response = await http
          .post(Uri.parse(url + endPoint),
              headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': auth},
              body: body)
          .timeout(const Duration(seconds: 15),
              onTimeout: () => throw TimeoutException('Can\'t connect in 30 seconds.'));
      if (response.statusCode == 200) {
        return GlobalResponse.fromJson(jsonDecode(response.body));
      } else {
        Map<String, dynamic> res = {};
        res['status'] = false;
        res['remarks'] = 'Failed to post error $endPoint';
        return GlobalResponse.fromJson(res);
      }
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiSignup(Map data) async {
    try {
      return await fetchPost(urlSignUp, '', data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiSignin(Map data) async {
    try {
      return await fetchPost(urlSignIn, '', data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiForgotPassword(Map data) async {
    try {
      return await fetchPost(urlForgotPassword, '', data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChangeForgotPassword(Map data) async {
    try {
      return await fetchPost(urlChangeForgotPassword, '', data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChangePassword(Map data, String auth) async {
    try {
      return await fetchPost(urlChangePassword, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiEditAccount(Map data, String auth) async {
    try {
      return await fetchPost(urlEditAccount, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChatListUser(Map data, String auth) async {
    try {
      return await fetchPost(urlChatListUser, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChatListChatUser(Map data, String auth) async {
    try {
      return await fetchPost(urlChatListChatUser, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChatSendMessage(Map data, String auth) async {
    try {
      return await fetchPost(urlChatSendMessage, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChatDeleteMessage(Map data, String auth) async {
    try {
      return await fetchPost(urlChatDeleteMssage, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }
}
