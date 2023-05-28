// ignore_for_file: unnecessary_overrides, use_build_context_synchronously
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

  void setSocket(IO.Socket socketParam) async {
    socket = socketParam;
    update();
  }

  void setSocketUser(userId) async {
    socket!.on('sendMessage_$userId', (data) {
      print(data);
      updateChatSocket(data);
    });
    socket!.on('readMessage_$userId', (data) {
      updateChatSocket(data);
    });
    socket!.emit('online_$userId', "okkk");
    update();
  }

  void setSocketAnother(userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String meUserId = pref.getString("PREF_USER_ID")!;
    socket!.on('online_$userId', (data) {
      updateUserSocket(data, userId);
    });
    socket!.on('typing_$userId$meUserId', (data) {
      // //user_id is writer, meUserId is receiver
      //data is typing
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
    SqlUser user = ctrlChat.userBox.values.firstWhere((e) => e.userId == userId);
    if (user.userId.isNotEmpty) {
      user.isOnline = data;
      ctrlChat.addUserDb(sqlUserBox, user);
    }
  }

  void delSocketUser(userId) async {
    socket!.off('sendMessage_$userId');
    socket!.off('readMessage_$userId');
    update();
  }

  void emitStatusOnline(String status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString("PREF_USER_ID")!;
    print('online_$userId' + '_' + status);
    socket!.onConnect((_) {
      print("Socket Connected!!!!");
    });
    // socket!.onDisconnect((_) {
    //   print("Socket Not Connected!!!!");
    // });
    // socket!.onConnectError((data) {
    //   print(data);
    // });
    // socket!.onConnect((_) {
    //   print("socket connected");
    // });
    print('online_$userId' + '_--------------' + status);
    socket!.emit('online_a4b32aa0-fd36-11ed-935b-553987ecd9b3', status);
  }

  void emitTyping(String toUserId, String typing) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString("PREF_USER_ID")!;
    Map<String, dynamic> data = {};
    data['to_user_id'] = userId;
    data['message'] = typing;
    socket!.emit('typing_$toUserId', data);
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
