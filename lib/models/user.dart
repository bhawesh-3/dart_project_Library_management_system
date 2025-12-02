class User {
  String id;
  String name;
  List<String> borrowedBooks;

  User({
    required this.id,
    required this.name,
    List<String>? borrowedBooks,
  }) : borrowedBooks = borrowedBooks ?? [];

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "borrowedBooks": borrowedBooks,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    borrowedBooks: List<String>.from(json['borrowedBooks']),
  );
}
