import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';



class UserdetailsPage extends StatefulWidget {
  const UserdetailsPage({Key? key}) : super(key: key);

  @override
  State<UserdetailsPage> createState() => _UserdetailsPageState();
}

class _UserdetailsPageState extends State<UserdetailsPage> {
/*

  DocumentSnapshot variable = await FirebaseFirestore.instance.collection('COLLECTION NAME').doc('DOCUMENT ID').get();


*/
  final user= FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(25, 58, 106, 100),
        appBar: AppBar(backgroundColor: Color.fromRGBO(25, 58, 106, 100),
            elevation: 10,
            actions:[Icon(Icons.edit),] ),
        body:StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('vets')
                .doc(user.uid) //ID OF DOCUMENT
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return  CircularProgressIndicator();
              }
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
                            /*                ListTile(
                        title:
                        subtitle: Text('${data['subtitle']}'),
      ),*/
                            /*  trailing: RatingBar.builder(
                          initialRating: 4,
                          minRating: 1,
                          itemSize: 20,
                          glow: false,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      */
                            /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularPercentIndicator(
                            radius: 40.0,
                            footer: Text("Wait Time"),
                            lineWidth: 5.0,
                            percent: 0.25,
                            center:  Text("25"),
                            progressColor: Color.fromRGBO(25, 58, 106, 5),
                          ),
                          CircularPercentIndicator(
                            radius: 40.0,
                            footer: Text("Experience"),
                            lineWidth: 5.0,
                            percent: 0.99,
                            center:  Text("16 yr"),
                            progressColor: Color.fromRGBO(25, 58, 106, 5),
                          ),
                          CircularPercentIndicator(
                            radius: 40.0,
                            footer: Text("Satisfaction"),
                            lineWidth: 5.0,
                            percent: 0.98,
                            center:  Text("98%"),
                            progressColor: Color.fromRGBO(25, 58, 106, 5),
                          )
                        ],),

                     */
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.04),
                              child: Text(document['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),),
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.0,),
                              child: Text(document['subtitle'],style: TextStyle(color: Colors.black54,fontSize: 16),),),
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
                              child: Text("${document['VetLiceance']} years of Experience"),),

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
                            const Center(child: Text("VET INFORMATION",style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 14,),)),
                            Divider(
                                height: 20,
                                thickness: 3,
                                indent: 40,
                                endIndent: 40,
                                color: Color.fromRGBO(26, 59, 106, 1.0)
                            ),
                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.01),
                              child: Text("Clinic Name:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text(document['ClinicName']),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.01),
                              child: Text("Location:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.02, bottom: height*0.0),
                              child: Text(document['location']),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.01),
                              child: Text("Timing:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.01),
                              child: Text("Monday - Friday"),),
                            Padding(padding: EdgeInsets.only(left: width*0.06,top: height*0.01, bottom: height*0.0),
                              child: Text("${document['start time']} to ${document['end time']}"),),

                            Padding(padding: EdgeInsets.only(left: width*0.01,top: height*0.01),
                              child: Text("Charges:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.01, bottom: height*0.0),
                              child: Text("Rs: ${document['price']} "),),

                            Padding(padding: EdgeInsets.only(left: width*0.02,top: height*0.01),
                              child: Text("About:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                            Padding(padding: EdgeInsets.only(left: width*0.02,right:width*0.02, top: height*0.01, bottom: height*0.01),
                              child: Text('${document['description']}',style: TextStyle(),textAlign: TextAlign.justify,
                              ),),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                /*MaterialButton(onPressed: (){},
                            color: Colors.grey.shade300,
                            child: Icon(Icons.chat,color: Colors.white,),),
                          MaterialButton(onPressed: (){},
                            color: Colors.grey.shade300,
                            child: Icon(Icons.call,color: Colors.white,),),
                         *//* MaterialButton(onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context)
                            {
                              return  HomePage(itemId: itemId,);
                            }
                            ));
                          },
                            color: Color.fromRGBO(25, 58, 106, 5),
                            child: Text("Create Appointment",style: TextStyle(color: Colors.white),
                            ),
                          ),*/
                              ],
                            ),
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









