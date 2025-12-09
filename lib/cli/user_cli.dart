import 'dart:io';

import 'package:library_management_system/services/library_service.dart';

void runUserCli(LibraryService library, String userId) {
  while (true) {
    print('\n---- User Menu ----');
    print('1. View available books');
    print('2. Borrow book');
    print('3. Return book');
    print('0. Logout');

    stdout.write('Choice: ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        _viewAvailable(library);
        break;
      case '2':
        _borrow(library, userId);
        break;
      case '3':
        _return(library, userId);
        break;
      case '0':
        print('Logging out...');
        return;
      default:
        print('Invalid choice.');
    }
  }
}

void _viewAvailable(LibraryService library) {
  final books = library.viewAvailableBooks();
  if (books.isEmpty) {
    print('No available books.');
    return;
  }

  print('\nAvailable books:');
  for (final b in books) {
    print('ID: ${b.id} | ${b.title} by ${b.author}');
  }
}

void _borrow(LibraryService library, String userId) {
  stdout.write('Book ID to borrow: ');
  final id = stdin.readLineSync()?.trim() ?? '';

  if (id.isEmpty) {
    print('Book ID required.');
    return;
  }

  final result = library.borrowBook(userId, id);
  switch (result) {
    case BorrowResult.success:
      print('Book borrowed successfully.');
      break;
    case BorrowResult.bookNotFound:
      print('Book not found.');
      break;
    case BorrowResult.notAvailable:
      print('Book is not available.');
      break;
    case BorrowResult.userNotFound:
      print('User not found.');
      break;
  }
}

void _return(LibraryService library, String userId) {
  stdout.write('Book ID to return: ');
  final id = stdin.readLineSync()?.trim() ?? '';

  if (id.isEmpty) {
    print('Book ID required.');
    return;
  }

  final result = library.returnBook(userId, id);
  switch (result) {
    case ReturnResult.success:
      print('Book returned successfully.');
      break;
    case ReturnResult.bookNotFound:
      print('Book not found.');
      break;
    case ReturnResult.userNotFound:
      print('User not found.');
      break;
    case ReturnResult.notBorrowed:
      print('This book was not borrowed by the user.');
      break;
  }
}
