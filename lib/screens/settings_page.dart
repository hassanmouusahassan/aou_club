import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:aou_club/constants/theme_provider.dart'; // Make sure this import is correct
import 'package:aou_club/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationsOn = false;
  bool _isThemeOn = true;

  User? user;
  DatabaseReference? userRef;

  String userName = 'hassan moussa';
  String userMajor = 'computer science';
  String userID = '220464';
 String userProfileImg = 'assets/hassan.jpeg';

  @override
  void initState() {
    super.initState();

    loadPreferences();
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationsOn = prefs.getBool('isNotificationsOn') ?? true;
      _isThemeOn = prefs.getBool('isThemeOn') ?? false;
    });
  }

  void updateNotificationPreference(bool value) async {
    setState(() {
      isNotificationsOn = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationsOn', value);
  }

  void updateThemePreference(bool value) async {
    setState(() {
      _isThemeOn = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isThemeOn', value);
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
  }

  void confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Do you really want to log out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: logout,
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: ListView(
            children: [
              userProfileImg.isNotEmpty
                  ? CircleAvatar(backgroundImage: AssetImage(userProfileImg), radius: 80,)
                  : CircleAvatar(child: Icon(Icons.person)),

    Card(
    margin: EdgeInsets.all(8),
    child: ListTile(

    title: Text(userName),
    subtitle: Text('Major: $userMajor\nID: $userID'),
    ),
    ),

    SwitchListTile(
    title: Text('Notifications'),
    value: isNotificationsOn,
    onChanged: updateNotificationPreference,
    secondary: Icon(
    isNotificationsOn ? Icons.notifications_active : Icons.notifications_off,
    ),
    ),
    SwitchListTile(
    title: Text('change Theme'),
      value: _isThemeOn,
      onChanged: updateThemePreference,
      secondary: Icon(
        _isThemeOn ? Icons.light_mode : Icons.dark_mode,
      ),
    ),
              // Any additional settings options go here
            ],
        ),
    );
  }
}


