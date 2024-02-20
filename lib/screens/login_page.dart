import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aou_club/screens/club_home_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _login(String email, String password, BuildContext context) async {
    try {
      // Using Firebase for authentication
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await saveLoginStatus(true);
      _navigateToHomePage(context);
    } catch (e) {
      // Show error message in a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid email or password. Please try again.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      _navigateToHomePage(context);
    }
  }

  Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ClubsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCirc;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkLoginStatus(context);

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5, 0.9],
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
                        onPressed: () {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();
                          _login(email, password, context);
                        },
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
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            suffixIcon: icon,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
