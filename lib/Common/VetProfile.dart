import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../CLINICVETS/home_screen_clinics.dart';
import '../VetAtHome/home_screen_vetathome.dart';
import 'Edit_Vet_Profile.dart';



class UserdetailsPage extends StatefulWidget {
  String ProfileType;
   UserdetailsPage({Key? key,required this.ProfileType}) : super(key: key);

  @override
  State<UserdetailsPage> createState() => _UserdetailsPageState();
}

class _UserdetailsPageState extends State<UserdetailsPage> {

  final user= FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromRGBO(25, 58, 106, 100),
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(25, 58, 106, 100),
            elevation: 10,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
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
            ),
            actions:[
              GestureDetector(
                child: const Icon(Icons.edit),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  EditRegisterationScreen(ProfileType: widget.ProfileType,)),
                  );
                },
              )
            ]
        ),
        body:StreamBuilder(
            stream: FirebaseFirestore.instance.collection('vets').doc(user.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {return  const CircularProgressIndicator();}
              var document = snapshot.data;
              var ProfileImg = document!["profileImg"];
              Timestamp timestamp = document['LicenseIssueDate'];
              Timestamp timestamps = document['LicenseExpiryDate'];

// Convert the timestamp to a DateTime object
              DateTime dateTime = timestamp.toDate();
              DateTime dateTimes = timestamps.toDate();

// Format the DateTime object as a string in DD-MM-YYYY format
              String IssueDate = DateFormat('dd-MM-yyyy').format(dateTime);
              String ExpiryDate = DateFormat('dd-MM-yyyy').format(dateTimes);


              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: const Color.fromRGBO(26, 59, 106, 1.0),
                  ),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      children: [
                        Container(
                          height: height*0.35,
                          decoration:  BoxDecoration(
                              color: const Color.fromRGBO(25, 58, 106, 100),
                              image: DecorationImage(
                                image:NetworkImage(document['profileImg']),)
                          ),
                        ),
                        Expanded(child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft:
                              Radius.circular(15.0),
                                  topRight: Radius.circular(15.0)),color: Colors.white),
                          child:ListView(children: [
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.04),
                              child: Text(document['name'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),),
                            const Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),
                            const Center(child: Text("PERSONAL INFORMATION",style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 14,),)),
                            const Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: const Text("Email:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text("${document['email']}"),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: const Text("Phone Number:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text("${document['phone number']}"),),
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.01),
                              child: const Text("CNIC:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.01),
                              child: Text("${document['cnic']}"),),
                            const Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),
                            const Center(child: Text("VET INFORMATION",style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 14,),)),
                            const Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),
                            Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Container(
                                height: height * 0.2,
                                width: width * 0.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: NetworkImage(
                                        "${document['licenseImageLink']}"
                                      ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: const Text("PVMC Licence No:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text("${document['VetLiceance']}"),),
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: const Text("PVMC Licence Issue Date:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text(IssueDate),),
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: const Text("PVMC Licence Expiry Date:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text(ExpiryDate),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: const Text("Experience:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text("${document['year']} years of Experience"),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: const Text("Qualification:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.01),
                              child: Text(document['qualification']),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.01),
                              child: const Text("Specialization:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.01, bottom: height*0.01),
                              child: Text(document['specialization']),),
                            const Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.01),
                              child: const Text("About:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,right:width*0.02, top: height*0.01, bottom: height*0.01),
                              child: Text('${document['description']}',style: const TextStyle(),textAlign: TextAlign.justify,
                              ),),

                          ],
                          ),
                        )
                        )
                      ],
                    ),
                  )
                ],
              );



            }
        )

    );
  }
}









