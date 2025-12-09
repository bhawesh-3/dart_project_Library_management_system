class Book {
  String id;
  String title;
  String author;
  bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isAvailable,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'isAvailable': isAvailable,
      };

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] as String,
        title: json['title'] as String,
        author: json['author'] as String,
        isAvailable: json['isAvailable'] as bool,
      );
}
