// ignore_for_file: library_prefixes, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/ctrl.dart';
import 'pages/page_splashscreen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Ctrl ctrl = Get.put(Ctrl());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await socketConnect();
  runApp(const MyApp());
}

IO.Socket socket = IO.io(ctrl.httpMainUrl);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, title: 'EOEE', home: SplashScreen());
  }
}

Future<void> socketConnect() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("PREF_SOCKET", "Not Connected");
  socket.onConnect((_) {
    preferences.setString("PREF_SOCKET", "Connected");
    print("Socket Connected!");
  });
  socket.onDisconnect((_) {
    preferences.setString("PREF_SOCKET", "Not Connected");
    print("Socket Not Connected!");
  });
  return;
}
