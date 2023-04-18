import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'Regiatration/Edit_Clinic_Vet.dart';



class UserdetailsPage extends StatefulWidget {
  const UserdetailsPage({Key? key}) : super(key: key);

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
        backgroundColor: Color.fromRGBO(25, 58, 106, 100),
        appBar: AppBar(backgroundColor: Color.fromRGBO(25, 58, 106, 100),
            elevation: 10,
            actions:[GestureDetector(
              child: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditRegisterationScreen()),
                );
              },
            )] ),
        body:StreamBuilder(
            stream: FirebaseFirestore.instance.collection('vets').doc(user.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {return  CircularProgressIndicator();}
              var document = snapshot.data;
              var ProfileImg = document!["profileImg"];
              var year = document['year'];
              return new Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Color.fromRGBO(26, 59, 106, 1.0),
                  ),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      children: [
                        Container(
                          height: height*0.35,
                          decoration:  BoxDecoration(
                              color: Color.fromRGBO(25, 58, 106, 100),
                              image: DecorationImage(
                                image:NetworkImage(document['profileImg']),)
                          ),
                        ),
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft:
                              Radius.circular(15.0),
                                  topRight: Radius.circular(15.0)),color: Colors.white),
                          child:ListView(children: [
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.04),
                              child: Text(document['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),),
                            Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),
                            const Center(child: Text("PERSONAL INFORMATION",style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 14,),)),
                            Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: Text("Email:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text("${document['email']}"),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: Text("Phone Number:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text("${document['phone number']}"),),
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.01),
                              child: Text("Cnic:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.01),
                              child: Text("${document['cnic']}"),),
                            Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),
                            const Center(child: Text("VET INFORMATION",style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 14,),)),
                            Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: Text("Vet Liceance:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text("${document['VetLiceance']}"),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: Text("Experience:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text("${document['year']} years of Experience"),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.02),
                              child: Text("Qualification:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.01),
                              child: Text(document['qualification']),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.01),
                              child: Text("Specialization:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.01, bottom: height*0.01),
                              child: Text(document['specialization']),),
                            Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.01),
                              child: Text("About:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,right:width*0.02, top: height*0.01, bottom: height*0.01),
                              child: Text('${document['description']}',style: TextStyle(),textAlign: TextAlign.justify,
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









