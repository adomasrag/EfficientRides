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
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(30, 0, 30, 20),
          child: Column(
            children: [
              FadeAnimation(
                delay: 1,
                child: Container(
                  child: SizedBox(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RatingScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      "Rate a driver",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Icon(
                              Icons.star_border_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 15),
                  width: w - 60,
                  height: 47,
                  alignment: Alignment.center,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Trip history',
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
            ],
          ),
        ),
      ),
    );
  }
}
