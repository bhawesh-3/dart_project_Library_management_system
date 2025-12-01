import 'dart:io';

final authService = authService();
final libraryService = libraryService();

void main() {
  while (true) {
    print('\n ======Library Management System=====');
    print('Press 1 for Admin Login ');
    print('Press 2 for User Login ');
    print('Press 3 to Exit ');

    stdout.write("Enter your choice : ");
    final String? loginType = stdin.readLineSync();

    if (loginType == '1') {
      return adminLogin();
    } else if (loginType == "2") {
      return userLogin();
    } else if (loginType == "3") {
      print("Thank you for using");
    } else {
      print('Enter a valid choice');
      return;
    }
  }
}

void adminLogin() {
  stdout.write('Enter your Username: ');
  String? username = stdin.readLineSync();

  stdout.write('Enter your password: ');
  String? password = stdin.readLineSync();

  bool success = authService.loginAdmin(username!, password!);

  if (success) {
    print('\n Admin login Successful');
    adminPage();
  } else {
    print("Invalid username or password");
  }
}

void userLogin() {
  stdout.write("Enter your ID: ");
  String? id = stdin.readLineSync();

  bool success = authService.loginUser(id!);

  if (success) {
    print("\n Login Successful");
    userPage(id);
  } else {
    print("Invalid user Id");
  }
}

void adminPage() {
  while (true) {
    print("====Admin Menu====");
    print("Enter 1 to View all books");
    print("Enter 2 to  Add book");
    print("Enetr 3 to Delete book");
    print("Enter 4 to Update book availability");
    print("Enter 5 to  View borrowed books");
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

        libraryService.addBook(title!, author!);
        break;

      case '3':
        stdout.write("Enter a book id to delete: ");
        String? id = stdin.readLineSync();

        libraryService.deleteBook(id!);
        break;
        
      case '4': 
        stdout.write("Enter book ID: ");
        String? id = stdin.readLineSync();

        stdout.write("Set availability (true/false): ");
        String? value = stdin.readLineSync();

        libraryService.updateAvailability(id!, value == "true");
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

        libraryService.borrowBook(userId, id!);
        break;

      case '3':
        stdout.write("Enter book ID to return: ");
        String? id = stdin.readLineSync();

        libraryService.returnBook(userId, id!);
        break;

      case '0':
        print("Logging out...");
        return;

      default:
        print("Invalid choice.");
    }
  }
}
