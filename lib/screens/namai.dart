import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'addtrips.dart';
import 'findtrips.dart';
import '../animation/fadeanimation.dart';
import '../models/userModel.dart';

class NamaiScreen extends StatefulWidget {
  const NamaiScreen({Key? key}) : super(key: key);

  @override
  State<NamaiScreen> createState() => _NamaiState();
}

class _NamaiState extends State<NamaiScreen> {
  Future<UserModel?> readUser() async {
    final docUser = FirebaseFirestore.instance.doc('users/' + FirebaseAuth.instance.currentUser!.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists)
      return UserModel.fromJson(snapshot.data()!);
    else
      return null;
  }

  @override
  Widget buildHeader(UserModel user, double w, double h) => Scaffold(
        body: Container(
          width: w,
          height: h,
          decoration: const BoxDecoration(
            color: Colors.black87,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              FadeAnimation(
                  delay: 2.5,
                  child: Container(
                    child: SizedBox(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AvailableTripsScreen()),
                          );
                        },
                        child: const Text(
                          "IEŠKOTI PAVEŽĖJŲ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 15),
                    width: w / 1.5,
                    height: h / 12,
                    alignment: Alignment.center,
                  )),
              FadeAnimation(
                  delay: 2.5,
                  child: Container(
                    child: SizedBox(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddTripsScreen()),
                          );
                        },
                        child: const Text(
                          "PRIDĖTI KELIONĘ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      width: w / 1.5,
                      height: h / 12,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    width: w / 1.5,
                    height: h / 12,
                    alignment: Alignment.center,
                  )),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
        body: FutureBuilder<UserModel?>(
            future: readUser(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return user == null ? Center(child: Text('User error')) : buildHeader(user, w, h);
            }));
  }
}
