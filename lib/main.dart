// import 'package:aou_club/screens/login_page.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'aou club',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 11, 44, 110)),
//         useMaterial3: true,
//       ),
//     );
//   }
// }

import 'package:aou_club/constants/global_var.dart';
import 'package:aou_club/screens/club_home_page.dart';
import 'package:aou_club/screens/login_page.dart';
import 'package:aou_club/widgets/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AOU Clubs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVar.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVar.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      onGenerateRoute: ((settings) => generateRoute(settings)),
      home:  ClubsPage(),
    );
  }
}
