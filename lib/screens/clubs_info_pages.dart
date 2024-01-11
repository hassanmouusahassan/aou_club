import 'package:flutter/material.dart';
import 'package:aou_club/screens/club_home_page.dart'; // Import your Club model

class ClubInfoPage extends StatelessWidget {
  final Club club;

  const ClubInfoPage({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(club.name),
        backgroundColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              club.imageUrl,
              fit: BoxFit.cover,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    club.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Admin: ${club.admin}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  // Add more details here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
