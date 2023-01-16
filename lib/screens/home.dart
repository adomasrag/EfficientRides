import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'addtrips.dart';
import 'itemdetails.dart';
import '../animation/fadeanimation.dart';
import '../models/userModel.dart';

class NamaiScreen extends StatefulWidget {
  const NamaiScreen({Key? key}) : super(key: key);

  @override
  State<NamaiScreen> createState() => _NamaiState();
}

class _NamaiState extends State<NamaiScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference _referenceRides = FirebaseFirestore.instance.collection('rides');
  late Stream<QuerySnapshot> _streamRides;
  initState() {
    super.initState();
    _streamRides = _referenceRides.snapshots();
  }

  Future<UserModel?> readUser() async {
    final docUser = FirebaseFirestore.instance.doc('users/' + FirebaseAuth.instance.currentUser!.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists)
      return UserModel.fromJson(snapshot.data()!);
    else
      return null;
  }

  Widget buildHeader(UserModel user, double w, double h) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: Colors.white),
                            fixedSize: Size(150, 50),
                          ),
                          child: Text('Filter', style: TextStyle(color: Colors.white)),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.teal.shade500,
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        height: 50,
                        width: 50,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTripsScreen()));
                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
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
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<UserModel?>(
              future: readUser(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                return user == null ? Center(child: CircularProgressIndicator()) : buildHeader(user, w, h);
              })),
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.zero,
          //height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          child: ListTile(
            //visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            minVerticalPadding: 15,
            contentPadding: EdgeInsets.fromLTRB(16, -20, 16, 0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemDetails(widget.document.id)));
            },
            title: Text(
              "${widget.document['from']} - ${widget.document['to']}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${widget.document['departureDate']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  "${widget.document['departureTime']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: "Price per person: ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                            text: "${widget.document['pricePerPerson']}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ))
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: "Free seats: ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                            text: "${widget.document['freeSeats']}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ))
                      ]),
                ),
              ],
            ),
            // trailing: Theme(
            //   data: Theme.of(context).copyWith(
            //     unselectedWidgetColor: Colors.white,
            //   ),
            //   child: Checkbox(
            //     onChanged: (value) {
            //       setState(() {
            //         _purchased = value ?? false;
            //       });
            //     },
            //     value: _purchased,
            //   ),
            // ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
