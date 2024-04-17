import 'package:aou_club/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminClubInfoPage extends StatefulWidget {
  final String clubKey; // Assuming each club has a unique key

  const AdminClubInfoPage({
    Key? key,
    required this.clubKey, // Expect a clubKey to be passed when navigating to this page
  }) : super(key: key);

  @override
  State<AdminClubInfoPage> createState() => _AdminClubInfoPageState();
}

class _AdminClubInfoPageState extends State<AdminClubInfoPage> {
  void confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Do you really want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: _logout,
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference clubRef = FirebaseDatabase.instance.ref('clubs/${widget.clubKey}');
    final DatabaseReference eventsRef = clubRef.child('events');

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: clubRef.child('name').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text((snapshot.data! as DatabaseEvent).snapshot.value.toString());
            }
            return Text('Club Info');
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            onPressed: confirmLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: clubRef.child('imageUrl').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  String imageUrl = (snapshot.data! as DatabaseEvent).snapshot.value.toString();
                  return imageUrl.isNotEmpty
                      ? Image.network(imageUrl, height: 250, fit: BoxFit.cover)
                      : Image.asset('assets/images/placeholder.png', height: 250, fit: BoxFit.cover);
                } else {
                  return Image.asset('assets/images/placeholder.png', height: 250, fit: BoxFit.cover);
                }
              },
            ),
            SizedBox(height: 20),
            buildEditableField(
              context,
              fieldName: "Club Description",
              stream: clubRef.child('description').onValue,
              onEdit: () {
                // Provide functionality to edit the club description
              },
            ),
            SizedBox(height: 20),
            buildEditableField(
              context,
              fieldName: "Admin",
              stream: clubRef.child('admin').onValue,
              onEdit: () {
                // Provide functionality to edit the admin field
              },
            ),
            SizedBox(height: 20),
            Text(
              "Upcoming Events",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Similar to the ClubInfoPage but include editing functionality
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(BuildContext context, {required String fieldName, required Stream<DatabaseEvent> stream, required VoidCallback onEdit}) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          String fieldValue = (snapshot.data! as DatabaseEvent).snapshot.value.toString();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$fieldName:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: onEdit,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                fieldValue,
                style: TextStyle(fontSize: 16),
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
