import 'package:library_management_system/models/book.dart';
import 'package:library_management_system/models/user.dart';
import 'package:library_management_system/services/file_storage.dart';

enum BorrowResult { success, bookNotFound, notAvailable, userNotFound }
enum ReturnResult { success, bookNotFound, userNotFound, notBorrowed }

class LibraryService {
  final String booksFile = 'data/books.json';
  final String usersFile = 'data/users.json';

  LibraryService() {
    FileStorage.ensureFile(booksFile, {
      'books': [
        Book(id: 'B1', title: '1984', author: 'George Orwell', isAvailable: true)
            .toJson(),
        Book(
                id: 'B2',
                title: 'The Alchemist',
                author: 'Paulo Coelho',
                isAvailable: true)
            .toJson(),
      ]
    });

    // users file initialization is handled by AuthService (but safe to ensure here)
    FileStorage.ensureFile(usersFile, {'users': []});
  }

  List<Book> getBooks() {
    final data = FileStorage.readJson(booksFile);
    final raw = (data['books'] as List? ?? []).cast<Map<String, dynamic>>();
    return raw.map((b) => Book.fromJson(b)).toList();
  }

  List<User> getUsers() {
    final data = FileStorage.readJson(usersFile);
    final raw = (data['users'] as List? ?? []).cast<Map<String, dynamic>>();
    return raw.map((u) => User.fromJson(u)).toList();
  }

  void _saveBooks(List<Book> books) {
    FileStorage.writeJson(booksFile, {
      'books': books.map((b) => b.toJson()).toList(),
    });
  }

  void _saveUsers(List<User> users) {
    FileStorage.writeJson(usersFile, {
      'users': users.map((u) => u.toJson()).toList(),
    });
  }

  // ---------- Admin operations ----------

  /// Add a book. ID generation uses the maximum numeric suffix + 1.
  Book addBook(String title, String author) {
    final books = getBooks();

    // Find maximum numeric suffix among existing IDs like B1, B23
    int maxIndex = 0;
    for (final b in books) {
      final match = RegExp(r'^B(\d+)$').firstMatch(b.id);
      if (match != null) {
        final idx = int.tryParse(match.group(1)!) ?? 0;
        if (idx > maxIndex) maxIndex = idx;
      }
    }
    final newId = 'B${maxIndex + 1}';
    final book = Book(id: newId, title: title, author: author, isAvailable: true);
    books.add(book);
    _saveBooks(books);
    return book;
  }

  bool deleteBook(String id) {
    final books = getBooks();
    final initialLen = books.length;
    books.removeWhere((b) => b.id == id);
    if (books.length < initialLen) {
      _saveBooks(books);
      return true;
    }
    return false;
  }

  bool updateAvailability(String id, bool available) {
    final books = getBooks();
    final book = books.firstWhere((b) => b.id == id, orElse: () => Book(id: '', title: '', author: '', isAvailable: true));
    if (book.id.isEmpty) return false;
    book.isAvailable = available;
    _saveBooks(books);
    return true;
  }

  /// Returns lines to print about borrowed books (used by CLI).
  List<String> viewBorrowedBooks() {
    final users = getUsers();
    final lines = <String>[];
    for (final u in users) {
      if (u.borrowedBooks.isNotEmpty) {
        lines.add('${u.name} (${u.id}) -> ${u.borrowedBooks.join(', ')}');
      }
    }
    return lines;
  }

  User addUser(String name) {
  final users = getUsers();

  // Generate unique user ID
  int maxIndex = 0;
  for (final u in users) {
    final match = RegExp(r'^U(\d+)$').firstMatch(u.id);
    if (match != null) {
      final idx = int.tryParse(match.group(1)!) ?? 0;
      if (idx > maxIndex) maxIndex = idx;
    }
  }

  final newId = 'U${maxIndex + 1}';

  final user = User(id: newId, name: name);
  users.add(user);

  _saveUsers(users);

  return user;
}


  // ---------- User operations ----------

  List<Book> viewAvailableBooks() {
    return getBooks().where((b) => b.isAvailable).toList();
  }

  BorrowResult borrowBook(String userId, String bookId) {
    final books = getBooks();
    final users = getUsers();

    final book =
        books.firstWhere((b) => b.id == bookId, orElse: () => Book(id: '', title: '', author: '', isAvailable: true));
    if (book.id.isEmpty) return BorrowResult.bookNotFound;
    if (!book.isAvailable) return BorrowResult.notAvailable;

    final user = users.firstWhere((u) => u.id == userId, orElse: () => User(id: '', name: ''));
    if (user.id.isEmpty) return BorrowResult.userNotFound;

    user.borrowedBooks.add(bookId);
    book.isAvailable = false;

    _saveBooks(books);
    _saveUsers(users);
    return BorrowResult.success;
  }

  ReturnResult returnBook(String userId, String bookId) {
    final books = getBooks();
    final users = getUsers();

    final user = users.firstWhere((u) => u.id == userId, orElse: () => User(id: '', name: ''));
    if (user.id.isEmpty) return ReturnResult.userNotFound;

    if (!user.borrowedBooks.contains(bookId)) return ReturnResult.notBorrowed;

    user.borrowedBooks.remove(bookId);

    final book =
        books.firstWhere((b) => b.id == bookId, orElse: () => Book(id: '', title: '', author: '', isAvailable: true));
    if (book.id.isEmpty) return ReturnResult.bookNotFound;

    book.isAvailable = true;

    _saveBooks(books);
    _saveUsers(users);
    return ReturnResult.success;
  }
}
