// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unused_local_variable, unnecessary_string_interpolations

import 'dart:math';

import 'package:chat/controllers/ctrl.dart';
import 'package:chat/controllers/ctrl_chat.dart';
import 'package:chat/models/model_response.dart';
import 'package:chat/models/model_user.dart';
import 'package:chat/pages/chat/chat_single.dart';
import 'package:chat/pages/widgets/widget_loading_users.dart';
import 'package:chat/pages/widgets/widget_snackbar.dart';
import 'package:chat/sql/models/02_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/style/color.dart';
// ignore: library_prefixes
// import 'package:socket_io_client/socket_io_client.dart' as IO;

Ctrl ctrl = Get.put(Ctrl());

class PageMenuHome extends StatefulWidget {
  const PageMenuHome({super.key});

  @override
  State<PageMenuHome> createState() => _PageMenuHomeState();
}

class _PageMenuHomeState extends State<PageMenuHome> {
  CtrlChat ctrlChat = Get.put(CtrlChat());
  int page = 1;

  void getDataUser() async {
    GlobalResponse res = await ctrlChat.actionListUser(context, page);
    if (!res.status) {
      WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
    }
  }

  @override
  void initState() {
    getDataUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CtrlChat>(builder: (c) {
      return c.isLoading
          ? loadingPage()
          : ListView.builder(
              itemCount: c.listUserSql.length,
              itemBuilder: (BuildContext context, int index) {
                SqlUser user = c.listUserSql[index];
                return cardUser(user);
              });
    });
  }

  Widget loadingPage() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 18,
        itemBuilder: (context, index) {
          return const WidgetLoadingUser();
        });
  }

  Widget cardUser(SqlUser user) {
    var generatedColor = Random().nextInt(Colors.primaries.length);
    String initial = '';
    String fullname = user.fullname;
    for (var i in fullname.split(" ")) {
      if (initial.length <= 2) {
        initial += '${i[0]}'.toUpperCase();
      }
    }

    return InkWell(
      onTap: () {
        Get.to(PageChatSingle(
          sqlUser: user,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.primaries[generatedColor]),
              child: Center(
                  child: Text(
                initial,
                style: const TextStyle(fontSize: 16),
              )),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Text(
                          user.fullname,
                          style: TextStyle(fontSize: 14, color: ColorsTheme.text1.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      user.status == '' ? 'There is no status' : user.status,
                      style: TextStyle(fontSize: 12, color: ColorsTheme.text1.withOpacity(0.5)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
