import 'package:aou_club/constants/theme_provider.dart';
import 'package:aou_club/screens/club_home_page.dart';
import 'package:aou_club/widgets/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AOU Clubs',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      onGenerateRoute: ((settings) => generateRoute(settings)),
      home:  ClubsPage(),
    );
  }
}