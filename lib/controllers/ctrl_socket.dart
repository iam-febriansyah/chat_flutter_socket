// ignore_for_file: unnecessary_overrides, use_build_context_synchronously, library_prefixes, avoid_print, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, unnecessary_null_comparison
import 'package:chat/controllers/ctrl_chat.dart';
import 'package:chat/models/model_chat.dart';
import 'package:chat/sql/models/02_user.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CtrlSocket extends GetxController {
  CtrlChat ctrlChat = Get.put(CtrlChat());
  IO.Socket? socket;
  List<String> listTyping = [];

  void setSocket(IO.Socket socketParam) async {
    socket = socketParam;
    update();
  }

  void setSocketMe(userId) async {
    socket!.on('sendMessage_$userId', (data) {
      updateChatSocket(data);
    });
    socket!.on('readMessage_$userId', (data) {
      updateChatSocket(data);
    });
    socket!.on('bot_$userId', (data) {
      updateChatSocket(data);
    });
    update();
  }

  void setSocketAnother(userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String meUserId = pref.getString("PREF_USER_ID")!;
    socket!.on('online_$userId', (data) {
      updateUserSocket(data, userId);
    });
    socket!.on('typing_' + meUserId + '_' + userId, (data) {
      updateUserSocket(data, userId);
    });
    update();
  }

  void updateChatSocket(data) {
    String chatId = data["chat_id"] ?? '';
    String fromUserId = data["from_user_id"] ?? '';
    String toUserId = data["to_user_id"] ?? '';
    String message = data["message"] ?? '';
    String file = data["file"] ?? '' ?? '';
    String createdAt = data["created_at"] ?? '';
    String isMe = data["is_me"] ?? '';
    String timeZone = data["time_zone"] ?? '';
    String readAt = data["read_at"] ?? '' ?? '';
    String deletedAt = data["deleted_at"] ?? '' ?? '';
    String createdAtServer = data["created_at_server"] ?? '';
    String deletedAtServer = data["deleted_at_server"] ?? '' ?? '';
    Chat e = Chat(
        chatId: chatId,
        fromUserId: fromUserId,
        toUserId: toUserId,
        message: message,
        isMe: isMe,
        createdAt: createdAt,
        timeZone: timeZone,
        createdAtServer: createdAtServer,
        file: file,
        readAt: readAt,
        deletedAt: deletedAt,
        deletedAtServer: deletedAtServer);
    ctrlChat.addChatDb(e);
  }

  void updateUserSocket(data, userId) {
    Box<SqlUser> sqlUserBox = Hive.box<SqlUser>('userBox');
    List<SqlUser> user = ctrlChat.userBox.values.where((e) => e.userId == userId).toList();
    if (user.isNotEmpty) {
      user[0].isOnline = data;
      ctrlChat.addUserDb(sqlUserBox, user[0]);
    }
  }

  void delSocketUser(userId) async {
    socket!.emit('online_$userId', 'Logout');
    socket!.off('sendMessage_$userId');
    socket!.off('readMessage_$userId');
    socket!.disconnect();
    update();
  }

  void emitStatusOnline(String status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString("PREF_USER_ID") ?? '';
    if (!isTyping(userId)) {
      socket!.emit('online_$userId', status);
    }
  }

  void emitTyping(String toUserId, String typing) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString("PREF_USER_ID") ?? '';
    Map<String, dynamic> data = {};
    data['to_user_id'] = userId;
    data['message'] = typing;
    if (typing == '') {
      listTyping.remove(userId);
      update();
      emitStatusOnline("Online");
    } else {
      String cek = listTyping.firstWhere((e) => e == userId, orElse: () => '');
      if (cek == '') {
        listTyping.add(userId);
        update();
      }
      socket!.emit('typing_$toUserId', data);
    }
  }

  bool isTyping(String userId) {
    String cek = listTyping.firstWhere((e) => e == userId, orElse: () => '');
    if (cek != '') {
      return true;
    }
    return false;
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
