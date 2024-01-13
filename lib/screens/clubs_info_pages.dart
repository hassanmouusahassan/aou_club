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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Admin: ${club.admin}",
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'About Club',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    club.description,
                    style: const TextStyle(fontSize: 16.0, height: 1.5),
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(color: Colors.grey),
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  // Placeholder for events, replace with actual data
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // replace with actual event count
                      itemBuilder: (context, index) {
                        return Card(
                          child: SizedBox(
                            width: 180,
                            child: Center(
                              child: Text('Event ${index + 1}'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(color: Colors.grey),
                  const Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  // Placeholder for gallery, replace with actual images
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // replace with actual image count
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(
                            'https://via.placeholder.com/150', // replace with actual image URLs
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
