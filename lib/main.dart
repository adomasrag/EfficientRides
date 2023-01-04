import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/firebase_options.dart';
//
import 'auth/main_page.dart';

void main() async {
  /// initialize FireBase App
  WidgetsFlutterBinding();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    new MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.teal.shade500,
        ),
        fontFamily: 'Raleway',
      ),
      home: MainScreen(),
    );
  }
}
