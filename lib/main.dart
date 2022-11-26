import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//
import 'auth/main_page.dart';

void main() async {
  /// initialize FireBase App
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
///hgkjabhekghbasfj,hfbals,jfhbfljahrwebflj,haer
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Log In & Sign up Authentication with FireBase",
      theme: ThemeData(
        //brightness: Brightness.dark,
        //colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.teal,
        //),
        fontFamily: 'Verdana',
      ),
      home: MainScreen(),
    );
  }
}
