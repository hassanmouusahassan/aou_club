import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aou_club/screens/login_page.dart';
import 'package:aou_club/screens/chat_page.dart';
import 'package:aou_club/screens/news_announcement_page.dart';
import 'package:aou_club/screens/settings_page.dart';
import 'package:aou_club/screens/clubs_info_pages.dart';

class Club {
  final String name;
  final String admin;
  final String imageUrl;
  late final String description;

  Club({
    required this.name,
    required this.admin,
    required this.imageUrl,
    required this.description,
  });

  factory Club.fromSnapshot(Map<dynamic, dynamic> snapshot) {
    return Club(
      name: snapshot['name'] as String,
      admin: snapshot['admin'] as String,
      imageUrl: snapshot['imageUrl'] as String,
      description: snapshot['description'] as String,
    );
  }
}

class ClubsPage extends StatefulWidget {
  const ClubsPage({Key? key}) : super(key: key);

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  List<Club> _clubs = [];

  @override
  void initState() {
    super.initState();
    _fetchClubs();
  }

  void _fetchClubs() {
    DatabaseReference ref = FirebaseDatabase.instance.ref('clubs');
    ref.onValue.listen((DatabaseEvent event) {
      final clubsData = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Club> loadedClubs = clubsData.entries.map((e) {
        return Club.fromSnapshot(Map<String, dynamic>.from(e.value));
      }).toList();
      setState(() {
        _clubs = loadedClubs;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'AOU CLUBS';
      case 1:
        return 'News';
      case 2:
        return 'Chat';
      case 3:
        return 'Settings';
      default:
        return '';
    }
  }

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
    return Scaffold(
        appBar: AppBar(
        title: Center(
        child: Text(
        _getTitle(_selectedIndex),
    style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    ),
    backgroundColor: Colors.black26,
    actions: _selectedIndex == 3
    ? [
    IconButton(
      icon: const Icon(Icons.exit_to_app, color: Colors.red),
      onPressed: confirmLogout,
    ),
    ]
        : null,
        ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildClubsList(),
          NewsPage(), // Your News Widget
          ChatPage(), // Your Chat Widget
          SettingsPage(), // Your Settings Widget
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department, color: Colors.green),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.orange),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.purple),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildClubsList() {
    return ListView.builder(
      itemCount: _clubs.length,
      itemBuilder: (context, index) {
        final club = _clubs[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClubInfoPage(club: club, isAdmin: false),
              ),
            );
          },
          child: ClubCard(club: club),
        );
      },
    );
  }
}

class ClubCard extends StatelessWidget {
  final Club club;

  const ClubCard({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(10.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(club.imageUrl),
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                club.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
              Text(
                'Admin: ${club.admin}',
                style: const TextStyle(color: Colors.white),
              ),
             // Text(
               // club.description,
                //style: const TextStyle(color: Colors.white70),
              //),
            ],
          ),
        ),
      ),
    );
  }
}

