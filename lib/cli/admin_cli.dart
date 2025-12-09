import 'dart:io';

// import 'package:library_management_system/models/book.dart';
import 'package:library_management_system/services/library_service.dart';

void runAdminCli(LibraryService library) {
  while (true) {
    print('\n---- Admin Menu ----');
    print('1. View all books');
    print('2. Add book');
    print('3. Delete book');
    print('4. Update availability');
    print('5. View borrowed books');
    print('6. Add new user');
    print('0. Logout');

    stdout.write('Choice: ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        _viewAllBooks(library);
        break;
      case '2':
        _addBook(library);
        break;
      case '3':
        _deleteBook(library);
        break;
      case '4':
        _updateAvailability(library);
        break;
      case '5':
        _viewBorrowedBooks(library);
        break;
      case '6':
        _addNewUser(library);
        break;

      case '0':
        print('Logging out...');
        return;
      default:
        print('Invalid choice.');
    }
  }
}

void _viewAllBooks(LibraryService library) {
  final books = library.getBooks();
  if (books.isEmpty) {
    print('No books found.');
    return;
  }

  print('\nAll books:');
  for (final b in books) {
    print('ID: ${b.id} | ${b.title} by ${b.author} | Available: ${b.isAvailable}');
  }
}

void _addBook(LibraryService library) {
  stdout.write('Title: ');
  final title = stdin.readLineSync()?.trim() ?? '';
  stdout.write('Author: ');
  final author = stdin.readLineSync()?.trim() ?? '';

  if (title.isEmpty || author.isEmpty) {
    print('Title and author are required.');
    return;
  }

  final book = library.addBook(title, author);
  print('Added: ${book.id} - ${book.title}');
}

void _deleteBook(LibraryService library) {
  stdout.write('Book ID to delete: ');
  final id = stdin.readLineSync()?.trim() ?? '';

  if (id.isEmpty) {
    print('Book ID required.');
    return;
  }

  final ok = library.deleteBook(id);
  print(ok ? 'Book deleted.' : 'Book not found.');
}

void _updateAvailability(LibraryService library) {
  stdout.write('Book ID: ');
  final id = stdin.readLineSync()?.trim() ?? '';
  stdout.write('Available (true/false): ');
  final val = stdin.readLineSync()?.trim().toLowerCase();

  if (id.isEmpty || (val != 'true' && val != 'false')) {
    print('Invalid input.');
    return;
  }

  final ok = library.updateAvailability(id, val == 'true');
  print(ok ? 'Availability updated.' : 'Book not found.');
}

void _viewBorrowedBooks(LibraryService library) {
  final report = library.viewBorrowedBooks();
  if (report.isEmpty) {
    print('No borrowed books.');
    return;
  }

  print('\nBorrowed books:');
  for (final line in report) {
    print(line);
  }
}

void _addNewUser(LibraryService library) {
  stdout.write('Enter name of new user: ');
  final name = stdin.readLineSync()?.trim() ?? '';

  if (name.isEmpty) {
    print('Name is required.');
    return;
  }

  final user = library.addUser(name);
  print('User created successfully.');
  print('ID: ${user.id}  |  Name: ${user.name}');
}

