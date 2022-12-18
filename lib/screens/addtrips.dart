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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kelionė pridėta')));

        /// if firebase doesn't accept the details
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nepavyko pridėti kelionės $error')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Neužpildyti visi laukeliai')));
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
        appBar: AppBar(
          title: const Text("Pridėti kelionę"),
          centerTitle: true,
        ),

        /// Body
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/efficientRides-11.jpg"),
            fit: BoxFit.fill,
          )),
          width: w,
          height: h,
          child: Container(
            margin: const EdgeInsets.all(17),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// From TextField
                  TextField(
                    controller: _FromController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pradžios taškas',
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  /// To TextField
                  TextField(
                    controller: _ToController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Kelionės tikslas',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  /// Free Seats TextField
                  TextField(
                    controller: _FreeSeatsController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Laisvų vietų',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  /// Date TextField
                  TextField(
                    controller: _dateInputController,
                    decoration: InputDecoration(icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
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
                    child: const Text("Pridėti"),
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