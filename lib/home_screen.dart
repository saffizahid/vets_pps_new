import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vets_pps_new/navbar.dart';
import 'Doctor List/add_item.dart';
import 'Vets Profile/register_screen.dart';
import 'main.dart';

/*
class Crud {
  final user= FirebaseAuth.instance.currentUser!;
  Future<QuerySnapshot> getData() async {
    return await FirebaseFirestore.instance
        .collection('vet')
        .where("uid", isEqualTo: user!.uid)
        .get();
  }
}
*/


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user= FirebaseAuth.instance.currentUser!;
/*

  final crud = Crud();
*/

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Hi, '+ user.email!,style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0), fontSize: 15),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      // floatingActionButton: FloatingActionButton(onPressed: (){},
      //child: Icon(Icons.access_time),),
      body:
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("vet")
        .doc(user.uid)
        .snapshots(),
    builder: (context, sasapshot) {
      if (sasapshot.data!.exists) {
        return Container(
          width: w,
          height: h,
          decoration: BoxDecoration(color: Colors.white),

          child:
          Column(
            children: [
              //Text('Signed in As '+ user.email!,style:TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0)),),
              //MaterialButton(onPressed: (){
              //FirebaseAuth.instance.signOut();
              //},
              //color: Color.fromRGBO(26, 59, 106, 1.0),
              //child: Text('Signed Out ',style:TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0)),),)

              InkWell(

                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 0),
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
                  margin: const EdgeInsets.only(top: 10, left: 0),
                  /*child: Image.asset('android/Images/4.png'
                  ),*/
                ),
              ),


              InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)
                          {
                            return  AddItem();
                          }
                      )
                  );
                },

                child: Container(

                  height: 50,
                  width: 200,
                  color: Color.fromRGBO(26, 59, 106, 0.9294117647058824),
                  child: Center(child: Text("Add Profile")),

                ),
              ),


            ],
          ),
        );
//return logic if the document exists based on uid
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

