import 'package:flutter/material.dart';
import 'package:aou_club/screens/news_announcement_page.dart';

class NewsDetailPage extends StatelessWidget {
  final News news;

  NewsDetailPage({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share news functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 250, // Set a fixed height for the image container
              child: PageView(
                children: [
                  Image.asset(news.imageUrl, fit: BoxFit.cover),
                  // You can add more images here
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    news.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Published on ${formatDate(news.date)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    news.content,
                    style: TextStyle(fontSize: 16),
                  ),
                  // Additional details and features
                  Divider(),
                  Text(
                    'Event Schedule',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Display event schedule or calendar here
                  // Other interactive elements
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    // Format the date as needed
    return '${date.day}/${date.month}/${date.year}';
  }
}
