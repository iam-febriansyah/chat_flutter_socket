// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:chat/controllers/ctrl.dart';
import 'package:chat/controllers/ctrl_auth.dart';
import 'package:chat/helpers/constant.dart';
import 'package:chat/models/model_response.dart';
import 'package:chat/pages/auth/page_forgot_password.dart';
import 'package:chat/pages/auth/page_signup.dart';
import 'package:chat/pages/widgets/widget_progress.dart';
import 'package:chat/pages/widgets/widget_snackbar.dart';
import 'package:chat/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat/pages/page_layout.dart';
import 'package:get/get.dart';

class PageSignIn extends StatefulWidget {
  const PageSignIn({super.key});

  @override
  State<PageSignIn> createState() => _PageSignInState();
}

class _PageSignInState extends State<PageSignIn> {
  CtrlAuth ctrlAuth = Get.put(CtrlAuth());
  Ctrl ctrl = Get.put(Ctrl());
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();
  Timer? timer;

  void signIn() async {
    showDialog(
        context: context, barrierDismissible: false, builder: (BuildContext context) => const WidgetProgressSubmit());
    GlobalResponse res = await ctrlAuth.actionSignIn(context, ctrlEmail.text, ctrlPassword.text);
    if (res.status) {
      Get.offAll(const PageLayout());
    }
    WidgetSnackbar(context: context, message: res.remarks, warna: res.status ? "hijau" : "merah");
  }

  @override
  void initState() {
    ctrlEmail.text = 'febriansyah032@gmail.com';
    ctrlPassword.text = '1';
    super.initState();
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
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.06, left: MediaQuery.of(context).size.width * 0.85),
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ctrl.conColor,
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
                            "assets/images/launcher.png",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Center(
                          child: Text(
                            Constant.appName,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),

                        //email FIELD
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorsTheme.background2,
                              borderRadius: BorderRadius.circular(8),
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
                                      controller: ctrlEmail,
                                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Email'),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorsTheme.background2,
                              borderRadius: BorderRadius.circular(8),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.centerRight),
                              onPressed: () {
                                Get.to(const PageForgotPassword());
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: ColorsTheme.text3),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.055,
                              child: ElevatedButton(
                                onPressed: () async {
                                  signIn();
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(ColorsTheme.primary1),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ))),
                                child: const Text(
                                  "Let's Chat",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32, top: 4),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            onPressed: () {
                              Get.to(const PageSignUp());
                            },
                            child: const Text(
                              "Don't have account? Signup Here",
                              style: TextStyle(color: ColorsTheme.text3),
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
