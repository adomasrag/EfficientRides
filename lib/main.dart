import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/authenticate/login.dart';
import 'package:loginuicolors/screens/authenticate/register.dart';
import 'package:loginuicolors/wrapper.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Wrapper(),
  ));
}
