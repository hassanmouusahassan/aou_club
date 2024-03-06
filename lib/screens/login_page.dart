import 'package:aou_club/screens/admin_club_admin_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import AdminPage and ClubsPage
import 'package:aou_club/screens/home_admin.dart';
import 'package:aou_club/screens/club_home_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> _login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await saveLoginStatus(true);
      // Check if the authenticated user is an admin of a club.
      await _checkClubAdminStatus(userCredential.user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid email or password. Please try again.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      String userEmail = prefs.getString('userEmail') ?? "";
      await _checkSavedUserAdminStatus(userEmail);
    }
  }

  Future<void> _checkClubAdminStatus(User? user) async {
    if (user == null) return;

    // Specific email check for Hassan
    if (user.email == "hassan@gmail.com" && passwordController.text == "hassan1234") {
      _navigateToPage(AdminPage()); // Navigate to a general admin page if it's Hassan
      return;
    }

    // Otherwise, check against the clubs' adminEmails
    DatabaseReference clubsRef = FirebaseDatabase.instance.ref('clubs');
    bool isAdmin = false;
    String adminClubKey = '';

    DataSnapshot snapshot = await clubsRef.get();
    if (snapshot.exists) {
      Map clubs = snapshot.value as Map;
      clubs.forEach((key, value) {
        if (value['adminEmail'] == user.email) {
          isAdmin = true;
          adminClubKey = key;
        }
      });

      if (isAdmin) {
        _navigateToPage(AdminClubInfoPage(clubKey: adminClubKey)); // Navigate to the specific club admin page
      } else {
        _navigateToPage(ClubsPage()); // Navigate to the regular clubs page
      }
    }
  }

  Future<void> _checkSavedUserAdminStatus(String userEmail) async {
    DatabaseReference clubsRef = FirebaseDatabase.instance.ref('clubs');
    bool isAdmin = false;
    String adminClubKey = '';

    DataSnapshot snapshot = await clubsRef.get();
    if (snapshot.exists) {
      Map clubs = snapshot.value as Map;
      clubs.forEach((key, value) {
        if (value['adminEmail'] == userEmail) {
          isAdmin = true;
          adminClubKey = key;
        }
      });

      if (isAdmin) {
        _navigateToPage(AdminClubInfoPage(clubKey: adminClubKey));
      } else {
        _navigateToPage(ClubsPage());
      }
    }
  }



// Include the rest of the necessary code here, such as saveLoginStatus.

  Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    // Save user email for later use (consider security implications)
    await prefs.setString('userEmail', emailController.text.trim());
  }

  void _navigateToPage(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E1E1E),
                  Color(0xFF333333),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(
                        "Login",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      inputFile(label: "Email", controller: emailController),
                      inputFile(
                        label: "Password",
                        obscureText: !_isPasswordVisible,
                        controller: passwordController,
                        icon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () => _login(emailController.text.trim(), passwordController.text.trim()),
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputFile({
    required String label,
    bool obscureText = false,
    TextEditingController? controller,
    Widget? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            suffixIcon: icon,
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
