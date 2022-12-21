import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/userModel.dart';
//import 'package:image_picker/image_picker.dart';
//import 'dart:io';
//import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  Future<UserModel?> readUser() async {
    final snapshot = await FirebaseFirestore.instance.doc('users/' + FirebaseAuth.instance.currentUser!.uid).get();

    if (snapshot.exists)
      return UserModel.fromJson(snapshot.data()!);
    else
      return null;
  }

  Widget buildUser(UserModel user) => ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 50.0,
                    child: Center(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  user.firstName + ' ' + user.lastName,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.black54,
                  height: 10,
                  indent: 13,
                  endIndent: 13,
                  thickness: 0.5,
                ),
                ListTile(
                  title: Text(
                    'El. pašto adresas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Telefono numeris',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '+A' + user.phone.toString(),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 1,
                  indent: 13,
                  endIndent: 13,
                  thickness: 0.5,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      child: Text(
                        'Mokėjimo informacija',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      onPressed: () {
                        //Navigator.of(context).push(PageRoute)
                      },
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black54,
                  height: 1,
                  indent: 13,
                  endIndent: 13,
                  thickness: 0.5,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 12, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // fixedSize: Size(70, 20),                           /// override button size
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text(
                        'Atsijungti',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<UserModel?>(
            future: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return user == null ? Center(child: Text('No User')) : buildUser(user);
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.redAccent.shade100,
                ));
              }
            }));
  }
}
