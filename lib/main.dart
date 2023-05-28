// ignore_for_file: library_prefixes, avoid_print
import 'dart:io';

import 'package:chat/controllers/ctrl_socket.dart';
import 'package:chat/sql/models/01_chat.dart';
import 'package:chat/sql/models/02_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'controllers/ctrl.dart';
import 'helpers/constant.dart';
import 'pages/page_splashscreen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path_provider/path_provider.dart';

Ctrl ctrl = Get.put(Ctrl());
CtrlSocket ctrlSocket = Get.put(CtrlSocket());
IO.Socket socket = IO.io(
    Constant.httpMainUrl, IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders({'Connection': 'upgrade', 'Upgrade': 'websocket'}).build());

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await db();
  await socketConnect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, title: Constant.appName, home: const SplashScreen());
  }
}

Future socketConnect() async {
  print("=======================================");
  ctrl.updateCon(false);
  ctrlSocket.setSocket(socket);
  socket.onConnect((_) {
    ctrl.updateCon(true);
    print("Socket Connected!");
  });
  socket.onDisconnect((_) {
    ctrl.updateCon(false);
    print("Socket Not Connected!");
  });
  socket.onConnectError((data) {
    ctrl.updateCon(false);
    print(data);
  });
  return;
}

Future db() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path;
  Hive.init(path);
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SqlChatAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(SqlUserAdapter());
  }
  await Hive.openBox<SqlUser>('userBox');
  await Hive.openBox<SqlChat>('chatBox');
  await Hive.openBox('dbChatBox');
  return;
}
