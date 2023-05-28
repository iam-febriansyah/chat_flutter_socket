// ignore_for_file: unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:chat/models/model_response.dart';
import 'package:chat/pages/auth/page_signin.dart';
import 'package:chat/pages/widgets/widget_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chat/controllers/ctrl.dart';

class ApiService {
  int timeOut = 30;
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

  Future<GlobalResponse> fetchPost(BuildContext ctx, String endPoint, dynamic auth, Map data) async {
    try {
      var body = jsonEncode(data);
      final response = await http
          .post(Uri.parse(url + endPoint),
              headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': auth}, body: body)
          .timeout(Duration(seconds: timeOut), onTimeout: () => throw TimeoutException('Can\'t connect in ${timeOut} seconds.'));
      if (response.statusCode == 200) {
        GlobalResponse res = GlobalResponse.fromJson(jsonDecode(response.body));
        if (res.remarks == 'Unauthorized') {
          Get.offAll(const PageSignIn());
          res.remarks = "You'r Unauthorized, please Sign In again";
          WidgetSnackbar(context: ctx, message: res.remarks, warna: "merah");
        }
        return res;
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

  Future<GlobalResponse> apiSignup(BuildContext ctx, Map data) async {
    try {
      return await fetchPost(ctx, urlSignUp, '', data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiSignin(BuildContext ctx, Map data) async {
    try {
      return await fetchPost(ctx, urlSignIn, '', data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiForgotPassword(BuildContext ctx, Map data) async {
    try {
      return await fetchPost(ctx, urlForgotPassword, '', data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChangeForgotPassword(BuildContext ctx, Map data) async {
    try {
      return await fetchPost(ctx, urlChangeForgotPassword, '', data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChangePassword(BuildContext ctx, Map data, String auth) async {
    try {
      return await fetchPost(ctx, urlChangePassword, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiEditAccount(BuildContext ctx, Map data, String auth) async {
    try {
      return await fetchPost(ctx, urlEditAccount, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChatListUser(BuildContext ctx, Map data, String auth) async {
    try {
      return await fetchPost(ctx, urlChatListUser, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChatListChatUser(BuildContext ctx, Map data, String auth) async {
    try {
      return await fetchPost(ctx, urlChatListChatUser, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChatSendMessage(BuildContext ctx, Map data, String auth) async {
    try {
      return await fetchPost(ctx, urlChatSendMessage, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }

  Future<GlobalResponse> apiChatDeleteMessage(BuildContext ctx, Map data, String auth) async {
    try {
      return await fetchPost(ctx, urlChatDeleteMssage, auth, data);
    } catch (e) {
      Map<String, dynamic> res = {};
      res['status'] = false;
      res['remarks'] = e.toString();
      return GlobalResponse.fromJson(res);
    }
  }
}
