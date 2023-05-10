import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vets_pps_new/CLINICVETS/navbarCLinics.dart';
import 'package:vets_pps_new/VetAtHome/ServiceTime/page/VHomeTime.dart';
import 'package:vets_pps_new/VetAtHome/register_screen_VETATHOME.dart';
import '../UpcomingAndPastAppiotments.dart';import '../CLINICVETS/Regiatration/register_screen_CLINICS.dart';
import '../main.dart';
import 'navbarvetathome.dart';

class HomePageVetAtHome extends StatefulWidget {
  const HomePageVetAtHome({Key? key}) : super(key: key);

  @override
  State<HomePageVetAtHome> createState() => _HomePageVetAtHomeState();
}

class _HomePageVetAtHomeState extends State<HomePageVetAtHome> {
  final user= FirebaseAuth.instance.currentUser!;
   String name="abc";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('vets')
        .doc(user.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          name = doc['name'];
        });
      }
    });
  }

//Hello Dr. <vet name> not displayed yet.

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: NavBarVAH(),
      appBar: AppBar(
        //title: Text('Hi, '+ name,style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0), fontSize: 15),),

        title: Text('Home Page Vet At Home'!,style: TextStyle(color: Colors.white, fontSize: 16),),
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
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 20.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome,',
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    'We are excited to have you with us!',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),


                          InkWell(

                            child: Container(
                              margin: const EdgeInsets.only(top: 0, left: 0),
                              //child: Image.asset('android/Images/3.png'
                              //),
                            ),
                          ),
                          InkWell(
                            /* onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return  ProfileScreen();
                                      }
                                  )
                              );
                            },
            */
                            child: Container(
                              margin: const EdgeInsets.only(top: 0, left: 0),
                              /*child: Image.asset('android/Images/4.png'
                              ),*/
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return  UpcomingAndPastAppointments(ProfileType: 'VETATHOME',);
                                      }
                                  )
                              );

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top:30),
                              child: Container(
                                width: 300,
                                height: 150,
                                margin: const EdgeInsets.only(top: 0, left: 0),
                                child: Image.asset(
                                  'android/Images/app.png',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 20,
                          ),



                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return  VHomeTimeLists();
                                      }
                                  )
                              );

                            },
                            child: Container(
                              width: 300,
                              height: 150,
                              margin: const EdgeInsets.only(top: 0, left: 0),
                              child: Image.asset(
                                'android/Images/srv.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),




                        ],
                      ),

                    ),



                  ]
                  else if(status == "UnApproved")...[
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
                                return  RegisterationScreenVetAtHome();
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

