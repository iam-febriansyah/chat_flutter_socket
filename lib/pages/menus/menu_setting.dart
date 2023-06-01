// ignore_for_file: use_build_context_synchronously

import 'package:chat/controllers/ctrl_socket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/ctrl.dart';
import '../../style/color.dart';
import '../auth/page_signin.dart';
import '../widgets/widget_snackbar.dart';

Ctrl ctrl = Get.put(Ctrl());

class PageMenuSetting extends StatefulWidget {
  const PageMenuSetting({super.key});

  @override
  State<PageMenuSetting> createState() => _PageMenuSettingState();
}

class _PageMenuSettingState extends State<PageMenuSetting> {
  Ctrl ctrl = Get.put(Ctrl());
  CtrlSocket ctrlSocket = Get.put(CtrlSocket());
  TextEditingController ctrlDomainIP = TextEditingController();
  TextEditingController ctrlPort = TextEditingController();

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    ctrlSocket.delSocketUser(preferences.getString("PREF_USER_ID"));
    preferences.clear();
    Box box = Hive.box("dbChatBox");
    box.deleteAll(box.keys);
    Get.offAll(const PageSignIn());
  }

  void save() async {
    if (ctrlDomainIP.text == "") {
      WidgetSnackbar(context: context, message: "Mohon isi alamat Domain/IP dengan benar", warna: "merah");
      return;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("PREF_DOMAINIP", ctrlDomainIP.text);
    preferences.setString("PREF_PORT", ctrlPort.text);
  }

  @override
  void initState() {
    super.initState();
    ctrlDomainIP.text = ctrl.domainIP;
    ctrlPort.text = ctrl.port;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: ColorsTheme.background2,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: ctrlDomainIP,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Domain/IP'),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: TextField(
                      controller: ctrlPort,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Port'),
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: IconButton(
                        icon: const Icon(
                          Icons.check,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          save();
                        },
                      ))
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  logout();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(ColorsTheme.primary1),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ))),
                child: const Text(
                  "LOGOUT",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
