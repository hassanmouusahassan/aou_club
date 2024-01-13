import 'package:flutter/material.dart';
import 'package:aou_club/screens/chat_page.dart'; // Replace with actual import
import 'package:aou_club/screens/news_announcement_page.dart'; // Replace with actual import
import 'package:aou_club/screens/settings_page.dart';

import 'clubs_info_pages.dart'; // Replace with actual import

class Club {
  final String name;
  final String admin;
  final String imageUrl;
  final String description; // Added description field

  Club(
      {required this.name,
      required this.admin,
      required this.imageUrl,
      required this.description});
}

// Updated club data with description
List<Club> clubs = [
  Club(
    name: "Sports Club",
    admin: "John Doe",
    imageUrl: "assets/sport.jpeg",
    description: "Description for Sports Club",
  ),
  Club(
    name: "Dance Club",
    admin: "Jane Doe",
    imageUrl: "assets/dancing.jpg",
    description: "Description for Dance Club",
  ),
  Club(
    name: "Music Club",
    admin: "Jane Doe",
    imageUrl: "assets/music.jpeg",
    description: "Description for Music Club",
  ),
  Club(
    name: "Omar Club",
    admin: "Jane Doe",
    imageUrl: "assets/omar.png",
    description: "Description for Omar Club",
  ),
  Club(
    name: "Hassan Club",
    admin: "Jane Doe",
    imageUrl: "assets/hassan.jpeg",
    description: "Description for Hassan Club",
  ),
  Club(
    name: "Computer Club",
    admin: "Jane Doe",
    imageUrl: "assets/computer.jpeg",
    description: "Description for Computer Club",
  ),
  Club(
    name: "Music Club",
    admin: "Jane Doe",
    imageUrl: "assets/music.jpeg",
    description: "Description for Music Club",
  ),
  Club(
    name: "AI Club",
    admin: "Jane Doe",
    imageUrl: "assets/ai.jpeg",
    description: "Description for AI Club",
  ),
];

class ClubsPage extends StatefulWidget {
  const ClubsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
          const NewsPage(), // Replace with your News Widget
          const ChatPage(), // Replace with your Chat Widget
          SettingsPage(), // Replace with your Settings Widget
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
      itemCount: clubs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClubInfoPage(club: clubs[index]),
              ),
            );
          },
          child: ClubCard(club: clubs[index]),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(club.imageUrl),
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.darken),
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
            ],
          ),
        ),
      ),
    );
  }
}
