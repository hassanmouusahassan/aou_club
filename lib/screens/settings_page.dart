import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aou_club/screens/profile_page.dart';
import 'package:aou_club/constants/theme_provider.dart'; // Ensure this is the correct path
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Settings UI',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        hintColor: Colors.amber,
      ),
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
   bool isNotificationsOn= false;
  bool _isThemeOn = true;

  String userName = 'Cov Omar';
  String userImage = 'assets/omar.png'; // Ensure this path is valid

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Cov Omar';
      userImage = prefs.getString('userImage') ?? 'assets/omar.png';
      isNotificationsOn = prefs.getBool('isNotificationsOn') ?? true;
      _isThemeOn = prefs.getBool('isThemeOn') ?? false;
    });
  }

  void updateProfile(String newName, String newImage) async {
    setState(() {
      userName = newName;
      userImage = newImage;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newName);
    await prefs.setString('userImage', newImage);
  }

  void updateNotificationPreference(bool value) async {
    setState(() {
      isNotificationsOn = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationsOn', isNotificationsOn);
  }

  void updateThemePreference(bool value) async {
    setState(() {
      _isThemeOn = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isThemeOn', _isThemeOn);
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
  }

  navigateToProfile() {
    Navigator.of(context)
        .push(_createRoute())
        .then((_) => loadPreferences()); // Reload preferences on return
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(
        userName: userName,
        userImage: userImage,
        onUpdate: updateProfile,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: navigateToProfile,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(userImage),
                    radius: 30,
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'AOU Student, ID: 220464',
                          style: TextStyle(color: Colors.grey[400], fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                SwitchListTile(
                  title: const Text('Notifications', style: TextStyle(color: Colors.grey)),
                  value: isNotificationsOn,
                  onChanged: (bool value) {
                    updateNotificationPreference(value);
                  },
                  secondary: Icon(isNotificationsOn ? Icons.notifications : Icons.notifications_off_rounded, color: Colors.green),
                ),
                SwitchListTile(
                  title: const Text('Theme Mode', style: TextStyle(color: Colors.grey)),
                  value: _isThemeOn,
                  onChanged: (bool value) {
                    updateThemePreference(value);
                  },
                  secondary: Icon(_isThemeOn ? Icons.light_mode : Icons.dark_mode, color: Colors.green),
                ),
                // ... Add more options here as needed ...
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserPreferences {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setName(String name) async =>
      await _preferences.setString('userName', name);

  static String getName() => _preferences.getString('userName') ?? '';

  static Future setThemePreference(bool isDarkMode) async =>
      await _preferences.setBool('isThemeOn', isDarkMode);

  static bool getThemePreference() =>
      _preferences.getBool('isThemeOn') ?? false;

  static Future setNotificationPreference(bool isOn) async =>
      await _preferences.setBool('isNotificationsOn', isOn);

  static bool getNotificationPreference() =>
      _preferences.getBool('isNotificationsOn') ?? true;
}
