import 'dart:io';
import 'package:library_management_system/services/auth_service.dart';
import 'package:library_management_system/services/library_service.dart';

final authService = AuthService();
final libraryService = LibraryService();

void main() {
  while (true) {
    print('\n====== Library Management System ======');
    print('Press 1 for Admin Login');
    print('Press 2 for User Login');
    print('Press 3 to Exit');

    stdout.write("\nEnter your choice: ");
    final String? loginType = stdin.readLineSync();

    if (loginType == '1') {
      adminLogin();
    } else if (loginType == "2") {
      userLogin();
    } else if (loginType == "3") {
      print("\nThank you for using the Library Management System!");
      exit(0);
    } else {
      print('\nInvalid choice. Please enter 1, 2, or 3.\n');
    }
  }
}

void adminLogin() {
  stdout.write('Enter your Username: ');
  String? username = stdin.readLineSync();
  
  stdout.write('Enter your password: ');
  String? password = stdin.readLineSync();
  
  if (username == null || username.isEmpty || 
      password == null || password.isEmpty) {
    print("Username and password cannot be empty.");
    return;
  }

  bool success = authService.loginAdmin(username, password);

  if (success) {
    print('\nAdmin login Successful!');
    adminPage();
  } else {
    print("Invalid username or password");
  }
}

void userLogin() {
  stdout.write("Enter your ID: ");
  String? id = stdin.readLineSync();
  
  if (id == null || id.isEmpty) {
    print("User ID cannot be empty.");
    return;
  }

  bool success = authService.loginUser(id);

  if (success) {
    print("\nLogin Successful!");
    userPage(id);
  } else {
    print("Invalid user Id");
  }
}

void adminPage() {
  while (true) {
    print("\n ====Admin Menu====");
    print("Enter 1 to View all books");
    print("Enter 2 to  Add book");
    print("Enetr 3 to Delete book");
    print("Enter 4 to Update book availability");
    print("Enter 5 to View borrowed books");
    print("Enter 0 Logout");

    stdout.write('Enter your choice: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        libraryService.viewBooks();
        break;

      case '2':
        stdout.write("Enter title: ");
        String? title = stdin.readLineSync();

        stdout.write("Enter author: ");
        String? author = stdin.readLineSync();

        if (title == null || title.isEmpty || author == null || author.isEmpty) {
          print("Title and author cannot be empty.");
          break;
        }

        libraryService.addBook(title, author);
        break;

      case '3':
        stdout.write("Enter a book id to delete: ");
        String? id = stdin.readLineSync();

        if (id == null || id.isEmpty) {
          print("Book ID cannot be empty.");
          break;
        }

        libraryService.deleteBook(id);
        break;

      case '4':
        stdout.write("Enter book ID: ");
        String? id = stdin.readLineSync();

        stdout.write("Set availability (true/false): ");
        String? value = stdin.readLineSync();

        if (id == null || id.isEmpty || value == null || value.isEmpty) {
          print("Book ID and availability value cannot be empty.");
          break;
        }
        
        libraryService.updateAvailability(id, value.toLowerCase() == "true");
        break;


      case '5':
        libraryService.viewBorrowedBooks();
        break;

      case '0':
        print("Logging out...");
        return;

      default:
        print("Invalid choice.");
    }
  }
}

void userPage(String userId) {
  while (true) {
    print("\n===== User Menu =====");
    print("Enter 1 to View available books");
    print("Enter 2 to Borrow book");
    print("Enetr 3 to Return book");
    print("Enter 0 to  Logout");

    stdout.write("Enter your choice: ");
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        libraryService.viewAvailableBooks();
        break;

      case '2':
        stdout.write("Enter book ID to borrow: ");
        String? id = stdin.readLineSync();

        if (id == null || id.isEmpty) {
          print("Book ID cannot be empty.");
          break;
        }

        libraryService.borrowBook(userId, id);
        break;

      case '3':
        stdout.write("Enter book ID to return: ");
        String? id = stdin.readLineSync();

         if (id == null || id.isEmpty) {
            print("Book ID cannot be empty.");
            break;
          }

        libraryService.returnBook(userId, id);
        break;

      case '0':
        print("Logging out...");
        return;

      default:
        print("Invalid choice.");
    }
  }
}
