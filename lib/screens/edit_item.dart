import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditItem extends StatelessWidget {
  EditItem(this._shoppingItem, {Key? key}) {
    _controllerFrom = TextEditingController(text: _shoppingItem['from']);
    _controllerTo = TextEditingController(text: _shoppingItem['to']);

    _reference = FirebaseFirestore.instance.collection('rides').doc(_shoppingItem['id']);
  }

  Map _shoppingItem;
  late DocumentReference _reference;

  late TextEditingController _controllerFrom;
  late TextEditingController _controllerTo;
  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Edit an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerFrom,
                decoration: InputDecoration(hintText: 'Enter from'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerTo,
                decoration: InputDecoration(hintText: 'Enter to'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item quantity';
                  }

                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      String from = _controllerFrom.text;
                      String to = _controllerTo.text;

                      //Create the Map of data
                      Map<String, String> dataToUpdate = {'from': from, 'to': to};

                      //Call update()
                      _reference.update(dataToUpdate);
                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
