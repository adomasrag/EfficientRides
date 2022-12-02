import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import '../animation/fadeanimation.dart';

class AvailableTripsScreen extends StatefulWidget {
  const AvailableTripsScreen({Key? key}) : super(key: key);

  @override
  State<AvailableTripsScreen> createState() => _AvailableTripsState();
}

class _AvailableTripsState extends State<AvailableTripsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ieškoti pavežėjų"),
        centerTitle: true,
      ),
      body: Container(
        child: Row(children: [
          Container(
              child: Column(children: [
            Align(
              alignment: Alignment.topCenter,
            ),
            SizedBox(
              width: w / 1.1,
              height: h / 12,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ])),

          // Padding(
          //   padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
          // ),
        ]),
      ),
    );
  }
}
