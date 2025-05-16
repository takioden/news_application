import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsViewModel with ChangeNotifier {
  final NewsService _service = NewsService();
  List<News> _newsList = [];

  List<News> get newsList => _newsList;

  Future<void> loadNews() async {
    _newsList = await _service.fetchNews();
    notifyListeners();
  }

  Future<void> addNews(News news) async {
    await _service.addNews(news);
    await loadNews();
  }

  Future<void> updateNews(News news) async {
    await _service.updateNews(news);
    await loadNews();
  }

  Future<void> deleteNews(String id) async {
    await _service.deleteNews(id);
    await loadNews();
  }
}
