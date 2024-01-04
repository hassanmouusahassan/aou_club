import 'package:aou_club/screens/clubs_info_pages.dart';
import 'package:aou_club/screens/news_announcement_page.dart';
import 'package:aou_club/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:aou_club/screens/login_page.dart';


class Club {
  final String name;
  final String admin;
  final String imageUrl;

  Club({required this.name, required this.admin, required this.imageUrl});
}

List<Club> clubs = [
  Club(name: "Sports Club", admin: "John Doe", imageUrl: "assets/club-icon-4.jpg"),
Club(name: "Dance Club", admin: "Jane Doe", imageUrl: "assets/club-icon-4.jpg"),
Club(name: "Music Club", admin: "Jane Doe", imageUrl: "assets/club-icon-4.jpg"),
Club(name: "Omar Club", admin: "Jane Doe", imageUrl: "assets/club-icon-4.jpg"),
Club(name: "Hassan Club", admin: "Jane Doe", imageUrl: "assets/club-icon-4.jpg"),
Club(name: "Computer Club", admin: "Jane Doe", imageUrl: "assets/club-icon-4.jpg"),
Club(name: "Music Club", admin: "Jane Doe", imageUrl: "assets/club-icon-4.jpg"),
Club(name: "AI Club", admin: "Jane Doe", imageUrl: "assets/club-icon-4.jpg"),


];
// Add more clubs as needed

class ClubsPage extends StatefulWidget {
  @override
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('AOU CLUBS')),
        backgroundColor: Colors.deepPurple,
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
          SettingsPage(), // Replace with your Settings Widget
          NewsPage(), // Replace with your News Widget
          ClubInfo(),
          // Replace with your Chat Widget
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Colors.black),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department,color: Colors.black),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat,color: Colors.black),
            label: 'Chat',
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClubInfo()));
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
      margin: EdgeInsets.all(10.0),
      clipBehavior: Clip.antiAlias, // Ensures the image is clipped to the card's border radius
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        height: 200, // Adjust the height as needed
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(club.imageUrl), // Ensures the image covers the card
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken), // Optional: darkens the image
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                club.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
              Text(
                'Admin: ${club.admin}',
                style: TextStyle(color: Colors.white),
              ),

            ],

          ),
        ),
      ),
    );
  }
}