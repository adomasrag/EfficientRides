import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/userModel.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
  String? confirmPass;
  final formKey = GlobalKey<FormState>();
  PhoneNumber number = PhoneNumber(isoCode: 'LT');

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

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

  /// SIGNING UP TO FIREBASE
  Future signUp() async {
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
        int.parse(
          _phoneController.text.trim().replaceAll(RegExp('[^A-Za-z0-9]'), ''),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String getMessageFromErrorCode;
      switch (e.code) {
        case "email-already-in-use":
          getMessageFromErrorCode = "Email already in use.";
          break;
        case "operation-not-allowed":
          getMessageFromErrorCode = "Server error, please try again later.";
          break;
        case "invalid-email":
          getMessageFromErrorCode = "Email address is invalid.";
          break;
        default:
          getMessageFromErrorCode = "Login failed. Please try again.";
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getMessageFromErrorCode)));
      print(e.code);
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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                        key: formKey,
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
                            FadeAnimation(
                              delay: 2.0,
                              child: Divider(
                                color: Colors.grey.shade800,
                              ),
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
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: 'First Name',
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
                                          return "Enter a first name";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: 'Last Name',
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
                                          return "Enter a last name";
                                        }
                                        return null;
                                      },
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
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                validator: (String? value) {
                                  final pattern =
                                      "^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                  final regExp = RegExp(pattern);
                                  if (value == null || value == '') {
                                    return "Enter an email address";
                                  }
                                  if (!regExp.hasMatch(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                                autofillHints: const [
                                  AutofillHints.email,
                                ],
                                keyboardType: TextInputType.emailAddress,
                                //   TextInputType.emailAddress
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FadeAnimation(
                              delay: 2.0,
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber!);
                                },
                                selectorTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                keyboardAction: TextInputAction.next,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                inputDecoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                ),
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                  setSelectorButtonAsPrefixIcon: true,
                                  leadingPadding: 20,
                                ),
                                //ignoreBlank: false,
                                initialValue: number,
                                textFieldController: _phoneController,
                                formatInput: true,
                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
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
                                textInputAction: TextInputAction.next,
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
                                  confirmPass = value;
                                  if (value == null || value == '') {
                                    return "Enter a password";
                                  }
                                  return null;
                                },
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
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                validator: (String? value) {
                                  if (value == null || value == '') {
                                    return "Repeat your password";
                                  }
                                  if (value != confirmPass) {
                                    return "Passwords don't match";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            /// SIGN UP BUTTON
                            FadeAnimation(
                              delay: 3.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF14C3AE), minimumSize: Size(w / 1.1, 47)),
                                onPressed: () {
                                  final isValid = formKey.currentState!.validate();
                                  if (isValid) {
                                    signUp();
                                  }
                                  ;
                                },
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
                          indent: 15,
                          endIndent: 15,
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
