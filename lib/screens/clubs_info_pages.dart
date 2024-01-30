import 'package:flutter/material.dart';
import 'package:aou_club/screens/club_home_page.dart'; // Import your Club model

class ClubInfoPage extends StatefulWidget {
  final Club club;
  final bool isAdmin;

  const ClubInfoPage({Key? key, required this.club, required this.isAdmin}) : super(key: key);

  @override
  _ClubInfoPageState createState() => _ClubInfoPageState();
}

class _ClubInfoPageState extends State<ClubInfoPage> {
  List<String> events = List.generate(5, (index) => 'Event ${index + 1}');
  List<String> galleryImages = List.generate(5, (index) => 'https://via.placeholder.com/150');

  TextEditingController aboutClubController = TextEditingController();
  TextEditingController upcomingEventsController = TextEditingController();
  TextEditingController galleryController = TextEditingController();

  void deleteEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
  }

  void deleteImage(int index) {
    setState(() {
      galleryImages.removeAt(index);
    });
  }

  void editAboutClub() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit About Club'),
          content: TextField(
            controller: aboutClubController,
            decoration: InputDecoration(hintText: 'Enter new description'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.club.description = aboutClubController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void editUpcomingEvents() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Upcoming Events'),
          content: TextField(
            controller: upcomingEventsController,
            decoration: InputDecoration(hintText: 'Enter new events'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  events = upcomingEventsController.text.split(','); // Update events with new data
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void editGallery() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Gallery'),
          content: TextField(
            controller: galleryController,
            decoration: InputDecoration(hintText: 'Enter new image URLs'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  galleryImages = galleryController.text.split(','); // Update gallery with new data
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.club.name),
        backgroundColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.asset(
                  widget.club.imageUrl,
                  fit: BoxFit.cover,
                  height: 250,
                ),
                if (widget.isAdmin)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Handle the action for changing the image
                        print('Change Image');
                      },
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'About Club',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      if (widget.isAdmin)
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: editAboutClub,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.club.description,
                    style: const TextStyle(fontSize: 16.0, height: 1.5),
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Events',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      if (widget.isAdmin)
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: editUpcomingEvents,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Placeholder for events, replace with actual data
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              SizedBox(
                                width: 180,
                                child: Center(
                                  child: Text(events[index]),
                                ),
                              ),
                              if (widget.isAdmin)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.thumb_up),
                                      onPressed: () {
                                        print('Like Event ${index + 1}');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        deleteEvent(index);
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Gallery',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      if (widget.isAdmin)
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: editGallery,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Placeholder for gallery, replace with actual images
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: galleryImages.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.network(
                                  galleryImages[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (widget.isAdmin)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.thumb_up),
                                      onPressed: () {
                                        print('Like Image ${index + 1}');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        deleteImage(index);
                                      },
                                    ),
                                  ],
                                ),
                            ],
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
