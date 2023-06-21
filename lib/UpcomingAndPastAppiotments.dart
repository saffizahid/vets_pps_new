import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Authntication/auth_page.dart';
import 'CLINICVETS/AppiontmentDetails Clinics.dart';
import 'CLINICVETS/home_screen_clinics.dart';
import 'Common/PETPROFILE/ViewPetProfile.dart';
import 'Style/styles/colors.dart';
import 'VETATHOME/home_screen_vetathome.dart';
import 'VetAtHome/AppiontmentDetails VAH.dart';

class UpcomingAndPastAppointments extends StatefulWidget {
  String ProfileType;
  UpcomingAndPastAppointments({Key? key,required this.ProfileType}) : super(key: key);


  @override
  UpcomingAndPastAppointmentsState createState() => UpcomingAndPastAppointmentsState();
}

class UpcomingAndPastAppointmentsState extends State<UpcomingAndPastAppointments>
    with SingleTickerProviderStateMixin {
  UpcomingAndPastAppointmentsState();
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
    var CURRENTVETID= CURRENTVET.uid;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Your Appointment's",
            style: TextStyle(
                color: Color.fromRGBO(214, 217, 220, 1.0), fontSize: 15),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              if (widget.ProfileType == 'Clinic') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageClinics()),
                );
              } else if (widget.ProfileType == 'VETATHOME') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageVetAtHome()),
                );
              }
            },
            child: Icon(
            Icons.arrow_back_sharp,color: Colors.white, // add custom icons also
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
                              "serviceId",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                            )
                                .orderBy("bookingStart", descending: false) // sort by bookingStart in descending order
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
                                      var status = document!['userName'];
                                      var USERID = document['userId'];
                                      var servicePrice = document['servicePrice'];
                                      var PETID = document['PetID'];

                                      var bookingID = document.id;
                                      var AppiotmentStatus = document['userName'];
                                      var DateTimeOld =DateTime.tryParse(document['bookingStart']);
                                      var DateLatest = DateFormat.yMMMEd().format(DateTimeOld!);
                                      var TimeLatest = DateFormat.jm().format(DateTimeOld!);


                                      print(DateLatest);
                                      print(TimeLatest);


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

                                                    if (status == "In Process"||status == "Accepted"||status == "Appointment Started") ...[
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
                                                                    ],
                                                                  ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left:30),
                                                                    child: Row(
                                                                      children: [


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
                                                              Text(
                                                                'Total Order Price: '+servicePrice.toString(),
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
                                                                          DateLatest,
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
                                                                          TimeLatest,
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
                                                                  if (status == "Accepted") ...[

                                                                    InkWell(
                                                                      onTap: () {
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (ctx) => AlertDialog(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),

                                                                            title: const Text("Cancel Booking",style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18,color: Color.fromRGBO(26, 59, 106, 1.0),

                                                                            ),
                                                                            ),
                                                                            content: const Text("Are you sure you want to cancel this booking",
                                                                              style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,
                                                                                color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                              ),

                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                child: const Text('No',style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 18,color: Color.fromRGBO(26, 59, 106, 1.0),

                                                                                ),),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              ),
                                                                              TextButton(
                                                                                child:
                                                                                const Text('Yes',style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 18,color: Color.fromRGBO(26, 59, 106, 1.0),

                                                                        ),),
                                                                                onPressed: () async {
                                                                                  try {
                                                                                    final _db = FirebaseFirestore.instance;
                                                                                    await _db.collection("booking").doc(bookingID).update({"userName": "Cancelled by Vet"});

                                                                                    final canceldb0 = FirebaseFirestore.instance;
                                                                                    DocumentSnapshot doc = await canceldb0.collection("vet_temp_wallet").doc(bookingID).get();
                                                                                    int CaneledAmountVet = doc.get("wallet").toInt();
                                                                                    print("CaneledAmountVet = ");
                                                                                    print(CaneledAmountVet);

                                                                                    final canceldb011 = FirebaseFirestore.instance;
                                                                                    DocumentSnapshot doc245 = await canceldb011.collection("comapny_temp_wallet").doc(bookingID).get();
                                                                                    print("hey = ");

                                                                                    String CanecledComa = doc245.get("status");
                                                                                    print("status = ");
                                                                                    print(CanecledComa);
                                                                                    int CanecledComapnyAmount = doc245.get("wallet").toInt();
                                                                                    print("CanecledComapnyAmount = ");
                                                                                    print(CanecledComapnyAmount);

                                                                                    DocumentSnapshot userdata = await canceldb0.collection("user").doc(USERID).get();
                                                                                    int UserBalance = userdata.get("wallet").toInt();
                                                                                    print("UserBalance = ");
                                                                                    print(UserBalance);

                                                                                    int NewBalance = UserBalance + CaneledAmountVet + CanecledComapnyAmount;


                                                                                    final canceldb = FirebaseFirestore.instance;
                                                                                    await canceldb.collection("vet_temp_wallet").doc(bookingID).update({"status": "Cancelled by Vet","wallet":0});

                                                                                    final canceldb2 = FirebaseFirestore.instance;
                                                                                    await canceldb2.collection("comapny_temp_wallet").doc(bookingID).update({"status": "Cancelled by Vet","wallet":0});

                                                                                    final canceldb3 = FirebaseFirestore.instance;
                                                                                    await canceldb3.collection("user").doc(USERID).update({"wallet":NewBalance});

                                                                                    print("All statements executed successfully!");
                                                                                    Navigator.of(context).pop();
                                                                                  } catch (e) {
                                                                                    print("An error occurredsssssssssss: $e");
                                                                                  }
                                                                                  Navigator.of(context).pop();

                                                                                },
                                                                              ),
                                                                            ],),
                                                                        );
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
                                                                      onTap: () {
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (ctx) => AlertDialog(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),

                                                                            title: const Text("Start Appointment",style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18,color: Color.fromRGBO(26, 59, 106, 1.0),

                                                                            ),
                                                                            ),
                                                                            content: const Text("Are you sure you want to Start this Appointment",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                            ),
                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                child: const Text('No',style: TextStyle(
                                                                                  color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                                  fontSize: 16,
                                                                                ),
                                                                                ),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              ),
                                                                              TextButton(
                                                                                child: const Text('Yes',style: TextStyle(
                                                                                  color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                                  fontSize: 16,
                                                                                ),
                                                                                ),
                                                                                onPressed: () async {
                                                                                  final _db = FirebaseFirestore.instance;

                                                                                  await _db.collection("booking").doc(bookingID).update({
                                                                                    "userName": "Appointment Started"
                                                                                  }
                                                                                  );
                                                                                  Navigator.of(context).pop();

                                                                                },
                                                                              ),
                                                                            ],),
                                                                        );
                                                                      },
                                                                      child: Container(
                                                                        height:42,
                                                                        width:155,
                                                                        decoration: BoxDecoration(color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                            borderRadius: BorderRadius.circular(5)

                                                                        ),

                                                                        child: Center(child: Text('Start Appointment',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

                                                                      ),
                                                                    ),

                                                                  ]
                                                                  else
                                                                    ...[
                                                                      InkWell(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (ctx) => AlertDialog(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),

                                                                              title: const Text("Complete Booking",style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18,color: Color.fromRGBO(26, 59, 106, 1.0),

                                                                              ),
                                                                              ),
                                                                              content: const Text("Are you sure you want to Complete this booking?",
                                                                                style: TextStyle(
                                                                                  color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                                  fontSize: 16,
                                                                                ),

                                                                              ),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  child: const Text('No',  style: TextStyle(
                                                                                    color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                                TextButton(
                                                                                  child: const Text('Yes',  style: TextStyle(
                                                                                    color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    try {
                                                                                      final _db = FirebaseFirestore.instance;
                                                                                      await _db.collection("booking").doc(bookingID).update({"userName": "Completed"});

                                                                                      final canceldb0 = FirebaseFirestore.instance;
                                                                                      DocumentSnapshot doc = await canceldb0.collection("vet_temp_wallet").doc(bookingID).get();
                                                                                      int TempAmountVet = doc.get("wallet").toInt();
                                                                                      print("TempAmountVet = ");
                                                                                      print(TempAmountVet);

                                                                                      final canceldb011 = FirebaseFirestore.instance;
                                                                                      DocumentSnapshot doc245 = await canceldb011.collection("comapny_temp_wallet").doc(bookingID).get();
                                                                                      int TempComapnyAmount = doc245.get("wallet").toInt();

                                                                                      DocumentSnapshot userdata = await canceldb0.collection("vet_wallet").doc(CURRENTVETID).get();
                                                                                      int UserBalance = userdata.get("wallet").toInt();
                                                                                      print("UserBalance = ");
                                                                                      print(UserBalance);

                                                                                      int NewBalance = UserBalance + TempAmountVet;

                                                                                      DocumentSnapshot ComapnyWalletData = await canceldb0.collection("company_wallet").doc("Company_wallet").get();
                                                                                      int ComapnyBalance = ComapnyWalletData.get("wallet").toInt();
                                                                                      print("ComapnyBalance = ");
                                                                                      print(ComapnyBalance);

                                                                                      int NewComapnyBalance = ComapnyBalance + TempComapnyAmount;

                                                                                      final canceldb = FirebaseFirestore.instance;
                                                                                      await canceldb.collection("vet_temp_wallet").doc(bookingID).update({"status": "Completed","wallet":0});

                                                                                      final canceldb2 = FirebaseFirestore.instance;
                                                                                      await canceldb2.collection("comapny_temp_wallet").doc(bookingID).update({"status": "Completed","wallet":0});

                                                                                      final canceldb3 = FirebaseFirestore.instance;
                                                                                      await canceldb3.collection("vet_wallet").doc(CURRENTVETID).update({"wallet":NewBalance});

                                                                                      final canceldb4 = FirebaseFirestore.instance;
                                                                                      await canceldb4.collection("company_wallet").doc("Company_wallet").update({"wallet":NewComapnyBalance});

                                                                                      final _ratingbooking = FirebaseFirestore.instance;
                                                                                      await _ratingbooking.collection("ratings").doc(bookingID).set({
                                                                                        "ratingstatus": "NotGiven",
                                                                                        "rating": 5,
                                                                                        "userid": USERID,
                                                                                        "vetid": CURRENTVETID,
                                                                                        "review": ""
                                                                                      });
                                                                                      FirebaseFirestore.instance.collection("TransactionsWalletVet").doc().set({
                                                                                        "TransactionType": "CompleteAppointment",
                                                                                        "Status": "Deposit",
                                                                                        "TransactionAmount": TempAmountVet,
                                                                                        "TransactionDate": DateTime.now(),
                                                                                        "booking_id": bookingID,
                                                                                        "vet_id": CURRENTVETID,
                                                                                        "user_id": USERID,
                                                                                      });

                                                                                      print("All statements executed successfully!");
                                                                                      Navigator.of(context).pop();
                                                                                    } catch (e) {
                                                                                      print("An error occurredsssssssssss: $e");
                                                                                    }
                                                                                    Navigator.of(context).pop();

                                                                                  },),
                                                                              ],),
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          height:42,
                                                                          width:320,
                                                                          decoration: BoxDecoration(color: Color.fromRGBO(26, 59, 106, 1.0),
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child: Center(child: Text('Complete Appointment',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

                                                                        ),
                                                                      ),

                                                                    ],



                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,),


                                                              if ( widget.ProfileType == "Clinic") ...[
                                                                InkWell(
                                                                  onTap: () {

                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context)
                                                                            {
                                                                              return  BookingDetailsPage(bookingId: bookingID,);
                                                                            }
                                                                        )
                                                                    );

                                                                  },
                                                                  child: Container(
                                                                    height: 42,
                                                                    decoration: BoxDecoration(
                                                                        color: Color
                                                                            .fromRGBO(
                                                                            26,
                                                                            59,
                                                                            106,
                                                                            1.0),
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            5)),
                                                                    child: Center(
                                                                        child: Text(
                                                                          'View Appointment Details',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        )),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,),

                                                              ],
                                                              if ( widget.ProfileType == "VETATHOME") ...[
                                                                InkWell(
                                                                  onTap: () {

                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context)
                                                                            {
                                                                              return  BookingDetailsPageVAH(bookingId: bookingID,);
                                                                            }
                                                                        )
                                                                    );

                                                                  },
                                                                  child: Container(
                                                                    height: 42,
                                                                    decoration: BoxDecoration(
                                                                        color: Color
                                                                            .fromRGBO(
                                                                            26,
                                                                            59,
                                                                            106,
                                                                            1.0),
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            5)),
                                                                    child: Center(
                                                                        child: Text(
                                                                          'View Appointment Details',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        )),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,),

                                                              ],
                                                              InkWell(
                                                                onTap: () {

                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context)
                                                                          {
                                                                            return  ViewPetProfile(petId: PETID,);
                                                                          }
                                                                      )
                                                                  );

                                                                },
                                                                child: Container(
                                                                  height: 42,
                                                                  decoration: BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                          26,
                                                                          59,
                                                                          106,
                                                                          1.0),
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          5)),
                                                                  child: Center(
                                                                      child: Text(
                                                                        'View Pet Profile',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                      )),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,),

                                                              SizedBox(
                                                                height: 10,
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


                            }
                        )



                      ),










                      /*SECONDE TAB CODE */
                      Container(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("booking")
                                .where(
                              "serviceId",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                            )
                                .orderBy("bookingStart", descending: true) // sort by bookingStart in descending order
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
                                      var status = document!['userName'];
                                      var USERID = document['userId'];
                                      var bookingID = document.id;
                                      var AppiotmentStatus = document['userName'];
                                      var DateTimeOld =DateTime.tryParse(document['bookingStart']);
                                      var DateLatest = DateFormat.yMMMEd().format(DateTimeOld!);
                                      var TimeLatest = DateFormat.jm().format(DateTimeOld!);

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

                                                    if (status == "Completed"||status == "Cancelled by Vet"||status == "Cancelled by User") ...[
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
                                                                          DateLatest,
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
                                                                          TimeLatest,
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
                                                              if ( widget.ProfileType == "Clinic") ...[
                                                                InkWell(
                                                                  onTap: () {

                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context)
                                                                            {
                                                                              return  BookingDetailsPage(bookingId: bookingID,);
                                                                            }
                                                                        )
                                                                    );

                                                                  },
                                                                  child: Container(
                                                                    height: 42,
                                                                    decoration: BoxDecoration(
                                                                        color: Color
                                                                            .fromRGBO(
                                                                            26,
                                                                            59,
                                                                            106,
                                                                            1.0),
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            5)),
                                                                    child: Center(
                                                                        child: Text(
                                                                          'View Appointment Details',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        )),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,),

                                                              ],
                                                              if ( widget.ProfileType == "VETATHOME") ...[
                                                                InkWell(
                                                                  onTap: () {

                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context)
                                                                            {
                                                                              return  BookingDetailsPageVAH(bookingId: bookingID,);
                                                                            }
                                                                        )
                                                                    );

                                                                  },
                                                                  child: Container(
                                                                    height: 42,
                                                                    decoration: BoxDecoration(
                                                                        color: Color
                                                                            .fromRGBO(
                                                                            26,
                                                                            59,
                                                                            106,
                                                                            1.0),
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            5)),
                                                                    child: Center(
                                                                        child: Text(
                                                                          'View Appointment Details',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        )),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,),

                                                              ],

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
