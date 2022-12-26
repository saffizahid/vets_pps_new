import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
class Signup extends StatefulWidget {
  final VoidCallback showloginpage;
  const Signup({Key? key,required this.showloginpage}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isHidden = true;
//CONTROLERS FOR INPUTS
  final _emailController= TextEditingController();
  final _passwordController= TextEditingController();
  final _confirmpasswordController= TextEditingController();
  //Controllers For User Profile Input
  final user_firstname = TextEditingController();
  final user_lastname = TextEditingController();
  final user_email = TextEditingController();
  final user_phnumber = TextEditingController();
  final user_CNIC = TextEditingController();



  @override


  Future<void> dispose() async {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    user_firstname.dispose();
    user_lastname.dispose();
    user_email.dispose();
    user_phnumber.dispose();
    user_CNIC.dispose();

    super.dispose();
  }

  /*Future signUp() async{
   if(passwordConfirmed())
     {
       try {
         final User? user =
             (await FirebaseAuth.instance.signInWithEmailAndPassword(
               email: _emailController.text,
               password: _passwordController.text,
             ))
                 .user;
         FirebaseFirestore.instance.collection('users').doc().set({
           'uid': user!.uid,
           'firstname': user_firstname.text,
           'lastname': user_lastname.text,
           'email': _emailController.text,
           'phnumber': user_phnumber.text,
           'CNIC': user_CNIC.text
         });
         print("Created");
       } catch (e) {
         print(e.toString());
       }

       *//*await FirebaseAuth.instance.createUserWithEmailAndPassword(
           email: _emailController.text.trim(),
           password: _passwordController.text.trim());
*//*
      *//* var response = await FirebaseCrud.addUser(
           firstname: user_firstname.text,
           lastname: user_lastname.text,
           email: _emailController.text,
           phnumber: user_phnumber.text,
           CNIC: user_CNIC.text
       );*//*
     }
   *//*storeNewUser(user) async {
     var firebaseUser = await FirebaseAuth.instance.currentUser();
     FirebaseFirestore.instance
         .collection('users')
         .doc(firebaseUser.uid)
         .set({'email': user.email, 'uid': user.uid})
         .then((value) {})
         .catchError((e) {
       print(e);
     });
   }
*//*
  }
*/
//BACKEND CODE FOR SIGNUP AND USER PROFILE CREATION
  Future<void> signUp() async {
    final User? currentUser = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)).user;
    FirebaseFirestore.instance.collection("login").doc(currentUser?.uid).set({
      "uid": currentUser?.uid,
      "Profile": "Vet"
/*
      'firstname': user_firstname.text,
      'lastname': user_lastname.text,
      'email': _emailController.text,
      'phnumber': user_phnumber.text,
      'CNIC': user_CNIC.text,
      'profileImg': "https://cdn-icons-png.flaticon.com/512/21/21104.png",
*/
    },
    );
  }
// CONFIRMED PASSWORD CODE
  bool passwordConfirmed(){
    if(_passwordController.text.trim() == _confirmpasswordController.text.trim())
    {
      return true;
    }
    else{
      return false;
    }
  }
  @override
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("SIGN UP",style: TextStyle(color: Color.fromRGBO(
            214, 217, 220, 1.0), fontSize: 15),),

        centerTitle: true,
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,
      ),
      // floatingActionButton: FloatingActionButton(onPressed: (){},
      // child: Icon(Icons.access_time),),

      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        width:MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,

        child:

        SingleChildScrollView(
          child: Column(

            children: [
              Container(
                margin: const EdgeInsets.only(top: 0, left: 5),
                child: Image.asset('android/Images/logo.png'
                ),
              ),


              Container(
                height: 100,
                width: 100,
                //decoration: BoxDecoration(image: DecorationImage(image: FileImage(_image,),fit: BoxFit.contain)),
              ),

              Container(
                  padding: const EdgeInsets.only(top: 0,left: 20,right: 20),

                  child: TextField(
                      controller: _emailController,
                      decoration:  InputDecoration(
                        prefixIcon: Icon(Icons.email_sharp, color:Color.fromRGBO(26, 59, 106, 1.0) ,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelText: 'Email ID',
                      )
                  )),
              Container(
                  padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
                  child: TextField(
                      controller: _passwordController,
                      obscureText:  _isHidden,
                      decoration:  InputDecoration(
                        prefixIcon: Icon(Icons.key_sharp, color:Color.fromRGBO(26, 59, 106, 1.0) ,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: 'Password',
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      )
                  )),
              Container(
                  padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
                  child: TextField(
                      controller: _confirmpasswordController,
                      obscureText:  _isHidden,
                      decoration:  InputDecoration(
                        prefixIcon: Icon(Icons.key_sharp, color:Color.fromRGBO(26, 59, 106, 1.0) ,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: 'Confirm Password',
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      )
                  )),


              GestureDetector(
                onTap: signUp,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(26, 59, 106, 1.0),
                        borderRadius: BorderRadius.circular(20)),
                    width:MediaQuery.of(context).size.width*0.9,
                    child: Center(
                      child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                          )

                      ),
                    ),

                  ),
                ),

              ),

              GestureDetector(
                onTap: widget.showloginpage,
                child: Container(
                    padding: const EdgeInsets.only(top: 10,left: 0),
                    child:
                    RichText(
                      text: TextSpan(
                          text: "Already Have An Account? ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14
                          ),
                          children: [
                            TextSpan(
                                text: "Sign In",
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,

                                )
                            )
                          ]
                      ),
                    )
                ),
              ),
              SizedBox(height: 55.0),
            ],
          ),
        ),
      ),
    );
  }
}
