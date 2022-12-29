import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vets_pps_new/Vets%20Profile/styles/colors.dart';

import '../home_screen.dart';

class AricleScreen extends StatefulWidget {
  AricleScreen();

  @override
  AricleScreenState createState() => AricleScreenState();
}

class AricleScreenState extends State<AricleScreen>
    with SingleTickerProviderStateMixin {
  AricleScreenState();
  final CURRENTVET= FirebaseAuth.instance.currentUser!;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    var CURRENTUSERID= CURRENTVET.uid;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Your Appiotments",
            style: TextStyle(
                color: Color.fromRGBO(214, 217, 220, 1.0), fontSize: 15),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            },
            child: Icon(
              Icons.arrow_back_sharp, // add custom icons also
            ),
          )),

      // floatingActionButton: null,
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  // height: 50,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(26, 59, 106, 1.0),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TabBar(
                          unselectedLabelColor: Colors.white,
                          labelColor: Colors.black,
                          indicatorColor: Colors.white,
                          indicatorWeight: 0,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          controller: tabController,
                          tabs: [
                            Tab(
                              text: 'Upcoming Appointments',
                            ),
                            Tab(
                              text: 'Past Appointments',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Container(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("booking")
                                .where(
                              "vetid",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                            )
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  '${snapshot.error}',
                                  style: const TextStyle(color: Colors.white),
                                );
                              }
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      var document =snapshot.data.docs[index];
                                      var status = document!['status'];
                                      var USERID = document['userid'];
                                      var bookingID = document.id;
                                      var AppiotmentStatus = document['status'];


                                      return Column(
                                        children: [
                                          StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('user').doc(USERID)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                var  USERDATA= snapshot.data;
                                                var UserFirstName= USERDATA!['firstname'];
                                                var UserLastName= USERDATA!['lastname'];
                                                return Column(
                                                  children: [

                                                    if (status == "In Process"||status == "Accepted") ...[
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(15.0),
                                                        ),
                                                        elevation: 4,
                                                        color: Color.fromRGBO(237, 243, 253,
                                                            0.6980392156862745),
                                                        margin: EdgeInsets.only(top: 10),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(15),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.stretch,
                                                            children: [

                                                              Row(
                                                                children: [

                                                                  /*CircleAvatar(
                                                                    backgroundImage: NetworkImage( USERDATA!['profileImg'],
                                                                    ),
                                                                  ),*/
/*
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
*/

                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                      'Booked By: $UserFirstName $UserLastName',
                                                                        style: TextStyle(
                                                                          color: Color(
                                                                              MyColors
                                                                                  .header01),
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      /*Text(
                                                                        USERDATA!['subtitle'],
                                                                        style: TextStyle(
                                                                          color: Color(
                                                                              MyColors
                                                                                  .grey02),
                                                                          fontSize: 12,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                        ),
                                                                      ),
*/
                                                                    ],
                                                                  ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left:30),
                                                                    child: Row(
                                                                      children: [


                                                                        /*Icon(Icons.location_on,color: Color(
                                                                            MyColors
                                                                                .header01),
                                                                        ),*/
                                                                        /*Text(
                                                                          USERDATA!['ClinicName'],
                                                                          style: TextStyle(
                                                                            color: Color(
                                                                                MyColors
                                                                                    .header01),
                                                                            fontSize: 12,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                          ),
                                                                        ),*/
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 0,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Appiotment Status: ',
                                                                    style: TextStyle(
                                                                      color: Color(
                                                                          MyColors
                                                                              .header01),
                                                                      fontSize: 14,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                    ),
                                                                  ),

                                                                  Text(
                                                                    '$AppiotmentStatus',
                                                                    style: TextStyle(
                                                                      color: Color(
                                                                          MyColors
                                                                              .header01),
                                                                      fontSize: 14,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),

                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                  Color(MyColors.bg03),
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      10),
                                                                ),
                                                                width: double.infinity,
                                                                padding: EdgeInsets.all(20),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .calendar_today,
                                                                          color: Color(
                                                                              MyColors
                                                                                  .primary),
                                                                          size: 15,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text(
                                                                          document['BookingDate'],
                                                                          style: TextStyle(
                                                                            fontSize: 12,
                                                                            color: Color(
                                                                                MyColors
                                                                                    .primary),
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .access_alarm,
                                                                          color: Color(
                                                                              MyColors
                                                                                  .primary),
                                                                          size: 17,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text(
                                                                          document['BookingTime'],
                                                                          style: TextStyle(
                                                                            color: Color(
                                                                                MyColors
                                                                                    .primary),
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      final _db = FirebaseFirestore.instance;

                                                                      await _db.collection("booking").doc(bookingID).update({
                                                                        "status": "Canceled"
                                                                      });

                                                                    },
                                                                    child: Container(
                                                                      height:42,
                                                                      width:155,
                                                                      decoration: BoxDecoration(color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                          borderRadius: BorderRadius.circular(5)

                                                                      ),

                                                                      child: Center(child: Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      final _db = FirebaseFirestore.instance;

                                                                      await _db.collection("booking").doc(bookingID).update({
                                                                        "status": "Accepted"
                                                                      });

                                                                    },
                                                                    child: Container(
                                                                      height:42,
                                                                      width:155,
                                                                      decoration: BoxDecoration(color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                          borderRadius: BorderRadius.circular(5)

                                                                      ),

                                                                      child: Center(child: Text('Accept',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  final _db = FirebaseFirestore.instance;

                                                                  await _db.collection("booking").doc(bookingID).update({
                                                                    "status": "Completed"
                                                                  });

                                                                },
                                                                child: Container(
                                                                  height:42,
                                                                  decoration: BoxDecoration(color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                      borderRadius: BorderRadius.circular(5)

                                                                  ),

                                                                  child: Center(child: Text('Completed',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ] else
                                                      ...[],


                                                  ],




                                                );
                                              }),

                                        ],

                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(color: Colors.white),
                                );
                              }
                            }),
                      ),










                      /*SECONDE TAB CODE */
                      Container(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("booking")
                                .where(
                              "vetid",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                            )
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  '${snapshot.error}',
                                  style: const TextStyle(color: Colors.white),
                                );
                              }
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      var document =snapshot.data.docs[index];
                                      var status = document!['status'];
                                      var USERID = document['userid'];
                                      var bookingID = document.id;
                                      var AppiotmentStatus = document['status'];


                                      return Column(
                                        children: [
                                          StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('user').doc(USERID)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                var  USERDATA= snapshot.data;
                                                var UserFirstName= USERDATA!['firstname'];
                                                var UserLastName= USERDATA!['lastname'];
                                                return Column(
                                                  children: [

                                                    if (status == "Completed"||status == "Canceled") ...[
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(15.0),
                                                        ),
                                                        elevation: 4,
                                                        color: Color.fromRGBO(237, 243, 253,
                                                            0.6980392156862745),
                                                        margin: EdgeInsets.only(top: 10),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(15),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.stretch,
                                                            children: [

                                                              Row(
                                                                children: [

                                                                  /*CircleAvatar(
                                                                    backgroundImage: NetworkImage( USERDATA!['profileImg'],
                                                                    ),
                                                                  ),*/
/*
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
*/

                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                        'Booked By: $UserFirstName $UserLastName',
                                                                        style: TextStyle(
                                                                          color: Color(
                                                                              MyColors
                                                                                  .header01),
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      /*Text(
                                                                        USERDATA!['subtitle'],
                                                                        style: TextStyle(
                                                                          color: Color(
                                                                              MyColors
                                                                                  .grey02),
                                                                          fontSize: 12,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                        ),
                                                                      ),
*/
                                                                    ],
                                                                  ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left:30),
                                                                    child: Row(
                                                                      children: [


                                                                        /*Icon(Icons.location_on,color: Color(
                                                                            MyColors
                                                                                .header01),
                                                                        ),*/
                                                                        /*Text(
                                                                          USERDATA!['ClinicName'],
                                                                          style: TextStyle(
                                                                            color: Color(
                                                                                MyColors
                                                                                    .header01),
                                                                            fontSize: 12,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                          ),
                                                                        ),*/
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 0,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Appiotment Status: ',
                                                                    style: TextStyle(
                                                                      color: Color(
                                                                          MyColors
                                                                              .header01),
                                                                      fontSize: 14,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                    ),
                                                                  ),

                                                                  Text(
                                                                    '$AppiotmentStatus',
                                                                    style: TextStyle(
                                                                      color: Color(
                                                                          MyColors
                                                                              .header01),
                                                                      fontSize: 14,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),

                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                  Color(MyColors.bg03),
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      10),
                                                                ),
                                                                width: double.infinity,
                                                                padding: EdgeInsets.all(20),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .calendar_today,
                                                                          color: Color(
                                                                              MyColors
                                                                                  .primary),
                                                                          size: 15,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text(
                                                                          document['BookingDate'],
                                                                          style: TextStyle(
                                                                            fontSize: 12,
                                                                            color: Color(
                                                                                MyColors
                                                                                    .primary),
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .access_alarm,
                                                                          color: Color(
                                                                              MyColors
                                                                                  .primary),
                                                                          size: 17,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text(
                                                                          document['BookingTime'],
                                                                          style: TextStyle(
                                                                            color: Color(
                                                                                MyColors
                                                                                    .primary),
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),

                                                              SizedBox(
                                                                width: 20,
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ] else
                                                      ...[],


                                                  ],




                                                );
                                              }),

                                        ],

                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(color: Colors.white),
                                );
                              }
                            }),
                      ),
















                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
