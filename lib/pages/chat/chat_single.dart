// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:chat/controllers/ctrl_chat.dart';
import 'package:chat/controllers/ctrl_socket.dart';
import 'package:chat/pages/widgets/widget_loading_chat.dart';
import 'package:chat/sql/models/01_chat.dart';
import 'package:chat/sql/models/02_user.dart';
import 'package:chat/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PageChatSingle extends StatefulWidget {
  final SqlUser sqlUser;
  const PageChatSingle({super.key, required this.sqlUser});

  @override
  State<PageChatSingle> createState() => _PageChatSingleState();
}

class _PageChatSingleState extends State<PageChatSingle> {
  CtrlChat ctrlChat = Get.put(CtrlChat());
  CtrlSocket ctrlSocket = Get.put(CtrlSocket());
  TextEditingController ctrlTyping = TextEditingController();
  Timer? timer;

  void getChat(BuildContext ctx) async {
    await ctrlChat.actionListChatUser(ctx, 1, widget.sqlUser.userId);
  }

  void isTyping() {
    ctrlSocket.emitTyping(widget.sqlUser.userId, ctrlTyping.text);
  }

  void sendMessage(BuildContext ctx) async {
    try {
      DateTime now = DateTime.now();
      String chatId = '';
      String createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      String timeZone = now.timeZoneOffset.toString();
      ctrlChat.actionSendMessage(ctx, chatId, widget.sqlUser.userId, ctrlTyping.text, '', createdAt, timeZone);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getChat(context);
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => isTyping());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CtrlChat>(builder: (ctrl) {
      SqlUser user = ctrl.listUserSql.firstWhere((e) => e.userId == widget.sqlUser.userId);
      List<SqlChat> listChat = ctrl.listChatSql;
      listChat.sort((a, b) => a.createdAtServer.compareTo(b.createdAtServer));
      return Scaffold(
          appBar: AppBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullname,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    user.isOnline == '' ? 'Offline' : user.isOnline,
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                  ),
                ],
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: ColorsTheme.primary1,
              elevation: 0),
          body: ctrl.isLoading
              ? loadingPage()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: listChat.length,
                          itemBuilder: (BuildContext context, int index) {
                            SqlChat chat = listChat[index];
                            return cardChat(chat);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsTheme.background2,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: ctrlTyping,
                                  decoration: const InputDecoration(border: InputBorder.none, hintText: ''),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              IconButton(
                                  onPressed: () {
                                    sendMessage(context);
                                  },
                                  icon: const Icon(Icons.send_sharp))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
    });
  }

  Widget loadingPage() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 18,
        itemBuilder: (context, index) {
          return const WidgetLoadingChat();
        });
  }

  Widget cardChat(SqlChat chat) {
    // var generatedColor = Random().nextInt(Colors.primaries.length);
    // String initial = '';
    // String fullname = user.fullname;
    // for (var i in fullname.split(" ")) {
    //   if (initial.length <= 2) {
    //     initial += '${i[0]}'.toUpperCase();
    //   }
    // }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsTheme.background3,
          borderRadius: BorderRadius.only(
            topRight: chat.isMe == '1' ? const Radius.circular(0) : const Radius.circular(8),
            topLeft: chat.isMe == '1' ? const Radius.circular(8) : const Radius.circular(0),
            bottomRight: const Radius.circular(8),
            bottomLeft: const Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: chat.isMe == '1' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                chat.message,
                style: TextStyle(color: ColorsTheme.text1.withOpacity(0.8), fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
