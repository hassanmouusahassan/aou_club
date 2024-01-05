import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Alignment _textAlignment = Alignment.topCenter;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _textAlignment = Alignment.center;
      });
      _startTextAnimation();
    });
  }

  void _startTextAnimation() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.5;
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _opacity = 1.0;
        });
        _startTextAnimation(); // Repeat the animation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedAlign(
            alignment: _textAlignment,
            duration: Duration(seconds: 3),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Text(
                "COMING SOON",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
