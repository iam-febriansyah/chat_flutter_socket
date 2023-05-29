// import 'dart:io';

// import 'dart:async';
// import 'package:chat/sql/models/chat.dart';
// import 'package:chat/sql/models/user.dart';
// import 'package:path_provider/path_provider.dart';

// import 'package:sqflite/sqflite.dart';

// class DbHelper {
//   static DbHelper? _dbHelper;
//   static Database? _database;

//   DbHelper._createObject();

//   factory DbHelper() {
//     _dbHelper ??= DbHelper._createObject();
//     return _dbHelper!;
//   }

//   Future<Database> initDb() async {
//     print("initDb");
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = '${directory.path}/chats.db';
//     Database todoDatabase = await openDatabase(path, version: 4, onCreate: _createDb);
//     return todoDatabase;
//   }

//   void _createDb(Database db, int version) async {
//     print("CREATE TABLE");
//     try {
//       await db.execute('DROP TABLE users');
//       await db.execute('DROP TABLE chats');
//       await db.execute('''
//       CREATE TABLE users (
//         user_id TEXT PRIMARY KEY,
//         email TEXT,
//         is_online TEXT,
//         fullname TEXT,
//         status TEXT
//       )
//     ''');

//       await db.execute('''
//       CREATE TABLE chats (
//         chat_id TEXT PRIMARY KEY,
//         from_user_id TEXT,
//         to_user_id TEXT,
//         message TEXT,
//         file TEXT,
//         created_at TEXT,
//         time_zone TEXT,
//         read_at TEXT,
//         created_at_server TEXT
//       )
//     ''');
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<Database> get database async {
//     _database ??= await initDb();
//     return _database!;
//   }

//   Future<List<Map<String, dynamic>>> select() async {
//     Database db = await database;
//     var mapList = await db.query('contact', orderBy: 'name');
//     return mapList;
//   }

//   //create
//   Future<int> insertUser(UserSqlite object) async {
//     Database db = await database;
//     int count = await db.insert('users', object.toMap());
//     return count;
//   }

//   //update
//   Future<int> updateUser(UserSqlite object) async {
//     Database db = await database;
//     int count = await db.update('users', object.toMap(), where: 'user_id=?', whereArgs: [object.userId]);
//     return count;
//   }

//   //delete
//   Future<int> deleteUser(String userId) async {
//     Database db = await database;
//     int count = await db.delete('users', where: 'user_id=?', whereArgs: [userId]);
//     return count;
//   }

//   Future<List<UserSqlite>> listUser() async {
//     Database db = await database;
//     var contactMapList = await db.rawQuery("SELECT * FROM users");
//     int count = contactMapList.length;
//     List<UserSqlite> contactList = [];
//     for (int i = 0; i < count; i++) {
//       contactList.add(UserSqlite.fromMap(contactMapList[i]));
//     }
//     return contactList;
//   }

//   //create
//   Future<int> insertChat(ChatSqlite object) async {
//     Database db = await database;
//     int count = await db.insert('chats', object.toMap());
//     return count;
//   }

//   //update
//   Future<int> updateChat(ChatSqlite object) async {
//     Database db = await database;
//     int count = await db.update('chats', object.toMap(), where: 'chat_id=?', whereArgs: [object.chatId]);
//     return count;
//   }

//   //delete
//   Future<int> deleteChat(String chatId) async {
//     Database db = await database;
//     int count = await db.delete('chats', where: 'chat_id=?', whereArgs: [chatId]);
//     return count;
//   }

//   Future<List<UserSqlite>> listChat(String fromUserId, String toUserId) async {
//     Database db = await database;
//     var contactMapList = await db.rawQuery(
//         "SELECT * FROM chats WHERE (from_user_id = '$fromUserId' AND to_user_id = '$toUserId') OR (to_user_id = '$fromUserId' AND from_user_id = '$toUserId') OR ");
//     int count = contactMapList.length;
//     List<UserSqlite> contactList = [];
//     for (int i = 0; i < count; i++) {
//       contactList.add(UserSqlite.fromMap(contactMapList[i]));
//     }
//     return contactList;
//   }
// }
