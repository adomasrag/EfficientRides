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
  final formKey = GlobalKey<FormState>();

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
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((result) {
      Navigator.of(context).pop();
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No such user")));
      Navigator.of(context).pop();
    });
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
          body: SafeArea(
            child: Container(
              width: w,
              height: h,
              margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 65,
                        ),
                        /// LOGO IMAGE
                        FadeAnimation(
                          delay: 1,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 150,
                              width: 250,
                              child: Text("efficientRides",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w400
                              ),)
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        /// TOP TEXT
                        FadeAnimation(
                          delay: 1.5,
                          child: const Text(
                            "Welcome!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        FadeAnimation(
                          delay: 2.0,
                          child: Container(
                            child: Form(
                              key: formKey,
                              child: Column(
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
                                      final pattern =
                                          "^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                      final regExp = RegExp(pattern);
                                      if (value == null || value == '' || !regExp.hasMatch(value)) {
                                        return 'Enter a valid email';
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
                                    validator: (String? value) {
                                      if (value == null || value == '') {
                                        return 'Enter a valid password';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 15,
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
                          height: 30,
                        ),

                        /// LOG IN BUTTON
                        FadeAnimation(
                          delay: 3.5,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(minimumSize: Size(w / 1.1, 47)),
                              onPressed: () {
                                final isValid = formKey.currentState!.validate();
                                if (isValid) {
                                  signIn();
                                }
                              },

/*
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                    if (result == null) {
                                      setState(() {
                                        error = Strings.couldNotLogInCred;
                                      });
                                      return;
                                    }
                                    await Navigator.pushReplacementNamed(
                                        context, Strings.userInfoPath);
                                  }
                                }
*/

                              child: const Text("Log In"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        /// REGISTER TEXT

                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: Container(
                          color: Colors.transparent,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Divider(
                                  color: Colors.grey.shade800,
                                  //thickness: 1,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                GestureDetector(
                                  onTap: widget.showSignUpScreen,
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
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
