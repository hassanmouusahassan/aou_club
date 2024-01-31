import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'club_home_page.dart' as ClubPage;

class Event {
  String name;
  DateTime dateTime;

  Event({required this.name, required this.dateTime});
}

class Club {
  String name;
  String? description; // Making description nullable

  Club({required this.name, this.description});
}

class ClubInfoPage extends StatefulWidget {
  ClubPage.Club club;
  final bool isAdmin;

  ClubInfoPage({Key? key, required this.club, required this.isAdmin}) : super(key: key);

  @override
  _ClubInfoPageState createState() => _ClubInfoPageState();
}

class _ClubInfoPageState extends State<ClubInfoPage> {
  List<Event> events = [
    Event(name: 'Event 1', dateTime: DateTime.now()),
  ];
  List<String> galleryImages = List.generate(1, (index) => 'https://via.placeholder.com/150');

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
                if (widget.club.description != null) {
                  setState(() {
                    widget.club.description = aboutClubController.text;
                  });
                }

                // Save changes to persistent storage or backend here if needed

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
                  events = upcomingEventsController.text.split(',').map((eventName) {
                    return Event(name: eventName, dateTime: DateTime.now());
                  }).toList();
                });

                // Save changes to persistent storage or backend here if needed

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void addEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = DateTime.now();
        TimeOfDay selectedTime = TimeOfDay.now();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add Event',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: upcomingEventsController,
                    decoration: InputDecoration(
                      hintText: 'Enter new event name',
                      labelText: 'Event Name',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Show date picker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Pick Date'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Show time picker
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );

                      if (pickedTime != null && pickedTime != selectedTime) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Text('Pick Time'),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            events.add(
                              Event(
                                name: upcomingEventsController.text,
                                dateTime: DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                ),
                              ),
                            );
                          });

                          // Save changes to persistent storage or backend here if needed

                          Navigator.of(context).pop();
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                  galleryImages = galleryController.text.split(',');
                });

                // Save changes to persistent storage or backend here if needed

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void addImageToGallery() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Image to Gallery'),
          content: TextField(
            controller: galleryController,
            decoration: InputDecoration(hintText: 'Enter new image URL'),
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
                  galleryImages.add(galleryController.text);
                });

                // Save changes to persistent storage or backend here if needed

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
                  width: double.infinity,
                ),
                if (widget.isAdmin)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
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
                    widget.club.description ?? "", // Check if description is null
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
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: addEvent,
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              width: 200,
                              child: ListTile(
                                title: Text(
                                  events[index].name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('MMMM d, y H:mm a').format(events[index].dateTime),
                                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                ),
                                contentPadding: EdgeInsets.all(16.0),
                                onTap: () {
                                  // Handle tapping on the event if needed
                                },
                                trailing: widget.isAdmin
                                    ? IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    deleteEvent(index);
                                  },
                                )
                                    : null,
                              ),
                            ),
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
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: addImageToGallery,
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: galleryImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              width: 200,
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
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        deleteImage(index);
                                      },
                                    ),
                                ],
                              ),
                            ),
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
