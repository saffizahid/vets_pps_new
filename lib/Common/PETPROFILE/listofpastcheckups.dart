import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../CLINICVETS/AppiontmentDetails Clinics.dart';
import '../../VetAtHome/AppiontmentDetails VAH.dart';


class PetBookingsCard extends StatefulWidget {
  final String petId;

  PetBookingsCard({required this.petId});

  @override
  _PetBookingsCardState createState() =>
      _PetBookingsCardState();
}

class _PetBookingsCardState extends State<PetBookingsCard> {
  late Stream<QuerySnapshot> _bookingsStream;

  @override
  void initState() {
    super.initState();
    _bookingsStream = FirebaseFirestore.instance
        .collection('booking')
        .where('PetID', isEqualTo: widget.petId)
        .where('userName', isEqualTo: 'Completed').orderBy('bookingStart', descending: true) // Sort by 'bookingstart' in descending order
    // Added condition here
        .get()
        .asStream();
  }

  Future<String> getServiceTitle(String serviceName) async {
    final serviceDoc = await FirebaseFirestore.instance
        .collection('Services')
        .doc(serviceName)
        .get();
    return serviceDoc.get('serviceTitle');
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bookingsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return Text(
              'No past appointments found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Text(
                  'Past PPS Appointments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final serviceName = booking['serviceName'];
                  final bookingStart = booking['bookingStart'];
                  final formattedDate = formatDate(bookingStart);
                  var VetTypeBooking = booking['VetType'];

                  return FutureBuilder<String>(
                    future: getServiceTitle(serviceName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        final serviceTitle = snapshot.data!;
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              serviceTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                color: Colors.black54,
                              ),
                            ),
                            trailing: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(26, 59, 106, 1.0),
                                ),
                              ),
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                if (VetTypeBooking == "Clinic") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingDetailsPage(
                                        bookingId: booking.id,
                                      ),
                                    ),
                                  );
                                } else if (VetTypeBooking == "VAH") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingDetailsPageVAH(
                                        bookingId: booking.id,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),

                            ),
                        );
                      } else {
                        return Text('Error fetching service title');
                      }
                    },
                  );
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
