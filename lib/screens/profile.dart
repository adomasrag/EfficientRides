import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import '../animation/fadeanimation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) { /// CURRENT WIDTH AND HEIGHT

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilis"),
        centerTitle: true,
        backgroundColor: Colors.teal.shade200,
      ),
        body: ListView(
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
                          backgroundImage: NetworkImage('https://avatars0.githubusercontent.com/u/28812093?s=460&u=06471c90e03cfd8ce2855d217d157c93060da490&v=4'),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Leonardo Palmeiro',
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
                    title: Text('El. pašto adresas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('palmeiro.leonardo@gmail.com',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  ListTile(
                    title: Text('Adresas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Švenčionėlių g. 17',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  ListTile(
                    title: Text('Miestas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Vilnius',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }
}
