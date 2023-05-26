// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:chat/helpers/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_services.dart';
import '../models/model_response.dart';

class CtrlAuth extends GetxController {
  String domainIP = Constant.domainIP;
  String port = Constant.port;
  String mainUrl = Constant.mainUrl;
  String httpMainUrl = Constant.httpMainUrl;
  final ApiService apiService = ApiService();
  bool isLoading = true;
  bool isError = false;
  String remark = "";

  Future<GlobalResponse> actionSignUp(String email, String password) async {
    isLoading = true;
    isError = false;
    update();
    Map data = {
      email: email,
      password: password,
    };
    var response = await apiService.apiSignin(data);
    isError = !response.status;
    if (!response.status) {
      remark = response.remarks;
    }
    update();
    return response;
  }

  Future<GlobalResponse> actionSignIn(String email, String password) async {
    try {
      isLoadingTrue();
      Map data = {
        email: email,
        password: password,
      };
      var response = await apiService.apiSignin(data);
      isLoadingFalse(response.status ? '' : response.remarks);
      return response;
    } catch (e) {
      return catchErr(e);
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

  GlobalResponse catchErr(e) {
    Map<String, dynamic> res = {};
    res['status'] = false;
    res['remarks'] = e.toString();
    isLoadingFalse(e.toString());
    return GlobalResponse.fromJson(res);
  }

  void isLoadingTrue() {
    isLoading = true;
    isError = false;
    update();
  }

  void isLoadingFalse(String err) {
    isLoading = false;
    isError = err == '' ? false : true;
    remark = err;
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
