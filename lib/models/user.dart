class User {
  int id;
  String name;
  List<int> borrowedBooks;

  User({required this.id, required this.name, List<int>? borrowedBooks})
    : borrowedBooks = borrowedBooks ?? [];

  // for json (user to map)
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'borrowedBooks': borrowedBooks};
  }

  // from json (Map to User )
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      borrowedBooks: json['borrowedBooks'],
    );
  }
}
