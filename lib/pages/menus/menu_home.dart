// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/pages/page_list.dart';
import 'package:chat/style/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../api/api_services.dart';
import '../../controllers/ctrl.dart';
import '../../models/model_response.dart';
import '../widgets/widget_loading_page.dart';
import '../widgets/widget_progress.dart';
import '../widgets/widget_snackbar.dart';

Ctrl ctrl = Get.put(Ctrl());

class PageMenuHome extends StatefulWidget {
  const PageMenuHome({super.key});

  @override
  State<PageMenuHome> createState() => _PageMenuHomeState();
}

class _PageMenuHomeState extends State<PageMenuHome> {
  final ApiService _apiService = ApiService();
  List<StatusMachine> dataStatus = [];
  List<GeneralList> dataMachine = [];
  bool loading = true;
  String machineText = 'Pilih Mesin';
  String machine = '';
  String ipaddress = '';
  String connectedString = '';
  String color = "#FFFFFF";
  String fontcolor = "#000000";
  int connected = 0;
  IO.Socket socket = IO.io(ctrl.httpMainUrl);
  int socketMain = 1;
  Timer? timer;

  void connectAndListen() {
    socket.onConnect((_) {
      print("socket connected $ipaddress");
    });
    socket.on('plc_con_$ipaddress', (data) {
      if (data['ip'] == ipaddress) {
        var pConnected = 1;
        var pConnectedString = 'Sedang mengecek koneksi ke PLC';
        if (data['status']) {
          pConnected = 2;
          pConnectedString = 'Connected';
          color = data['color'];
          fontcolor = data['fontcolor'];
        } else {
          pConnected = 3;
          pConnectedString = 'Not Connected';
          color = data['color'];
          fontcolor = data['fontcolor'];
        }
        set(pConnected, pConnectedString, color, fontcolor);
      }
    });
    socket.on('plc_status_$ipaddress', (data) {
      if (data['ip'] == ipaddress) {
        var pConnected = 2;
        var pConnectedString = "Status : " + data['status'].toString();
        color = data['color'];
        fontcolor = data['fontcolor'];
        set(pConnected, pConnectedString, color, fontcolor);
      }
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  void set(pConnected, pConnectedString, pColor, pFontcolor) {
    if (pConnectedString != connectedString) {
      if (mounted) {
        setState(() {
          connected = pConnected;
          connectedString = pConnectedString;
          color = pColor;
          fontcolor = pFontcolor;
        });
        print(connected.toString() + ' => ' + connectedString);
      }
    }
  }

  void getDataStatus() async {
    // if (mounted) {
    //   setState(() {
    //     loading = true;
    //   });
    // }
    // await _apiService.apiStatusMachine().then((res) async {
    //   if (res.status) {
    //     await getMachine();
    //     if (mounted) {
    //       dataStatus = [];
    //       setState(() {
    //         for (var e in res.statusMachines!) {
    //           if (e.show) {
    //             dataStatus.add(StatusMachine(
    //                 id: e.id,
    //                 address: e.address,
    //                 status: e.status,
    //                 show: e.show,
    //                 color: e.color,
    //                 fontcolor: e.fontcolor));
    //           }
    //         }
    //       });
    //     }
    //   } else {
    //     WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
    //   }
    // });
    // if (mounted) {
    //   setState(() {
    //     loading = false;
    //   });
    // }
  }

  Future getMachine() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // await _apiService.apiGetMachine(preferences.getString("PREF_USERNAME")!).then((res) {
    //   if (res.status) {
    //     if (mounted) {
    //       setState(() {
    //         for (var e in res.machines!) {
    //           dataMachine.add(GeneralList(id: e.id.toString(), title: e.noMesin, subtitle: e.ipAddress));
    //         }
    //       });
    //     }
    //   } else {
    //     WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
    //   }
    // });
    // return;
  }

  void getStatusMachine() async {
    // await _apiService.apiCheckCon(ipaddress).then((res) {
    //   if (!res.status) {
    //     // WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
    //   } else {
    //     connectAndListen();
    //   }
    // });
  }

  void changeStatusMachine(String ipaddress, int status) async {
    // showDialog(
    //     context: context, barrierDismissible: false, builder: (BuildContext context) => const WidgetProgressSubmit());
    // await _apiService.apiChangeStatus(ipaddress, status).then((res) {
    //   Navigator.of(context, rootNavigator: true).pop();
    //   if (!res.status) {
    //     WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
    //   } else {
    //     print(res.remarks);
    //     WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
    //   }
    //   getStatusMachine();
    // });
  }

  int setColor(hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  void checkConnection() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var con = preferences.getString("PREF_SOCKET") ?? "Not Connected";
    if (socketMain == 0 && con == "Connected") {
      getDataStatus();
    }
    if (mounted) {
      setState(() {
        if (con == "Not Connected") {
          socketMain = 0;
        } else if (con == "Connected") {
          socketMain = 1;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataStatus();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => checkConnection());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const WidgetLoadingPage()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PageList(datas: dataMachine, title: "List Mesin")),
                    );
                    setState(() {
                      if (result != null) {
                        machineText = result.title + ' (' + result.subtitle + ')';
                        machine = result.title;
                        ipaddress = result.subtitle;
                        connectedString = 'Sedang mengecek koneksi ke PLC';
                        connected = 1;
                        getStatusMachine();
                      }
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ColorsTheme.grey,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Expanded(child: Text(machineText)), const Icon(Icons.arrow_drop_down)],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                connected != 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: connected == 2
                                      ? ColorsTheme.hijau.withOpacity(0.3)
                                      : ColorsTheme.merah.withOpacity(0.3)),
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              color: connected == 2
                                  ? ColorsTheme.hijau.withOpacity(0.1)
                                  : ColorsTheme.merah.withOpacity(0.1)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: connected == 1
                                ? Row(
                                    children: [
                                      const CupertinoActivityIndicator(),
                                      const SizedBox(width: 6),
                                      Text(connectedString)
                                    ],
                                  )
                                : Text(connectedString),
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 3),
                      itemCount: dataStatus.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {
                            if (connected == 2) {
                              changeStatusMachine(ipaddress, dataStatus[index].address);
                            } else {
                              WidgetSnackbar(
                                  context: context,
                                  message: "Mohon tunggu sampai PLC berhasil terhubung",
                                  warna: "merah");
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(setColor(dataStatus[index].color)),
                                border: Border.all(color: Colors.black87),
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              dataStatus[index].status,
                              style: TextStyle(color: Color(setColor(dataStatus[index].fontcolor)), fontSize: 16),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
  }
}
