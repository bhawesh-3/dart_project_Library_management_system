import 'dart:convert';
import 'dart:io';

import '../models/book.dart';
import '../models/user.dart';

class LibraryService {
  final String booksFile = "data/books.json";
  final String usersFile = "data/users.json";

  LibraryService() {
    _initializeFiles();
  }

  void _initializeFiles() {
    final dir = Directory("data");
    if (!dir.existsSync()) dir.createSync();

    final file = File(booksFile);
    if (!file.existsSync()) {
      file.writeAsStringSync(jsonEncode({
        "books": [
          Book(id: "B1", title: "1984", author: "George Orwell", isAvailable: true).toJson(),
          Book(id: "B2", title: "The Alchemist", author: "Paulo Coelho", isAvailable: true).toJson(),
        ]
      }));
    }
  }

  // ================= FILE HELPERS =================

  List<Book> _readBooks() {
    final data = jsonDecode(File(booksFile).readAsStringSync());
    return (data["books"] as List)
        .map((b) => Book.fromJson(b))
        .toList();
  }

  List<User> _readUsers() {
    final data = jsonDecode(File(usersFile).readAsStringSync());
    return (data["users"] as List)
        .map((u) => User.fromJson(u))
        .toList();
  }

  void _saveBooks(List<Book> books) {
    File(booksFile).writeAsStringSync(jsonEncode({
      "books": books.map((b) => b.toJson()).toList(),
    }));
  }

  void _saveUsers(List<User> users) {
    File(usersFile).writeAsStringSync(jsonEncode({
      "users": users.map((u) => u.toJson()).toList(),
    }));
  }

  // ===================== ADMIN =====================

  void viewBooks() {
    final books = _readBooks();

    print("\n===== All Books =====");
    for (var b in books) {
      print("ID: ${b.id} | ${b.title} by ${b.author} | Available: ${b.isAvailable}");
    }
  }

  void addBook(String title, String author) {
    final books = _readBooks();
    final newId = "B${books.length + 1}";

    books.add(Book(id: newId, title: title, author: author, isAvailable: true));

    _saveBooks(books);
    print("Book added.");
  }

  void deleteBook(String id) {
    final books = _readBooks();
    books.removeWhere((book) => book.id == id);

    _saveBooks(books);
    print("Book deleted.");
  }

  void updateAvailability(String id, bool value) {
    final books = _readBooks();

    try {
      final book = books.firstWhere((b) => b.id == id);
      book.isAvailable = value;
      _saveBooks(books);
      print("Availability updated.");
    } catch (e) {
      print("Book not found.");
    }
  }

  void viewBorrowedBooks() {
    final users = _readUsers();
    
    print("\n===== Borrowed Books =====");
    bool hasBorrowedBooks = false;
    
    for (var user in users) {
      if (user.borrowedBooks.isNotEmpty) {
        hasBorrowedBooks = true;
        print("${user.name} (${user.id}) borrowed: ${user.borrowedBooks.join(', ')}");
      }
    }
    
    if (!hasBorrowedBooks) {
      print("No books are currently borrowed.");
    }
  }

  // ===================== USER =====================

  void viewAvailableBooks() {
    final books = _readBooks();

    print("\n===== Available Books =====");
    for (var b in books.where((b) => b.isAvailable)) {
      print("ID: ${b.id} | ${b.title} by ${b.author}");
    }
  }

  void borrowBook(String userId, String bookId) {
    final books = _readBooks();
    final users = _readUsers();

    try {
      // Find the book
      final book = books.firstWhere((b) => b.id == bookId);
      
      if (!book.isAvailable) {
        print("Book is already borrowed.");
        return;
      }

      // Find the user
      final user = users.firstWhere((u) => u.id == userId);
      
      // Store string book ID, not integer
      user.borrowedBooks.add(bookId);
      book.isAvailable = false;

      _saveBooks(books);
      _saveUsers(users);

      print("Book borrowed successfully.");
    } catch (e) {
      print("Book or User not found.");
    }
  }

  void returnBook(String userId, String bookId) {
    final books = _readBooks();
    final users = _readUsers();

    try {
      final user = users.firstWhere((u) => u.id == userId);
      
      if (!user.borrowedBooks.contains(bookId)) {
        print("This user didn't borrow that book.");
        return;
      }

      user.borrowedBooks.remove(bookId);
      
      final book = books.firstWhere((b) => b.id == bookId);
      book.isAvailable = true;

      _saveBooks(books);
      _saveUsers(users);

      print("Book returned successfully.");
    } catch (e) {
      print("Book or User not found.");
    }
  }
}