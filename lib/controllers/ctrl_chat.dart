// ignore_for_file: unnecessary_overrides, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_null_comparison
import 'package:chat/api/api_services.dart';
import 'package:chat/controllers/ctrl.dart';
import 'package:chat/main.dart';
import 'package:chat/models/model_chat.dart';
import 'package:chat/models/model_response.dart';
import 'package:chat/models/model_user.dart';
import 'package:chat/pages/widgets/widget_snackbar.dart';
import 'package:chat/sql/models/01_chat.dart';
import 'package:chat/sql/models/02_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/helpers/constant.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar/sugar.dart';

class CtrlChat extends GetxController {
  ApiService apiService = ApiService();
  TextEditingController ctrlSearch = TextEditingController();
  Ctrl ctrl = Get.put(Ctrl());
  Box<SqlUser> userBox = Hive.box<SqlUser>('userBox');
  Box<SqlChat> chatBox = Hive.box<SqlChat>('chatBox');
  String domainIP = Constant.domainIP;
  String port = Constant.port;
  String mainUrl = Constant.mainUrl;
  String httpMainUrl = Constant.httpMainUrl;
  bool isLoading = true;
  bool isError = false;
  String remark = "";
  List<User> listUser = [];
  List<Chat> listChat = [];
  List<SqlUser> listUserSql = [];
  List<SqlChat> listChatSql = [];
  List<String> loadingChat = [];

  Future<GlobalResponse> actionListUser(BuildContext ctx, int page) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      isLoadingTrue(ctx);
      Map data = {};
      data['page'] = page;
      data['search'] = ctrlSearch.text;
      if (page == 1) {
        listUser = [];
      }
      var response = await apiService.apiChatListUser(ctx, data, pref.getString("PREF_TOKEN")!);
      if (response.status) {
        listUser.addAll(response.userList ?? []);
      }
      addUserDbAll(listUser);
      isLoadingFalse(ctx, response.status ? '' : response.remarks);
      return response;
    } catch (e) {
      return catchErr(ctx, e);
    }
  }

  Future<GlobalResponse> actionListChatUser(BuildContext ctx, int page, String userId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String fromUserId = pref.getString("PREF_USER_ID")!;
      List<SqlChat> chat = chatBox.values
          .where((e) =>
              (e.toUserId == userId && e.fromUserId == fromUserId) ||
              (e.fromUserId == userId && e.toUserId == fromUserId))
          .toList();
      if (chat.isEmpty) {
        isLoadingTrue(ctx);
      }
      Map data = {};
      data['page'] = page;
      data['to_user_id'] = userId;
      var response = await apiService.apiChatListChatUser(ctx, data, pref.getString("PREF_TOKEN")!);
      if (response.status) {
        listChat.addAll(response.chats ?? []);
      } else {
        WidgetSnackbar(context: ctx, message: response.remarks, warna: 'merah');
      }
      addChatDbAll(listChat);
      if (chat.isEmpty) {
        isLoadingFalse(ctx, response.status ? '' : response.remarks);
      }
      return response;
    } catch (e) {
      return catchErr(ctx, e);
    }
  }

  Future<GlobalResponse> actionSendMessage(BuildContext ctx, String chatId, String userId, String message, String file,
      String createdAt, String timeZone) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      final now = ZonedDateTime.now(Timezone('Asia/Jakarta'));
      int year = now.year;
      int month = now.month;
      int day = now.day;
      int hour = now.hour;
      int minute = now.minute;
      int second = now.second;
      DateTime nowDate = DateFormat("$year-$month-$day $hour:$minute:$second").parse(createdAt);
      String createdAtServer = DateFormat('yyyy-MM-dd HH:mm:ss').format(nowDate);

      Chat chat = Chat(
          chatId: chatId,
          fromUserId: pref.getString("PREF_USER_ID")!,
          toUserId: userId,
          message: message,
          isMe: '1',
          createdAt: createdAt,
          timeZone: timeZone,
          createdAtServer: createdAtServer);
      addChatDb(chat);

      isLoadingTrue(ctx);
      Map data = {};
      data['chat_id'] = chatId;
      data['to_user_id'] = userId;
      data['message'] = message;
      data['file'] = file;
      data['created_at'] = createdAt;
      data['time_zone'] = timeZone;
      var response = await apiService.apiChatSendMessage(ctx, data, pref.getString("PREF_TOKEN")!);
      isLoadingFalse(ctx, response.status ? '' : response.remarks);
      return response;
    } catch (e) {
      return catchErr(ctx, e);
    }
  }

  Future<GlobalResponse> actionDeleteMessage(BuildContext ctx, String chatId, String deletedAt) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      isLoadingTrue(ctx);
      Map data = {};
      data['chat_id'] = chatId;
      data['deleted_at'] = deletedAt;
      var response = await apiService.apiChatDeleteMessage(ctx, data, pref.getString("PREF_TOKEN")!);
      isLoadingFalse(ctx, response.status ? '' : response.remarks);
      return response;
    } catch (e) {
      return catchErr(ctx, e);
    }
  }

  void addUserDbAll(List<User> users) async {
    for (var e in users) {
      ctrlSocket.setSocketAnother(e.userId);
      Box<SqlUser> sqlUserBox = Hive.box<SqlUser>('userBox');
      SqlUser data = SqlUser(
          email: e.email,
          fullname: e.userDetail!.fullname,
          isOnline: e.isOnline!,
          status: e.userDetail!.status!,
          userId: e.userId);
      addUserDb(sqlUserBox, data);
    }
  }

  void addUserDb(Box<SqlUser> sqlUserBox, SqlUser e) async {
    sqlUserBox.put(e.userId, e);
    listUserSql = userBox.values.toList();
    update();
  }

  void addChatDbAll(List<Chat> chats) async {
    for (var e in chats) {
      addChatDb(e);
    }
  }

  void addChatDb(Chat e) async {
    try {
      Box<SqlChat> sqlChatBox = Hive.box<SqlChat>('chatBox');
      SqlChat data = SqlChat(
          chatId: e.chatId,
          createdAt: e.createdAt,
          createdAtServer: e.createdAtServer,
          file: e.file ?? '',
          fromUserId: e.fromUserId,
          message: e.message,
          readAt: e.readAt ?? '',
          timeZone: e.timeZone,
          toUserId: e.toUserId,
          isMe: e.isMe);
      sqlChatBox.put(e.chatId, data);
      listChatSql = chatBox.values.toList();
      update();
    } catch (e) {
      print(e);
    }
  }

  GlobalResponse catchErr(BuildContext ctx, e) {
    Map<String, dynamic> res = {};
    res['status'] = false;
    res['remarks'] = e.toString();
    isLoadingFalse(ctx, e.toString());
    print(e.toString());
    return GlobalResponse.fromJson(res);
  }

  void isLoadingTrue(BuildContext ctx) {
    isLoading = true;
    isError = false;
    update();
  }

  void isLoadingFalse(BuildContext ctx, String err) {
    FocusScope.of(ctx).requestFocus(FocusNode());
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
