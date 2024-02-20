

import 'package:aou_club/constants/theme_provider.dart';

import 'package:aou_club/screens/login_page.dart';

import 'package:aou_club/widgets/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCRiCm7l3eqBXNXG4XrEglXiMdIVuuAHGo",
      authDomain: "aou-clubs.firebaseapp.com",
      projectId: "aou-clubs-ccbdd",
      storageBucket: "aou-clubs.appspot.com",
      messagingSenderId: "674025303011",
      appId: "1:674025303011:android:b82a9bdf765cb672244ed6",
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AOU Clubs',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      onGenerateRoute: ((settings) => generateRoute(settings)),
      home: LoginPage(),
    );
  }
}
