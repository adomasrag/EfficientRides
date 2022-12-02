import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import '../animation/fadeanimation.dart';

class MyRoutesScreen extends StatefulWidget {
  const MyRoutesScreen({Key? key}) : super(key: key);

  @override
  State<MyRoutesScreen> createState() => _MyRoutesState();
}

class _MyRoutesState extends State<MyRoutesScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mano maršrutai"),
        centerTitle: true,
      ),
      // FadeAnimation(
      //   delay: 0,
      //   child: EmptyWidget,
      // )
    );
  }
}
