import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPetIdToBooking extends StatefulWidget {
  @override
  _AddPetIdToBookingState createState() => _AddPetIdToBookingState();
}

class _AddPetIdToBookingState extends State<AddPetIdToBooking> {
  CollectionReference bookingCollection =
  FirebaseFirestore.instance.collection('booking');

  Future<void> addPetIdToDocuments() async {
    QuerySnapshot snapshot = await bookingCollection.get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    // Iterate over each document
    for (var document in documents) {
      // Get the document's ID
      String documentId = document.id;
      // Update the document with the "PetID" field and its value
      bookingCollection.doc(documentId).update({'PetID': 'WIXs8MXojWPqv42IEWlH'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add PetID to Booking Documents'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            addPetIdToDocuments();
          },
          child: Text('Add PetID'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Add PetID to Booking Documents',
    home: AddPetIdToBooking(),
  ));
}
