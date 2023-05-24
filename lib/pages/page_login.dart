import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat/pages/page_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_services.dart';
import '../style/color.dart';
import 'widgets/widget_progress.dart';
import 'widgets/widget_snackbar.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  TextEditingController ctrlUser = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();
  final ApiService _apiService = ApiService();
  Timer? timer;
  Color conColor = ColorsTheme.hijau;

  checkMandatory() {
    if (ctrlUser.text.isEmpty) {
      return "Silakan isi Username";
    } else if (ctrlPassword.text.isEmpty) {
      return "Silakan isi Password";
    } else {
      return "";
    }
  }

  Future setSession(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("PREF_USERNAME", username);
    return;
  }

  void checkConnection() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var con = preferences.getString("PREF_SOCKET") ?? "Not Connected";
    if (mounted) {
      setState(() {
        if (con == "Not Connected") {
          conColor = ColorsTheme.merah;
        } else if (con == "Connected") {
          conColor = ColorsTheme.hijau;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ctrlPassword.text = '12345';
    ctrlUser.text = 'CKR SSM';
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => checkConnection());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: ColorsTheme.primary1, statusBarBrightness: Brightness.light));
    return Scaffold(
      body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16, left: MediaQuery.of(context).size.width * 0.85),
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: conColor,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Image.asset(
                            "assets/images/launcher.jpg",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                        ),
                        const Center(
                          child: Text(
                            "EOEE",
                            style: TextStyle(fontFamily: 'BalsamiqSans', fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.075,
                        ),

                        //email FIELD
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorsTheme.background2,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.email),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: ctrlUser,
                                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Username'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        //PASSWORD FIELD
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorsTheme.background2,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.lock),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: ctrlPassword,
                                      obscureText: true,
                                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Password'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              // ignore: deprecated_member_use
                              child: ElevatedButton(
                                onPressed: () {
                                  String check = checkMandatory();
                                  if (check == "") {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) => const WidgetProgressSubmit());
                                    _apiService.apiLogin(ctrlUser.text, ctrlPassword.text).then((res) async {
                                      Navigator.of(context, rootNavigator: true).pop();
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      if (res.status) {
                                        WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
                                        await setSession(res.user!.userName);
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(builder: (context) => const PageLayout()),
                                            (Route<dynamic> route) => false);
                                      } else {
                                        WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
                                      }
                                    });
                                  } else {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    WidgetSnackbar(context: context, message: check, warna: "merah");
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(ColorsTheme.primary1),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ))),
                                child: const Text(
                                  "LOGIN",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
