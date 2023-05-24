// To parse this JSON data, do
//
//     final loginResponse = globalResponseFromJson(jsonString);

import 'dart:convert';

GlobalResponse globalResponseFromJson(String str) => GlobalResponse.fromJson(json.decode(str));

String globalResponseToJson(GlobalResponse data) => json.encode(data.toJson());

class GlobalResponse {
  bool status;
  String remarks;
  User? user;
  List<Machine>? machines;
  List<StatusMachine>? statusMachines;

  GlobalResponse({
    required this.status,
    required this.remarks,
    this.user,
    this.machines,
    this.statusMachines,
  });

  factory GlobalResponse.fromJson(Map<String, dynamic> json) => GlobalResponse(
        status: json["status"],
        remarks: json["remarks"],
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        machines: json["machines"] != null ? List<Machine>.from(json["machines"].map((x) => Machine.fromJson(x))) : [],
        statusMachines: json["list_status"] != null
            ? List<StatusMachine>.from(json["list_status"].map((x) => StatusMachine.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "remarks": remarks,
      };
}

class User {
  int id;
  String userName;
  String password;

  User({
    required this.id,
    required this.userName,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["Id"],
        userName: json["UserName"],
        password: json["Password"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "UserName": userName,
        "Password": password,
      };
}

class Machine {
  int id;
  String userLogin;
  String noMesin;
  String ipAddress;

  Machine({
    required this.id,
    required this.userLogin,
    required this.noMesin,
    required this.ipAddress,
  });

  factory Machine.fromJson(Map<String, dynamic> json) => Machine(
        id: json["Id"],
        userLogin: json["UserLogin"],
        noMesin: json["NoMesin"],
        ipAddress: json["IPAddress"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "UserLogin": userLogin,
        "NoMesin": noMesin,
        "IPAddress": ipAddress,
      };
}

class StatusMachine {
  int id;
  int address;
  String status;
  bool show;
  String color;
  String fontcolor;

  StatusMachine({
    required this.id,
    required this.address,
    required this.status,
    required this.show,
    required this.color,
    required this.fontcolor,
  });

  factory StatusMachine.fromJson(Map<String, dynamic> json) => StatusMachine(
        id: json["id"],
        address: json["address"],
        status: json["status"],
        show: json["show"],
        color: json["color"],
        fontcolor: json["fontcolor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "status": status,
        "show": show,
        "color": color,
        "fontcolor": fontcolor,
      };
}

class GeneralList {
  String id;
  String title;
  String subtitle;

  GeneralList({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  factory GeneralList.fromJson(Map<String, dynamic> json) => GeneralList(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "Password": subtitle,
      };
}
