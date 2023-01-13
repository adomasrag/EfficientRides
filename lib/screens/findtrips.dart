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

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('rides')
              .where("from".toString().toLowerCase(), isEqualTo: "Vilnius")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('An error has occured. ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot document = documents[index];

                    return ShoppingListItem(document: document);
                  });
            }
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
      title: Text(
        widget.document['from'] + ' - ' + widget.document['to'],
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        widget.document['driverId'],
        style: TextStyle(color: Colors.white),
      ),
      trailing: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.white,
        ),
        child: Checkbox(
          onChanged: (value) {
            setState(() {
              _purchased = value ?? false;
            });
          },
          value: _purchased,
        ),
      ),
    );
  }
}
