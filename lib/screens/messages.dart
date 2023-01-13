import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/rating.dart';
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
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(30, 30, 30, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Your messages',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 10,
                color: Colors.grey.shade800,
              ),
              SizedBox(
                height: 12,
              ),
              //ChatBodyWidget(users: users),
            ],
          ),
        ),
      ),
    );
  }
}
