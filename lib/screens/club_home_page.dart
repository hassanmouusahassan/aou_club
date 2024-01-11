import 'package:aou_club/screens/chat_page.dart';
import 'package:aou_club/screens/clubs_info_pages.dart';
import 'package:aou_club/screens/news_announcement_page.dart';
import 'package:aou_club/screens/settings_page.dart';
import 'package:flutter/material.dart';

class Club {
  final String name;
  final String admin;
  final String imageUrl;

  Club({required this.name, required this.admin, required this.imageUrl});
}

List<Club> clubs = [
  Club(
      name: "Sports Club",
      admin: "John Doe",
      imageUrl: "assets/sport.jpeg",),
  Club(
      name: "Dance Club",
      admin: "Jane Doe",
      imageUrl: "assets/dancing.jpg",),
  Club(
      name: "Music Club",
      admin: "Jane Doe",
      imageUrl: "assets/music.jpeg",),
  Club(
      name: "Omar Club",
      admin: "Jane Doe",
      imageUrl: "assets/omar.png",),
  Club(
      name: "Hassan Club",
      admin: "Jane Doe",
      imageUrl: "assets/hassan.jpeg"),
  Club(
      name: "Computer Club",
      admin: "Jane Doe",
      imageUrl: "assets/computer.jpeg",),
  Club(
      name: "Music Club",
      admin: "Jane Doe",
      imageUrl: "assets/music.jpeg",),
  Club(name: "AI Club", admin: "Jane Doe", imageUrl: "assets/ai.jpeg"),
];

class ClubsPage extends StatefulWidget {
  @override
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
          title: Center(child: Text(_getTitle(_selectedIndex),style: TextStyle(fontWeight: FontWeight.bold),)),
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
             NewsPage(), // Replace with your News Widget
            ChatPage(), // Replace with your Chat Widget
            SettingsPage(), // Replace with your Settings Widget
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blue), // Set color for Home
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department,
                  color: Colors.green), // Set color for News
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat, color: Colors.orange), // Set color for Chat
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings,
                  color: Colors.purple), // Set color for Settings
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
            print('Tapped on ${clubs[index].name}');
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
