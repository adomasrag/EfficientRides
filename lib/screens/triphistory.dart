import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/rating.dart';
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
      body: SafeArea(
          child: Container(
              child: Column(
        children: [
          Text('Kelioniu istorija'),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.teal.shade500,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            height: 50,
            width: 50,
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RatingScreen()));
                },
                icon: Icon(Icons.star),
              ),
            ),
          ),
        ],
      ))),
    );
  }
}
