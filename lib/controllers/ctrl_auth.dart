// ignore_for_file: unnecessary_overrides, use_build_context_synchronously
import 'package:chat/api/api_services.dart';
import 'package:chat/controllers/ctrl.dart';
import 'package:chat/controllers/ctrl_socket.dart';
import 'package:chat/models/model_response.dart';
import 'package:chat/models/model_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/helpers/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CtrlAuth extends GetxController {
  ApiService apiService = ApiService();
  Ctrl ctrl = Get.put(Ctrl());
  CtrlSocket ctrlSocket = Get.put(CtrlSocket());
  String domainIP = Constant.domainIP;
  String port = Constant.port;
  String mainUrl = Constant.mainUrl;
  String httpMainUrl = Constant.httpMainUrl;
  bool isLoading = true;
  bool isError = false;
  String remark = "";

  Future<GlobalResponse> actionSignUp(BuildContext ctx, String email, String fullname, String password) async {
    try {
      isLoadingTrue(ctx);
      Map data = {};
      data['email'] = email;
      data['fullname'] = fullname;
      data['password'] = password;
      var response = await apiService.apiSignup(ctx, data);
      isLoadingFalse(ctx, response.status ? '' : response.remarks);
      return response;
    } catch (e) {
      return catchErr(ctx, e);
    }
  }

  Future<GlobalResponse> actionSignIn(BuildContext ctx, String email, String password) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      isLoadingTrue(ctx);
      Map data = {};
      data['email'] = email;
      data['password'] = password;
      var response = await apiService.apiSignin(ctx, data);
      if (response.status) {
        pref.setString("PREF_TOKEN", response.token!);
        ctrlSocket.setSocketUser(response.user!.userId);
        await setPrefSession(response.user!, response.userDetail!);
      }
      isLoadingFalse(ctx, response.status ? '' : response.remarks);
      return response;
    } catch (e) {
      return catchErr(ctx, e);
    }
  }

  Future<GlobalResponse> actionForgotPassword(BuildContext ctx, String email) async {
    try {
      isLoadingTrue(ctx);
      Map data = {};
      data['email'] = email;
      var response = await apiService.apiForgotPassword(ctx, data);
      isLoadingFalse(ctx, response.status ? '' : response.remarks);
      return response;
    } catch (e) {
      return catchErr(ctx, e);
    }
  }

  Future<GlobalResponse> actionChangeForgotPassword(BuildContext ctx, String code, String email, String newPassword) async {
    try {
      isLoadingTrue(ctx);
      Map data = {};
      data['code'] = code;
      data['email'] = email;
      data['new_password'] = newPassword;
      var response = await apiService.apiChangeForgotPassword(ctx, data);
      isLoadingFalse(ctx, response.status ? '' : response.remarks);
      return response;
    } catch (e) {
      return catchErr(ctx, e);
    }
  }

  loginMandatory(String email, String password) {
    if (email.isEmpty) {
      return "Please enter email";
    } else if (password.isEmpty) {
      return "Please enter password";
    } else {
      return "";
    }
  }

  Future setPrefSession(User user, UserDetail userDetail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("PREF_USER_ID", user.userId);
    pref.setString("PREF_EMAIL", user.email);
    pref.setString("PREF_NAME", userDetail.fullname);
    return;
  }

  GlobalResponse catchErr(BuildContext ctx, e) {
    Map<String, dynamic> res = {};
    res['status'] = false;
    res['remarks'] = e.toString();
    isLoadingFalse(ctx, e.toString());
    return GlobalResponse.fromJson(res);
  }

  void isLoadingTrue(BuildContext ctx) {
    isLoading = true;
    isError = false;
    update();
  }

  void isLoadingFalse(BuildContext ctx, String err) {
    FocusScope.of(ctx).requestFocus(FocusNode());
    isLoading = false;
    isError = err == '' ? false : true;
    remark = err;
    Navigator.of(ctx, rootNavigator: true).pop();
    update();
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
