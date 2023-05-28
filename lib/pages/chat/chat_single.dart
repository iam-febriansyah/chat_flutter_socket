import 'package:chat/controllers/ctrl_chat.dart';
import 'package:chat/pages/widgets/widget_loading_chat.dart';
import 'package:chat/sql/models/01_chat.dart';
import 'package:chat/sql/models/02_user.dart';
import 'package:chat/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageChatSingle extends StatefulWidget {
  final SqlUser sqlUser;
  const PageChatSingle({super.key, required this.sqlUser});

  @override
  State<PageChatSingle> createState() => _PageChatSingleState();
}

class _PageChatSingleState extends State<PageChatSingle> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CtrlChat>(builder: (ctrl) {
      SqlUser user = ctrl.listUserSql.firstWhere((e) => e.userId == widget.sqlUser.userId);
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
              : ListView.builder(
                  itemCount: ctrl.listChatSql.length,
                  itemBuilder: (BuildContext context, int index) {
                    SqlChat chat = ctrl.listChatSql[index];
                    return cardChat(chat);
                  }));
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
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   height: 50,
          //   width: 50,
          //   decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.primaries[generatedColor]),
          //   child: Center(
          //       child: Text(
          //     initial,
          //     style: const TextStyle(fontSize: 16),
          //   )),
          // ),
          // const SizedBox(width: 8),
          // Expanded(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       SizedBox(
          //         height: 20,
          //         width: MediaQuery.of(context).size.width,
          //         child: Row(
          //           children: [
          //             Text(
          //               user.fullname,
          //               style: TextStyle(fontSize: 14, color: ColorsTheme.text1.withOpacity(0.7)),
          //             ),
          //           ],
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 4,
          //       ),
          //       SizedBox(
          //         height: 20,
          //         width: MediaQuery.of(context).size.width,
          //         child: Text(
          //           user.status == '' ? 'There is no status' : user.status,
          //           style: TextStyle(fontSize: 12, color: ColorsTheme.text1.withOpacity(0.5)),
          //         ),
          //       )
          //     ],
          // ),
          // ),
        ],
      ),
    );
  }
}
