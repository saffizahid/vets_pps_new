import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    super.dispose();
  }
Future passwordReset() async{
  try{
    await FirebaseAuth.instance.
    sendPasswordResetEmail(email: _emailController.text.trimLeft());
    showDialog(context: context, builder: (context)
    {
      return AlertDialog(
        title:Text("Password Reset" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        content:Text('Password Reset Link Sent To Your Email' ,style: (TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Colors.white)),),
      );
    },);

  } on FirebaseAuthException catch(e){
    print(e);
    showDialog(context: context, builder: (context)
    {
return AlertDialog(
  title:Text("Note" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
  elevation: 80,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),

  content:Text(e.message.toString(),style: (TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Colors.white)),),
);
    });
  }
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text('Forgot Password'),
        centerTitle: true,

      ),

        body: Container(
        decoration: BoxDecoration(color: Colors.white),
        width:w,
        height:h,

        child: SingleChildScrollView(
        child: Column(

        children: [

        Container(
        margin: const EdgeInsets.only(top: 30, left: 20),
        child: Image.asset('android/Images/logo.png'
        ),
        ),
          Container(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
            child: Text('Enter Your Email And We Will Send You Password Reset Link'),

          ),
            Container(
        padding: const EdgeInsets.only(top: 20,left: 20,right: 20),

        child: TextField(
        controller: _emailController,
    decoration:  InputDecoration(
    prefixIcon: Icon(Icons.email_sharp, color:Color.fromRGBO(26, 59, 106, 1.0) ,),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    labelText: 'Email ID',
    )
    )),


          GestureDetector(
            onTap: passwordReset,
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
                      "Reset Password",
                      style: TextStyle(
                        color: Colors.white,
                      )

                  ),
                ),

              ),
            ),

          ),









        ],
        ),),

    ),










    ) ;
  }
}
