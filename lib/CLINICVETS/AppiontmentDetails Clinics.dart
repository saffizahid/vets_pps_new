import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../UpcomingAndPastAppiotments.dart';

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
  Color themeColor = const Color.fromRGBO(26, 59, 106, 1.0);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: themeColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpcomingAndPastAppointments(
                      ProfileType: 'Clinic',
                    )),
              );
            },
            child: Icon(
              Icons.arrow_back_sharp,
              color: Colors.white, // add custom icons also
            ),
          )),
      body: Container(
        color: themeColor,
        height: h,
        width: w,
        child: Padding(
          padding: EdgeInsets.only(top: 55.0, bottom: 65, left: 10, right: 10),
          child: Container(
            height: h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.0),

                    Center(

                      child: Text(
                        'Appointment Details'.toUpperCase(),
                        style: TextStyle(
                          color: Color.fromRGBO(26, 59, 106, 1.0),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Pet Owner Name:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "$FuserName $LuserName",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Vet Name:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              vetname,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Clinic Name:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              clinicName,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Clinic Address:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              clinicAddress,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Service Title:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              serviceTitle,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Service Price:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              servicePrice,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Appointment Status:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              AppiontmentStatus,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Appointment Date",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              ServiceDate,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Appointment Time:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              ServiceTime,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Add additional rows or widgets as needed

                    // SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
