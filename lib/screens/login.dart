import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/forgot_password.dart';
//
import '../animation/fadeanimation.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback showSignUpScreen;
  const LoginScreen({Key? key, required this.showSignUpScreen}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color _color = Colors.teal.shade900;
  bool _clickedClickme = false;

  Color? _updateState() {
    setState(() {
      if (_clickedClickme) {
        _color = Colors.grey.shade800;

        Timer(Duration(seconds: 3), () {
          _color = Colors.teal.shade900;
          _clickedClickme = !_clickedClickme;
          _updateState();
        });
      }
    });
  }

  /// TextFields Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Email & Password Empty
  var fSnackBar = const SnackBar(
    content: Text('Būtinai įrašykite Email ir Password!'),
  );

  /// Email Fill & Password Empty
  var sSnackBar = const SnackBar(
    content: Text('Būtinai įrašykite Password!'),
  );

  /// Email Empty & Password Fill
  var tSnackBar = const SnackBar(
    content: Text('Būtinai įrašykite Email!'),
  );

  /// SIGNIN METHOD TO FIREBASE
  Future signIn() async {
    try {
      if (_emailController.text.isNotEmpty & _passwordController.text.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Navigator.of(context).pop();
      } else if (_emailController.text.isNotEmpty & _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(sSnackBar);
        Navigator.of(context).pop();
      } else if (_emailController.text.isEmpty & _passwordController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(tSnackBar);
        Navigator.of(context).pop();
      } else if (_emailController.text.isEmpty & _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(fSnackBar);
        Navigator.of(context).pop();
      }
    } catch (e) {
      Navigator.of(context).pop();

      /// Showing Error with AlertDialog if the user enter the wrong Email and Password
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error Happened'),
            content: const SingleChildScrollView(
              child: Text("The Email or Password that you entered is not valid, try again."),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Got it'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _emailController.clear();
                  _passwordController.clear();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// currrent Width and Height
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    ///
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.black87,
          body: Container(
            width: w,
            height: h,
            margin: const EdgeInsets.fromLTRB(20, 90, 20, 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// LOGO IMAGE
                  FadeAnimation(
                    delay: 1,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/vw.jpg"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),

                  /// TOP TEXT
                  FadeAnimation(
                    delay: 1.5,
                    child: const Text(
                      "Welcome!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  FadeAnimation(
                    delay: 2.0,
                    child: Container(
                      height: 160,
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: ListView(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              validator: (String? value) {
                                if (value == null || value == '') {
                                  return 'Enter email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.white),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  /// Forgot Password TEXT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const ForgotPasswordScreen(),
                                ),
                              ),
                          child: FadeAnimation(
                            delay: 3,
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color.fromRGBO(15, 114, 195, 1),
                                fontSize: 14,
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  /// LOG IN BUTTON
                  FadeAnimation(
                    delay: 3.5,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: Size(w / 1.1, h / 15)),
                        onPressed: signIn,
                        child: const Text("Log In"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  /// REGISTER TEXT
                  GestureDetector(
                    onTap: widget.showSignUpScreen,
                    child: FadeAnimation(
                      delay: 4,
                      child: RichText(
                        text: TextSpan(
                            text: "Don't have an account?",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                  text: " Sign up.",
                                  style: TextStyle(
                                    color: Color.fromRGBO(15, 114, 195, 1),
                                    fontWeight: FontWeight.bold,
                                  ))
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
