// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:get/get.dart';
import 'package:chat/helpers/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ctrl extends GetxController {
  String domainIP = Constant.domainIP;
  String port = Constant.port;
  String mainUrl = Constant.mainUrl;
  String httpMainUrl = Constant.httpMainUrl;
  Timer? timer;

  void getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    domainIP = pref.getString("PREF_DOMAINIP") ?? Constant.domainIP;
    port = pref.getString("PREF_PORT") ?? Constant.port;
    mainUrl = port == "" ? domainIP : "$domainIP:$port";
    httpMainUrl = "http://$mainUrl";
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => getPref());
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
