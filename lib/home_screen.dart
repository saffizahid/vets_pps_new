import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vets_pps_new/navbar.dart';
import 'Doctor List/add_item.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user= FirebaseAuth.instance.currentUser!;


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
      body: Container(
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
          )
      ),
    );
  }
}

