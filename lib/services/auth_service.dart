import 'package:library_management_system/models/user.dart';
import 'package:library_management_system/services/file_storage.dart';

class AuthService {
  final String usersFile = 'data/users.json';

  AuthService() {
    // Initialize file with defaults to avoid checks elsewhere
    FileStorage.ensureFile(usersFile, {
      'admins': [
        {'username': 'admin', 'password': 'admin123'}
      ],
      'users': [
        User(id: 'U1', name: 'Bhawesh').toJson(),
        User(id: 'U2', name: 'Pravas').toJson(),
      ]
    });
  }

  List<User> getUsers() {
    final data = FileStorage.readJson(usersFile);
    final users = (data['users'] as List? ?? []).cast<Map<String, dynamic>>();
    return users.map((u) => User.fromJson(u)).toList();
  }

  bool loginAdmin(String username, String password) {
    final data = FileStorage.readJson(usersFile);
    final admins = (data['admins'] as List? ?? []).cast<Map<String, dynamic>>();
    return admins.any((a) =>
        (a['username'] as String? ?? '') == username &&
        (a['password'] as String? ?? '') == password);
  }

  bool loginUser(String id) {
    return getUsers().any((u) => u.id == id);
  }
}
