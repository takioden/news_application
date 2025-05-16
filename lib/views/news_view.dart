import 'package:flutter/material.dart';
import 'package:news_application/models/news_model.dart';
import 'package:news_application/viewmodels/news_viewmodel.dart';
import 'package:news_application/views/new_detail_view.dart';
import 'package:provider/provider.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();

  late Future<void> _newsFuture;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<NewsViewModel>(context, listen: false);
    _newsFuture = viewModel.loadNews();
  }

  void _showDialog(BuildContext context, {News? news}) {
    if (news != null) {
      titleCtrl.text = news.title;
      contentCtrl.text = news.content;
    } else {
      titleCtrl.clear();
      contentCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(news == null ? 'Add News' : 'Edit News'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: contentCtrl, decoration: InputDecoration(labelText: 'Content')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newNews = News(
                id: news?.id,
                title: titleCtrl.text,
                content: contentCtrl.text,
              );

              final viewModel = Provider.of<NewsViewModel>(context, listen: false);
              if (news == null) {
                await viewModel.addNews(newNews);
              } else {
                await viewModel.updateNews(newNews);
              }

              setState(() {
                _newsFuture = viewModel.loadNews(); 
              });

              Navigator.pop(context);
            },
            child: Text(news == null ? 'Add' : 'Update'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NewsViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Berita')),
      body: FutureBuilder(
        future: _newsFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (viewModel.newsList.isEmpty) {
            return const Center(child: Text("Tidak ada berita"));
          }

         return ListView.builder(
  itemCount: viewModel.newsList.length,
  itemBuilder: (_, index) {
    final news = viewModel.newsList[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailView(news: news)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          title: Text(news.title),
          subtitle: Text(
            news.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () => _showDialog(context, news: news)),
              IconButton(icon: Icon(Icons.delete), onPressed: () async {
                await viewModel.deleteNews(news.id!);
                setState(() {
                  _newsFuture = viewModel.loadNews();
                });
              }),
            ],
          ),
        ),
      ),
    );
  },
);

        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showDialog(context),
      ),
    );
  }
}