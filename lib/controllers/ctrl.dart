// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:chat/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/helpers/constant.dart';

class Ctrl extends GetxController {
  String domainIP = Constant.domainIP;
  String port = Constant.port;
  String mainUrl = Constant.mainUrl;
  String httpMainUrl = Constant.httpMainUrl;
  Timer? timer;
  bool isConnected = true;
  Color conColor = ColorsTheme.hijau;

  void updateCon(bool s) async {
    isConnected = s;
    if (!s) {
      conColor = ColorsTheme.merah;
    } else {
      conColor = ColorsTheme.hijau;
    }
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
