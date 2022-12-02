import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//
import '../animation/fadeanimation.dart';

class PaymentInfoScreen extends StatefulWidget {
  const PaymentInfoScreen({Key? key}) : super(key: key);

  @override
  State<PaymentInfoScreen> createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfoScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mokėjimo informacija"),
        centerTitle: true,
      ),
      // FadeAnimation(
      //   delay: 0,
      //   child: EmptyWidget,
      // )
    );
  }
}
