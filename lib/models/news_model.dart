class News {
  String? id;
  String title;
  String content;

  News({this.id, required this.title, required this.content});

  factory News.fromMap(Map<String, dynamic> data, String docId) {
    return News(
      id: docId,
      title: data['title'],
      content: data['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }
}
