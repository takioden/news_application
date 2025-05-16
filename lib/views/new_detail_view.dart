import 'package:flutter/material.dart';
import 'package:news_application/models/news_model.dart';

class NewsDetailView extends StatelessWidget {
  final News news;

  const NewsDetailView({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Berita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(news.content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
