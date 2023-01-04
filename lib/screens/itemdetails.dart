import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_item.dart';

class ItemDetails extends StatelessWidget {
  void _ifOwner() async {
    _futureData;

    if (FirebaseAuth.instance.currentUser!.uid == data['driverId']) {
      print("mano");
    }
  }

  ItemDetails(this.itemId, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('rides').doc(itemId);
    _futureData = _reference.get();
  }

  String itemId;
  late DocumentReference _reference;

  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  Widget buildTrip(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelionės informacija'),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       //add the id to the map
          //       data['id'] = itemId;
          //
          //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditItem(data)));
          //     },
          //     icon: Icon(Icons.edit)),
          // IconButton(
          //     onPressed: () {
          //       //Delete the item
          //       _reference.delete();
          //     },
          //     icon: Icon(Icons.delete))
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            //Get the data
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;

            //display the data
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${data['from']}'),
                  Text('${data['to']}'),
                  Text('${data['departure']}'),
                  Text('${data['driverId']}'),
                  Text('${data['freeSeats']}'),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ifOwner();
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(child: Builder(builder: (context) {
        return buildTrip(context);
      })),
    );
  }
}
