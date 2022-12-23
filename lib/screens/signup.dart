import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/userModel.dart';
//
import '../animation/fadeanimation.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginScreen;
  const SignUpScreen({
    Key? key,
    required this.showLoginScreen,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// TextFields Controller

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  /// Password =! ConfirmPassword
  var aSnackBar = const SnackBar(
    content: Text('The password in not match with confirm password'),
  );

  /// Password & ConfirmPassword is Empty
  var bSnackBar = const SnackBar(
    content: Text('The Password & Confirm Password fields must fill!'),
  );

  /// Confirm Password is Empty
  var cSnackBar = const SnackBar(
    content: Text('The Confirm Password field must fill!'),
  );

  /// Password is Empty
  var dSnackBar = const SnackBar(
    content: Text('The Password field must fill!'),
  );

  /// Email & Confirm Password is Empty
  var eSnackBar = const SnackBar(
    content: Text('The Email & Confirm Password fields must fill!'),
  );

  /// Email is Empty
  var fSnackBar = const SnackBar(
    content: Text('The Email field must fill!'),
  );

  /// Email & password is Empty
  var gSnackBar = const SnackBar(
    content: Text('The Email & Password fields must fill!'),
  );

  /// Email is incorrect
  var hSnackBar = const SnackBar(
    content: Text('The email address is badly formatted'),
  );

  /// All Fields Empty
  var xSnackBar = const SnackBar(
    content: Text('You must fill all fields'),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// SIGNING UP METHOD TO FIREBASE
  Future signUp() async {
    if (_emailController.text.isNotEmpty &
        _passwordController.text.isNotEmpty &
        _confirmPasswordController.text.isNotEmpty &
        _phoneController.text.isNotEmpty &
        _firstNameController.text.isNotEmpty &
        _lastNameController.text.isNotEmpty) {
      if (passwordConfirmed()) {
        try {
          /// create user
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          /// add user details
          addUserDetails(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _emailController.text.trim(),
            int.parse(_phoneController.text.trim()),
          );

          /// if firebase doesn't accept the email address
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(hSnackBar);
          print(e);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(aSnackBar);
      }

      /// In the below, with if statement we have some simple validate
    } else if (_emailController.text.isNotEmpty &
        _passwordController.text.isEmpty &
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(bSnackBar);
    }

    ///
    else if (_emailController.text.isNotEmpty &
        _passwordController.text.isNotEmpty &
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(cSnackBar);
    }

    ///
    else if (_emailController.text.isNotEmpty &
        _passwordController.text.isEmpty &
        _confirmPasswordController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(dSnackBar);
    }

    ///
    else if (_emailController.text.isEmpty &
        _passwordController.text.isNotEmpty &
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(eSnackBar);
    }

    ///
    else if (_emailController.text.isEmpty &
        _passwordController.text.isNotEmpty &
        _confirmPasswordController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(fSnackBar);
    }

    ///
    else if (_emailController.text.isEmpty &
        _passwordController.text.isEmpty &
        _confirmPasswordController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(gSnackBar);
    }

    ///
    else {
      ScaffoldMessenger.of(context).showSnackBar(xSnackBar);
    }
  }

  ///using User class from models
  Future addUserDetails(String firstName, String lastName, String email, int phone) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);
    final json = UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      id: FirebaseAuth.instance.currentUser!.uid,
      profileImage: "",
      phone: phone,
    ).toJson();
    await docUser.set(json);
  }

  /// CHECK IF PASSWORD CONFIRMED OR NOT
  bool passwordConfirmed() {
    if (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    print(h);
    print(w);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //Body Container
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                    child: Form(
                        child: Column(
                      children: [
                        FadeAnimation(
                          delay: 1.5,
                          child: Container(
                            width: w / 1.2,
                            child: const Text(
                              "Sign up to see our current offered trips.",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: Colors.grey.shade800,
                          //thickness: 1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          delay: 2.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    labelStyle: TextStyle(color: Colors.white),
                                    border: const OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(color: Colors.white),
                                    border: const OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FadeAnimation(
                          delay: 2.0,
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FadeAnimation(
                          delay: 2.0,
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: Colors.white),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FadeAnimation(
                          delay: 2.5,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FadeAnimation(
                          delay: 3,
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.white),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        /// SIGN UP BUTTON
                        FadeAnimation(
                          delay: 3.5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(minimumSize: Size(w / 1.1, 47)),
                            onPressed: signUp,
                            child: const Text("Sign Up"),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),

                //Footer Container
                //Here you will get unexpected behaviour when keyboard pops-up.
                //So its better to use `bottomNavigationBar` to avoid this.

                Container(
                  color: Colors.transparent,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Divider(
                          color: Colors.grey.shade800,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: widget.showLoginScreen,
                          child: RichText(
                            text: TextSpan(
                                text: "Have an account?",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                      text: " Log in.",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
