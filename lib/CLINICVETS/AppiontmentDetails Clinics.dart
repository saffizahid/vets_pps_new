import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;

  BookingDetailsPage({required this.bookingId});

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  String clinicName = '';
  String clinicAddress = '';
  String vetname='';
  String vetid = '';
  String serviceTitle = '';
  String servicePrice = '';
  String bookingStart = '';
  String AppiontmentStatus = '';

  String ServiceDate = '';
  String ServiceTime = '';
  String FuserName = '';
  String LuserName = '';

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('booking')
        .doc(widget.bookingId)
        .get()
        .then((bookingDoc) {
      String clinicId = bookingDoc.get('ClinicID');
      String USERID = bookingDoc.get('userId');

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
          .collection('user')
          .doc(USERID)
          .get()
          .then((USERDoc) {
        setState(() {
          FuserName = USERDoc.get('firstname');
          LuserName = USERDoc.get('lastname');

        });
      });

      FirebaseFirestore.instance
          .collection('Clinics')
          .doc(clinicId)
          .get()
          .then((clinicDoc) {
        setState(() {
          clinicName = clinicDoc.get('clinicName');
          clinicAddress = clinicDoc.get('clinicAddress');

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
            Text(
              'Pet Owner Name: $FuserName $LuserName',
              style: TextStyle(fontSize: 20.0),
            ),

            Text(
              'Vet Name: $vetname',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Clinic Name: $clinicName',
              style: TextStyle(fontSize: 20.0),
            ),

            Text(
              'Clinic Address: $clinicAddress',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
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
