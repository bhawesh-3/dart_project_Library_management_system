import 'dart:io';

import 'package:library_management_system/cli/admin_cli.dart';
import 'package:library_management_system/cli/user_cli.dart';
import 'package:library_management_system/services/auth_service.dart';
import 'package:library_management_system/services/library_service.dart';

final _auth = AuthService();
final _library = LibraryService();

void runMenu() {
  while (true) {
    print('\n====== Library Management System ======');
    print('1. Admin Login');
    print('2. User Login');
    print('3. Exit');

    stdout.write('Enter choice: ');
    final choice = stdin.readLineSync()?.trim();

    if (choice == '1') {
      _handleAdminLogin();
    } else if (choice == '2') {
      _handleUserLogin();
    } else if (choice == '3') {
      print('Goodbye.');
      exit(0);
    } else {
      print('Invalid choice.');
    }
  }
}

void _handleAdminLogin() {
  stdout.write('Username: ');
  final username = stdin.readLineSync()?.trim() ?? '';

  stdout.write('Password: ');
  final password = stdin.readLineSync()?.trim() ?? '';

  if (username.isEmpty || password.isEmpty) {
    print('Username and password are required.');
    return;
  }

  try {
    final ok = _auth.loginAdmin(username, password);
    if (ok) {
      print('Admin login successful.');
      runAdminCli(_library);
    } else {
      print('Invalid admin credentials.');
    }
  } catch (e) {
    print('Error during admin login: $e');
  }
}

void _handleUserLogin() {
  stdout.write('User ID: ');
  final id = stdin.readLineSync()?.trim() ?? '';

  if (id.isEmpty) {
    print('User ID is required.');
    return;
  }

  try {
    final ok = _auth.loginUser(id);
    if (ok) {
      print('Login successful.');
      runUserCli(_library, id);
    } else {
      print('No user found with that ID.');
    }
  } catch (e) {
    print('Error during user login: $e');
  }
}
