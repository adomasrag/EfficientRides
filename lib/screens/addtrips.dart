import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//

class AddTripsScreen extends StatefulWidget {
  const AddTripsScreen({Key? key}) : super(key: key);

  @override
  State<AddTripsScreen> createState() => _AddTripsState();
}

class _AddTripsState extends State<AddTripsScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  final _FromController = TextEditingController();
  final _ToController = TextEditingController();
  final _FreeSeatsController = TextEditingController();
  final _dateInputController = TextEditingController();

  @override
  void dispose() {
    _FromController.dispose();
    _ToController.dispose();
    _FreeSeatsController.dispose();
    _dateInputController.dispose();
    super.dispose();
  }

  Future addTrip() async {
    if (_FromController.text.isNotEmpty &
        _ToController.text.isNotEmpty &
        _FreeSeatsController.text.isNotEmpty &
        _dateInputController.text.isNotEmpty) {
      try {
        /// add trip details
        addTripDetails(
          _FromController.text.trim(),
          _ToController.text.trim(),
          int.parse(_FreeSeatsController.text.trim()),
          _dateInputController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trip added')));
        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        /// if firebase doesn't accept the details
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add a trip $error')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not all fields are filled')));
    }
  }

  Future addTripDetails(String from, String to, int freeSeats, String departure) async {
    await FirebaseFirestore.instance.collection("rides").add({
      'from': from,
      'to': to,
      'freeSeats': freeSeats,
      'departure': departure,
      'driverId': user.uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    /// CURRENT WIDTH AND HEIGHT
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(30, 40, 30, 20),
            width: w,
            height: h,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// From TextField
                  TextFormField(
                    controller: _FromController,
                    decoration: InputDecoration(
                      labelText: 'From',
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

                  const SizedBox(
                    height: 15,
                  ),

                  /// To TextField
                  TextFormField(
                    controller: _ToController,
                    decoration: InputDecoration(
                      labelText: 'To',
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
                  const SizedBox(
                    height: 15,
                  ),

                  /// Free Seats TextField
                  TextFormField(
                    controller: _FreeSeatsController,
                    decoration: InputDecoration(
                      labelText: 'Available seats',
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
                  const SizedBox(
                    height: 15,
                  ),

                  /// Date TextField
                  TextFormField(
                    controller: _dateInputController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      labelText: "Enter Date",
                      labelStyle: TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _dateInputController.text = formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(w / 1.1, h / 15)),
                    onPressed: addTrip,
                    child: const Text("Add this trip"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
