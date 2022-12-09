import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Signup extends StatefulWidget {
  final VoidCallback showloginpage;
  const Signup({Key? key,required this.showloginpage}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isHidden = true;

  final _emailController= TextEditingController();
  final _passwordController= TextEditingController();

  @override
  Future<void> dispose() async {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signUp() async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());

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
          title: Text('SIGN UP'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0
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
                      controller: _passwordController,
                      obscureText:  _isHidden,
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
                    padding: const EdgeInsets.only(top: 40,left: 0),
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

            ],
          ),
        ),
      ),
    );
  }
}
