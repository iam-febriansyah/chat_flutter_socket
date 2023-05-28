class User {
  String userId;
  String email;
  String password;
  String? forgotCode;
  String? activate;
  String? createdAt;
  String? isOnline;
  String? updateAt;
  UserDetail? userDetail;

  User({
    required this.userId,
    required this.email,
    required this.password,
    this.forgotCode,
    this.activate,
    required this.createdAt,
    this.isOnline,
    this.updateAt,
    this.userDetail,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        email: json["email"],
        password: json["password"],
        forgotCode: json["forgot_code"] ?? '',
        activate: json["activate"] ?? '',
        createdAt: json["created_at"],
        isOnline: json["is_online"] ?? '',
        updateAt: json["update_at"] ?? '',
        userDetail: json["user_detail"] != null ? UserDetail.fromJson(json["user_detail"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "password": password,
        "forgot_code": forgotCode,
        "activate": activate,
        "created_at": createdAt,
        "is_online": isOnline,
        "update_at": updateAt,
      };
}

class UserDetail {
  String userDetailId;
  String userId;
  String fullname;
  String? status;
  String? statusUpdate;
  String createdAt;

  UserDetail({
    required this.userDetailId,
    required this.userId,
    required this.fullname,
    this.status,
    this.statusUpdate,
    required this.createdAt,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        userDetailId: json["user_detail_id"],
        userId: json["user_id"],
        fullname: json["fullname"],
        status: json["status"] ?? '',
        statusUpdate: json["status_update"] ?? '',
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "user_detail_id": userDetailId,
        "user_id": userId,
        "fullname": fullname,
        "created_at": createdAt,
      };
}
