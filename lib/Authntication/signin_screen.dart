import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Forgot_pass.dart';
import 'sign.up_screen.dart';
class MyAppNew extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const MyAppNew({Key? key,required this.showRegisterPage}) : super(key: key);

  @override
  State<MyAppNew> createState() => _MyAppNewState();
}

class _MyAppNewState extends State<MyAppNew> {
  bool _isHidden = true;

  final _emailController= TextEditingController();
  final _passwordController= TextEditingController();


  Future signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
        Center(child: CircularProgressIndicator());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
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
  Future<void> dispose() async {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    void _togglePasswordView() {
      setState(() {
        _isHidden = !_isHidden;
      });
    }

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text('SIGN IN'),
        centerTitle: true,

      ),

      body: Container(        decoration: BoxDecoration(color: Colors.white),
        width:w,
        height:h,

        child: SingleChildScrollView(
          child: Column(

            children: [

              Container(
                margin: const EdgeInsets.only(top: 30, left: 5),
                child: Image.asset('android/Images/logo.png'
                ),
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
              Container(
                  padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
                  child: TextField(
                      obscureText: _isHidden,
                      controller: _passwordController,
                      decoration:  InputDecoration(
                        prefixIcon: Icon(Icons.key_sharp, color:Color.fromRGBO(26, 59, 106, 1.0) ,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
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
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)
                          {
                            return ForgotPasswordPage();
                          }
                      )
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 3,left: 203),
                  child: Text('Forgot Password?',
                      style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,

                      )
                  ),
                ),
              ),
              GestureDetector(
                onTap: signIn,
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
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                          )

                      ),
                    ),

                  ),
                ),

              ),

              GestureDetector(
                onTap: widget.showRegisterPage,
                child: Container(
                    padding: const EdgeInsets.only(top: 40,left: 0),
                    child:
                    RichText(
                      text: TextSpan(
                          text: "Dont\'t Have an account?",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14
                          ),
                          children: [
                            TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,

                                )
                            )
                          ]
                      ),
                    )
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
