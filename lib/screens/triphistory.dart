import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import '../animation/fadeanimation.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TripHistoryScreen> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistoryScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(child: Container(child: Text('Keliones'))),
    );
  }
}
