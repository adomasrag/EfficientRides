import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import '../animation/fadeanimation.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesState();
}

class _MessagesState extends State<MessagesScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(child: Container(child: Text('Zinutes'))),
    );
  }
}
