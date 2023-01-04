import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/findtrips.dart';
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

  @override
  Widget buildHeader(UserModel user, double w, double h) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                FadeAnimation(
                  delay: 2.5,
                  child: Container(
                    child: SizedBox(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AvailableTripsScreen()),
                          );
                        },
                        child: const Text(
                          "Find a ride",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 15),
                    width: w / 1.5,
                    height: h / 12,
                    alignment: Alignment.center,
                  ),
                ),
                /*Expanded(
                  child: SingleChildScrollView(
                    //padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
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
                              shrinkWrap: true,
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
                ),*/
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    print('Namukas build');

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
          child: FutureBuilder<UserModel?>(
              future: readUser(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                return user == null ? Center(child: Text('User error')) : buildHeader(user, w, h);
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
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemDetails(widget.document.id)));
      },
      title: Text(
        widget.document['from'],
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        widget.document['to'],
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
