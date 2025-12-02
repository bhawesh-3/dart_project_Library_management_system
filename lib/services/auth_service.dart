import 'dart:convert';
import 'dart:io';
import '../models/user.dart';

class AuthService {
  final String usersFile = "data/users.json";

  AuthService() {
    _initializeFiles();
  }

  void _initializeFiles() {
    final dir = Directory("data");
    if (!dir.existsSync()) dir.createSync();

    final file = File(usersFile);

    if (!file.existsSync()) {
      file.writeAsStringSync(jsonEncode({
        "admins": [
          {"username": "admin", "password": "admin123"}
        ],
        "users": [
          User(id: "U1", name: "Bhawesh").toJson(),
          User(id: "U2", name: "Pravas").toJson(),
        ]
      }));
    }
  }

  Map<String, dynamic> _readData() {
    return jsonDecode(File(usersFile).readAsStringSync());
  }

  bool loginAdmin(String username, String password) {
    final data = _readData();
    final admins = data["admins"];

    return admins.any(
        (a) => a["username"] == username && a["password"] == password);
  }

  bool loginUser(String id) {
    final data = _readData();
    List<User> users =
        (data["users"] as List).map((u) => User.fromJson(u)).toList();

    return users.any((u) => u.id == id);
  }
}
