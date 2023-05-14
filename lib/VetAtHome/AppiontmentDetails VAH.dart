import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetailsPageVAH extends StatefulWidget {
  final String bookingId;

  BookingDetailsPageVAH({required this.bookingId});

  @override
  _BookingDetailsPageVAHState createState() => _BookingDetailsPageVAHState();
}

class _BookingDetailsPageVAHState extends State<BookingDetailsPageVAH> {
  String vetname='';
  String vetid = '';
  String serviceTitle = '';
  String servicePrice = '';
  String bookingStart = '';
  String AppiontmentStatus = '';

  String ServiceDate = '';
  String ServiceTime = '';

  String UserNAME = '';
  String UserAddress = '';
  String bookingInstructions = '';
  String UserPhoneNumber = '';


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('booking')
        .doc(widget.bookingId)
        .get()
        .then((bookingDoc) {
      String serviceName = bookingDoc.get('serviceName');
      vetid = bookingDoc.get('serviceId');

      setState(() {
        bookingStart = bookingDoc.get('bookingStart');
        DateTime bookingDateTime = DateTime.parse(bookingStart);
        vetid = bookingDoc.get('serviceId');
        AppiontmentStatus = bookingDoc.get('userName');


        ServiceDate = "${bookingDateTime.day}-${bookingDateTime.month}-${bookingDateTime.year}";
        ServiceTime = "${bookingDateTime.hour > 12 ? bookingDateTime.hour - 12 : bookingDateTime.hour}:${bookingDateTime.minute < 10 ? '0${bookingDateTime.minute}' : bookingDateTime.minute} ${bookingDateTime.hour >= 12 ? 'PM' : 'AM'}";


      });
      FirebaseFirestore.instance
          .collection('vets')
          .doc(vetid)
          .get()
          .then((clinicDoc) {
        setState(() {
          vetname = clinicDoc.get('name');

        });
      });
      FirebaseFirestore.instance
          .collection('Services')
          .doc(serviceName)
          .get()
          .then((serviceDoc) {
        setState(() {
          serviceTitle = serviceDoc.get('serviceTitle');
          servicePrice = serviceDoc.get('price');

        });
      });
      FirebaseFirestore.instance
          .collection('BookingInstructions')
          .doc(widget.bookingId)
          .get()
          .then((BookingInstructionsDoc) {
        setState(() {
          UserNAME = BookingInstructionsDoc.get('username');
          UserAddress = BookingInstructionsDoc.get('address');
          UserPhoneNumber = BookingInstructionsDoc.get('phoneNumber');
          bookingInstructions = BookingInstructionsDoc.get('bookingInstructions');

        });
      });


    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3,),

            Center(
              child: Text(
                'User Details:',
                style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'User Name: $UserNAME',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'User Address: $UserAddress',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'User Phone No: $UserPhoneNumber',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Appointment Instructions: $bookingInstructions',
              style: TextStyle(fontSize: 20.0),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              ),
    SizedBox(height: 10,),
            Center(
              child: Text(
                'Vet Details:',
                style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),
              ),
            ),

            Text(
              'Vet Name: $vetname',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Service Title: $serviceTitle',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Service Price: $servicePrice',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Appointment Status: $AppiontmentStatus',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Appointment Date: $ServiceDate',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Appointment Time: $ServiceTime',
              style: TextStyle(fontSize: 20.0),
            ),



          ],
        ),
      ),
    );
  }
}
