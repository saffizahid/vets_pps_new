import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vets_pps_new/CLINICVETS/navbarCLinics.dart';
import '../UpcomingAndPastAppiotments.dart';import 'Clinics/page/ClinicsList.dart';
import 'Clinics/page/copyofexsisting/clinicstesting.dart';
import 'Clinics/page/copyofexsisting/clinicstesting2.dart';
import 'Clinics/page/copyofexsisting/clinictestingedit.dart';
import 'Clinics/page/copyofexsisting/clinictetingform3.dart';
import 'Regiatration/register_screen_CLINICS.dart';


class HomePageClinics extends StatefulWidget {
  const HomePageClinics({Key? key}) : super(key: key);

  @override
  State<HomePageClinics> createState() => _HomePageClinicsState();
}

class _HomePageClinicsState extends State<HomePageClinics> {
  final user= FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      // Permission not granted
    }
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: NavBarClinics(),
      appBar: AppBar(
        title: Text('Home Page Clinics',style: TextStyle(color: Colors.white, fontSize: 16),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,

      ),body:
    StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("vets")
            .doc(user.uid)
            .snapshots(),
        builder: (context, sasapshot) {
          if (sasapshot.hasData && sasapshot.data!.exists) {
            var document = sasapshot.data;
            var status=document!["ProfileStatus"];
            return Container(
              width: w,
              height: h,
              child: Column(
                children: [
                  if (status == "Approved") ...[
                    Container(

                      decoration: BoxDecoration(color: Colors.white),

                      child:

                      Column(
                        children: [

                          InkWell(

                            child: Container(
                              margin: const EdgeInsets.only(top: 80, left: 0),
                            ),
                          ),
                          InkWell(

                            child: Container(
                              margin: const EdgeInsets.only(top: 10, left: 0),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return  AricleScreen();
                                      }
                                  )
                              );

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top:50),
                              child: Container(
                                height:80,
                                decoration: BoxDecoration(color: Color.fromRGBO(26, 59, 106, 1.0),
                                    borderRadius: BorderRadius.circular(5)

                                ),

                                child: Center(child: Text('Click Here to See Your Appointments',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

                              ),
                            ),
                          ),


                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return  ClinicLists();
                                      }
                                  )
                              );

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top:50),
                              child: Container(
                                height:80,
                                decoration: BoxDecoration(color: Color.fromRGBO(26, 59, 106, 1.0),
                                    borderRadius: BorderRadius.circular(5)

                                ),

                                child: Center(child: Text('Clinics ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return  VetClinicShopForm();
                                      }
                                  )
                              );

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top:50),
                              child: Container(
                                height:80,
                                decoration: BoxDecoration(color: Color.fromRGBO(26, 59, 106, 1.0),
                                    borderRadius: BorderRadius.circular(5)

                                ),

                                child: Center(child: Text('testing ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return  TimeRangePickerExample();
                                      }
                                  )
                              );

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top:50),
                              child: Container(
                                height:80,
                                decoration: BoxDecoration(color: Color.fromRGBO(26, 59, 106, 1.0),
                                    borderRadius: BorderRadius.circular(5)

                                ),

                                child: Center(child: Text('testing ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),

                              ),
                            ),
                          ),

                        ],
                      ),

                    ),



                  ] else if(status == "UnApproved")...[
                    Text("Your Profile Is In Approval Status")

                  ],
                ],


              ),
            );
          }
          else if (sasapshot.connectionState ==
              ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          else{
            return Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  Center(child: Text("Please Create Vet Profile" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30))),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)
                              {
                                return  RegisterationScreen();
                              }
                          )
                      );
                    },

                    child: Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Container(

                        height: 60,
                        width: 300,
                        color: Color.fromRGBO(7, 24, 47, 0.9294117647058824),
                        child: Center(child: Text("Add Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 19),)),

                      ),
                    ),
                  ),


                ],

              ),

            );
          }
        }
    ),
    );
  }
}

