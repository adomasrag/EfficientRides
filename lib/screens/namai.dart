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
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Container(
            width: w,
            height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: Colors.white),
                          fixedSize: Size(150, 50),
                        ),
                        //controller: _firstNameController,
                        child: Text('Filtruoti', style: TextStyle(color: Colors.white)),
                        onPressed: () {},
                      ),
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTripsScreen()));
                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
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
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    print('Namukas build');

    return SafeArea(
      child: Scaffold(
          body: FutureBuilder<UserModel?>(
              future: readUser(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                return user == null ? Center(child: Text('User error')) : buildHeader(user, w, h);
              })),
    );
  }
}
