class Book {
  int id;
  String title;
  String author;
  bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isAvailable,
  });

  // for JSON (Book to Map)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "author": author,
      "isAvailable": isAvailable,
    };
  }

  // from JSON (Map to Book)
  factory Book.fromJSON(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      isAvailable: json['isAvailable'],
    );
  }
}
