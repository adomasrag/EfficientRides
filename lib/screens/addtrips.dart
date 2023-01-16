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
  int _pricePerPerson = 0;
  int _freeSeats = 0;
  final user = FirebaseAuth.instance.currentUser!;

  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _dateInputController = TextEditingController();
  final _timeInputController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _dateInputController.dispose();
    _timeInputController.dispose();
    super.dispose();
  }

  Future addTrip() async {
    if (_fromController.text.isNotEmpty &
        _toController.text.isNotEmpty &
        _dateInputController.text.isNotEmpty &
        _timeInputController.text.isNotEmpty) {
      try {
        /// add trip details
        addTripDetails(
          _fromController.text.trim(),
          _toController.text.trim(),
          _dateInputController.text,
          _timeInputController.text,
          _freeSeats,
          _pricePerPerson,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trip added')));
        Timer(const Duration(seconds: 1), () {
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

  Future addTripDetails(
      String from, String to, String departureDate, String departureTime, int freeSeats, int pricePerPerson) async {
    await FirebaseFirestore.instance.collection("rides").add({
      'from': from,
      'to': to,
      'departureDate': departureDate,
      'departureTime': departureTime,
      'freeSeats': freeSeats,
      'pricePerPerson': pricePerPerson,
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
                  SizedBox(
                    height: 5,
                  ),

                  /// From TextField
                  TextFormField(
                    controller: _fromController,
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
                    controller: _toController,
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
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _dateInputController,
                          decoration: InputDecoration(
                            labelText: "Departure date",
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
                      ),

                      /// DEPARTURE DATE
                      const SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: _timeInputController,
                          decoration: InputDecoration(
                            labelText: "Departure time",
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
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child ?? Container(),
                                  );
                                });
                            if (pickedTime != null) {
                              print(pickedTime); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedTime =
                                  "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                              print(formattedTime); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                _timeInputController.text = formattedTime; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ),
                      ),

                      /// DEPARTURE TIME
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 100,
                        width: w / 2.5,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "PRICE PER PERSON",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1, color: Colors.white),
                                      color: Colors.transparent,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _pricePerPerson++;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(100),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "$_pricePerPerson€",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1, color: Colors.white),
                                      color: Colors.transparent,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (_pricePerPerson > 0) {
                                          setState(() {
                                            _pricePerPerson--;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(100),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// PRICE PER PERSON
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 100,
                        width: w / 2.5,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "AVAILABLE SEATS",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1, color: Colors.white),
                                      color: Colors.transparent,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (_freeSeats < 10) {
                                          setState(() {
                                            _freeSeats++;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(100),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "$_freeSeats",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1, color: Colors.white),
                                      color: Colors.transparent,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (_freeSeats > 0) {
                                          setState(() {
                                            _freeSeats--;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(100),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
