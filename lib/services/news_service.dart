import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/news_model.dart';

class NewsService {
  final CollectionReference _newsRef =
      FirebaseFirestore.instance.collection('news');

  Future<List<News>> fetchNews() async {
    final snapshot = await _newsRef.get();
    return snapshot.docs
        .map((doc) => News.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addNews(News news) {
    return _newsRef.add(news.toMap());
  }

  Future<void> updateNews(News news) {
    return _newsRef.doc(news.id).update(news.toMap());
  }

  Future<void> deleteNews(String id) {
    return _newsRef.doc(id).delete();
  }
}
