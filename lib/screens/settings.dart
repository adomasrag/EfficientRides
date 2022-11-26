import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import '../animation/fadeanimation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(

        /// APP BAR
        appBar: AppBar(
          title: const Text("Nustatymai"),
          centerTitle: true,
        ),
        body: SizedBox(
            width: w,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: FadeAnimation(
                  delay: 0,
                  child: const Text(
                    "Atsijungti:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              FadeAnimation(
                  delay: 0,
                  child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text("Atsijungti")))
            ])));
  }
}
