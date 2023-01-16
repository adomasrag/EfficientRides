import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:intl/intl.dart';
import '../models/userModel.dart';
import 'edit_item.dart';

class ItemDetails extends StatefulWidget {
  ItemDetails(this.itemId, {Key? key}) : super(key: key);
  final String itemId;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  late Map data;
  DocumentReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('rides').doc("MASdRkShiPSkP16W6C86");
  bool _reserveText = false;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> futureData =
      FirebaseFirestore.instance.collection('rides').doc(widget.itemId).snapshots();

  Future<UserModel?> readUser(driverId) async {
    final snapshot = await FirebaseFirestore.instance.doc('users/' + driverId).get();

    if (snapshot.exists)
      return UserModel.fromJson(snapshot.data()!);
    else
      return null;
  }

  Widget buildTrip(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip information'),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         //add the id to the map
        //         data['id'] = widget.itemId;
        //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditItem(data)));
        //       },
        //       icon: Icon(Icons.edit)),
        //   IconButton(
        //       onPressed: () {
        //         ref.delete();
        //       },
        //       icon: Icon(Icons.delete))
        // ],
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: futureData,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('An error has occurred. ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) data = snapshot.data!.data() as Map;
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('From: ${data['from']}', style: TextStyle(color: Colors.white, fontSize: 20)),
                          Text('To: ${data['to']}', style: TextStyle(color: Colors.white, fontSize: 20)),
                          Text(
                              '${DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(data['departureDate']))}, ${data['departureTime']}',
                              style: TextStyle(color: Colors.white, fontSize: 20)),
                          Text('${data['freeSeats']} free seats', style: TextStyle(color: Colors.white, fontSize: 20)),
                          Text('${data['pricePerPerson']}€ per person',
                              style: TextStyle(color: Colors.white, fontSize: 20)),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Colors.white,
                            height: 10,
                            thickness: 0.5,
                          ),
                          FutureBuilder<UserModel?>(
                            future: readUser(data['driverId']),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final user = snapshot.data;
                                return user == null ? Center(child: Text("Can't find driver info")) : buildUser(user);
                              } else {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.redAccent.shade100,
                                ));
                              }
                            },
                          ),
                        ],
                      ),
                      //Spacer(),
                      AnimatedButton(
                        height: 50,
                        width: 250,
                        text: _reserveText ? 'Seat reserved' : 'Reserve a seat',
                        isReverse: true,
                        transitionType: TransitionType.LEFT_TO_RIGHT,
                        textStyle: TextStyle(color: Colors.black),
                        backgroundColor: Colors.white,
                        selectedTextColor: Colors.black,
                        selectedBackgroundColor: Colors.lightGreen,
                        borderColor: Colors.black,
                        borderRadius: 0,
                        borderWidth: 2,
                        onPress: () {
                          Timer(
                            const Duration(milliseconds: 200),
                            () {
                              setState(() {
                                _reserveText = !_reserveText;
                              });
                              int freeSeats = data['freeSeats'];
                              if (_reserveText) {
                                Map<String, int> dataToUpdate = {'freeSeats': freeSeats - 1};
                                FirebaseFirestore.instance.collection('rides').doc(widget.itemId).update(dataToUpdate);

                                FirebaseFirestore.instance.collection('rides').doc(widget.itemId).update({
                                  "passengers": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                                });
                              } else {
                                Map<String, int> dataToUpdate = {'freeSeats': freeSeats + 1};
                                FirebaseFirestore.instance.collection('rides').doc(widget.itemId).update(dataToUpdate);

                                FirebaseFirestore.instance.collection('rides').doc(widget.itemId).update({
                                  "passengers": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
                                });
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Builder(builder: (context) {
        return buildTrip(context);
      })),
    );
  }

  Widget buildUser(UserModel user) => Container(
        height: 300,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {},

                /// Ateityje padaryt, kad nueitu i kito userio profili
                child: CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 25,
                  ),
                  backgroundColor: Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.firstName + ' ' + user.lastName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '+' + user.phone.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
