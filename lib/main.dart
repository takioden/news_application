import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_application/models/news_model.dart';
import 'package:news_application/views/new_detail_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'viewmodels/news_viewmodel.dart';
import 'views/news_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(  options: DefaultFirebaseOptions.currentPlatform,);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NewsViewModel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: NewsView(),
      routes: {
        '/news': (context) {
          final news = ModalRoute.of(context)!.settings.arguments as News;
          return NewsDetailView(news: news);
        },

      },
    );
  }
}
