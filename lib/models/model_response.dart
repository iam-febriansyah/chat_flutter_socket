// To parse this JSON data, do
//
//     final loginResponse = globalResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/model_chat.dart';

import 'model_user.dart';

GlobalResponse globalResponseFromJson(String str) => GlobalResponse.fromJson(json.decode(str));

String globalResponseToJson(GlobalResponse data) => json.encode(data.toJson());

class GlobalResponse {
  bool status;
  String remarks;
  String? token;
  User? user;
  List<User>? userList;
  List<Chat>? chats;
  UserDetail? userDetail;

  GlobalResponse({
    required this.status,
    required this.remarks,
    this.token,
    this.user,
    this.userList,
    this.chats,
    this.userDetail,
  });

  factory GlobalResponse.fromJson(Map<String, dynamic> json) => GlobalResponse(
        status: json["status"],
        remarks: json["remarks"],
        token: json["token"] ?? '',
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        userDetail: json["user_detail"] != null ? UserDetail.fromJson(json["user_detail"]) : null,
        userList: json["user_list"] != null ? List<User>.from(json["user_list"].map((x) => User.fromJson(x))) : [],
        chats: json["chats"] != null ? List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "remarks": remarks,
        "token": token ?? '',
        "user": user,
        "user_detail": userDetail,
        "user_list": userList,
        "chats": chats,
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
