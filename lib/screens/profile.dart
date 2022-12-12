import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/userModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  UserModel fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
      );

  Future<UserModel?> readUser() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc('QR0dLhdiqJeF9XgUMYT3QfjqUI82');
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return fromJson(snapshot.data()!);
    }
  }

  Widget buildUser(UserModel user) => ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                        'https://avatars0.githubusercontent.com/u/28812093?s=460&u=06471c90e03cfd8ce2855d217d157c93060da490&v=4'),
                  ),
                ],
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
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Column(
              children: <Widget>[
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
                    'Adresas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Švenčionėlių g. 17',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Miestas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Vilnius',
                    style: TextStyle(
                      fontSize: 18,
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
        appBar: AppBar(
          title: Text('Profilis'),
          centerTitle: true,
          backgroundColor: Colors.teal.shade200,
        ),
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
            })

        /**/
        );
  }
}
