import 'package:aou_club/constants/theme_provider.dart';
import 'package:aou_club/screens/club_home_page.dart';
import 'package:aou_club/screens/login_page.dart';

import 'package:aou_club/widgets/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDC-RGIaOxA9rWKFZsfBmNkXUjV04F-Yiw",
      authDomain: "aou-clubs.firebaseapp.com",
      projectId: "aou-clubs",
      storageBucket: "aou-clubs.appspot.com",
      messagingSenderId: "299969906157",
      appId: "1:299969906157:android:3b930df1e8f4236ede13e4",
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
      home: ClubsPage(),
    );
  }
}
