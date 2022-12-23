import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'itemdetails.dart';
//
import '../animation/fadeanimation.dart';

class AvailableTripsScreen extends StatefulWidget {
  const AvailableTripsScreen({Key? key}) : super(key: key);

  @override
  State<AvailableTripsScreen> createState() => _AvailableTripsState();
}

class _AvailableTripsState extends State<AvailableTripsScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  CollectionReference _referenceRides = FirebaseFirestore.instance.collection('rides');

  late Stream<QuerySnapshot> _streamRides;

  initState() {
    super.initState();
    _streamRides = _referenceRides.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _streamRides,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('An error has occured. ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot document = documents[index];

                    return ShoppingListItem(document: document);
                  });
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class ShoppingListItem extends StatefulWidget {
  const ShoppingListItem({
    Key? key,
    required this.document,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> document;

  @override
  State<ShoppingListItem> createState() => _ShoppingListItemState();
}

class _ShoppingListItemState extends State<ShoppingListItem> {
  bool _purchased = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemDetails(widget.document.id)));
      },
      title: Text(widget.document['from'] + ' - ' + widget.document['to']),
      subtitle: Text(widget.document['driverId']),
      trailing: Checkbox(
        onChanged: (value) {
          setState(() {
            _purchased = value ?? false;
          });
        },
        value: _purchased,
      ),
    );
  }
}
