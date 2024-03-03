import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ClubInfoPage extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String admin;

  const ClubInfoPage({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.admin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseReference eventsRef = FirebaseDatabase.instance.ref('clubs/$name/events');
    final DatabaseReference galleryRef = FirebaseDatabase.instance.ref('clubs/$name/gallery');

    return Scaffold(
      appBar: AppBar(
        title: Text(name), // Club name as title
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(imageUrl, height: 250, fit: BoxFit.cover)
                : Image.asset('assets/images/placeholder.png', height: 250, fit: BoxFit.cover),
            SizedBox(height: 20),
            Text("Admin: $admin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Upcoming Events", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            SizedBox(height: 20),
            Text("Gallery", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            StreamBuilder(
              stream: galleryRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
                  Map galleryData = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                  List<dynamic> images = galleryData.values.toList();
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List<Widget>.generate(
                      images.length,
                          (index) => Image.network(images[index]['url'], width: 100, height: 100, fit: BoxFit.cover),
                    ),
                  );
                } else {
                  return Center(child: Text('No images in gallery'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
