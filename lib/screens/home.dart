import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/availabletrips.dart';
import 'package:loginuicolors/screens/triphistory.dart';
import 'package:loginuicolors/screens/myroutes.dart';
import 'package:loginuicolors/screens/messages.dart';
import 'package:loginuicolors/screens/rating.dart';
import 'package:loginuicolors/screens/paymentinfo.dart';
import 'package:loginuicolors/screens/profile.dart';
import 'package:loginuicolors/screens/settings.dart';
//
import '../animation/fadeanimation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// CURRENT FIREBASE USER
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    ///
    return Scaffold(
      /// APP BAR
      appBar: AppBar(
          title: const Text("efficientRides"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Something')));
              },
            ),
          ]),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: h / 5,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal.shade200,
                ),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/vw.jpg"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                      child: Text(
                        'Vardas Pavarde',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.history),
                title: Text('Kelionių istorija'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TripHistoryScreen()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.route),
                title: Text('Mano maršrutai'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyRoutesScreen()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.message),
                title: Text('Žinutės'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MessagesScreen()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.rate_review),
                title: Text('Kelionės įvertinimas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RatingScreen()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.payment),
                title: Text('Mokėjimo informacija'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentInfoScreen()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profilis'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Nustatymai'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                }),
          ],
        ),
      ),
      body: Container(
        width: w,
        height: h,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/efficientRides-11.jpg"),
          fit: BoxFit.fill,
        )),
        child: Column(
          children: [
            /// WELCOME TEXT
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 70),
              child: FadeAnimation(
                delay: 1.5,
                child: const Text(
                  "Sveiks gyvs",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            /// SIGN IN TEXT
            FadeAnimation(
              delay: 2,
              child: Container(
                  child: Column(children: <Widget>[
                Text(
                  "Signed in as: ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  user.email!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ])),
            ),
            const SizedBox(
              height: 10,
            ),

            /// LOG OUT BUTTON
            FadeAnimation(
                delay: 2.5,
                child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text("Log out"))),

            FadeAnimation(
                delay: 2.5,
                child: Container(
                  child: SizedBox(
                    width: w / 1.5,
                    height: h / 12,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AvailableTripsScreen()),
                        );
                      },
                      child: const Text(
                        "IEŠKOTI PAVEŽĖJŲ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
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
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                  width: w / 1.5,
                  height: h / 12,
                  alignment: Alignment.center,
                )),

            FadeAnimation(
                delay: 2.5,
                child: Container(
                  child: const Text(
                    "PRIDĖTI KELIONĘ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.orange.shade400,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  //margin: EdgeInsets.all(40.0),
                  width: w / 1.5,
                  height: h / 12,
                  alignment: Alignment.center,
                )),
          ],
        ),
      ),
    );
  }
}
