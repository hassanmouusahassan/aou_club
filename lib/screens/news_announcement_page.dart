import 'package:aou_club/screens/news_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AOU Clubs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: NewsPage(),
    );
  }
}

class News {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;

  News(
      {required this.title,
      required this.content,
      required this.imageUrl,
      required this.date});
}

List<News> newsList = [
  News(
    title: "Sports Club Wins Championship",
    content: "The sports club won the inter-college championship...",
    imageUrl: "assets/sportwin.jpeg",
    date: DateTime.now(),
  ),
  News(
    title: "Sports Club Wins Championship",
    content: "The sports club won the inter-college championship...",
    imageUrl: "assets/sportwin.jpeg",
    date: DateTime.now(),
  ),
  News(
    title: "Sports Club Wins Championship",
    content: "The sports club won the inter-college championship...",
    imageUrl: "assets/sportwin.jpeg",
    date: DateTime.now(),
  ),
  News(
    title: "Sports Club Wins Championship",
    content: "The sports club won the inter-college championship...",
    imageUrl: "assets/sportwin.jpeg",
    date: DateTime.now(),
  ),
  News(
    title: "Sports Club Wins Championship",
    content: "The sports club won the inter-college championship...",
    imageUrl: "assets/sportwin.jpeg",
    date: DateTime.now(),
  ),
  News(
    title: "Sports Club Wins Championship",
    content: "The sports club won the inter-college championship...",
    imageUrl: "assets/sportwin.jpeg",
    date: DateTime.now(),
  ),
];

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewsDetailPage(news: newsList[index])),
                );
              },
              child: NewsCard(news: newsList[index]),
            );
          },
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;

  NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String formattedDate =
        DateFormat('yyyy-MM-dd – hh:mm a').format(news.date); // 12-hour format

    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: theme.brightness == Brightness.dark
              ? (Colors.red[300] ?? Colors.red)
              : Colors.red,
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Image.asset(news.imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.brightness == Brightness.dark
                        ? (Colors.red[300] ?? Colors.red)
                        : Colors.red,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  news.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Published on: $formattedDate',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: theme.brightness == Brightness.dark
                        ? (Colors.grey[400] ?? Colors.grey)
                        : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

