import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat/pages/page_layout.dart';
import 'package:chat/pages/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool connected = true;

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var duration = const Duration(seconds: 3);
    return Timer(duration, () async {
      if (preferences.getString("PREF_USERNAME") == null || preferences.getString("PREF_USERNAME") == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const PageLogin()), (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const PageLayout()), (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: ColorsTheme.primary1, statusBarBrightness: Brightness.light));
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Image.asset("assets/images/launcher.jpg"))),
                  const Text(
                    "EOEE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorsTheme.text1,
                      fontSize: 42,
                      fontFamily: "Sansation Light",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  const Text(
                    "Powered by\nPT. Musashi Auto Parts Indonesia",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorsTheme.text1,
                      fontSize: 12,
                      fontFamily: "Sansation Light",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )));
  }
}
