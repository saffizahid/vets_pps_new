import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  final VoidCallback showloginpage;

  const Signup({Key? key, required this.showloginpage}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isHidden = true;
  //CONTROLERS FOR INPUTS
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _profileType = 'vetathome';

  @override
  Future<void> dispose() async {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();

    super.dispose();
  }

  //BACKEND CODE FOR SIGNUP AND USER PROFILE CREATION
  Future<void> signUp() async {
    if (_formKey.currentState?.validate() == true) {
      final User? currentUser =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
              .user;
      FirebaseFirestore.instance.collection("login").doc(currentUser?.uid).set({
        "uid": currentUser?.uid,
        "Profile": _profileType,
      });
      FirebaseFirestore.instance
          .collection("vet_wallet")
          .doc(currentUser?.uid)
          .set({
        "wallet": 0,
      });
    }
  }

  // CONFIRMED PASSWORD CODE
  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
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
        title: Text(
          "SIGN UP",
          style: TextStyle(
              color: Color.fromRGBO(214, 217, 220, 1.0), fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0, left: 5),
                  child: Image.asset('android/Images/logo.png'),
                ),
                Container(
                  height: 60,
                  width: 100,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_sharp,
                          color: Color.fromRGBO(26, 59, 106, 1.0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: 'Email ID',
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please enter an email address';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value!)) {
                        return 'Please enter a valid email address';
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key_sharp,
                          color: Color.fromRGBO(26, 59, 106, 1.0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Password',
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please enter a password';
                      } else if (value!.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: TextFormField(
                    controller: _confirmpasswordController,
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key_sharp,
                          color: Color.fromRGBO(26, 59, 106, 1.0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Confirm Password',
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please confirm your password';
                      } else if (value != _passwordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(
                            'VET AT HOME',
                            style: TextStyle(
                                color: Color.fromRGBO(26, 59, 106, 1.0),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          value: 'VETATHOME',
                          groupValue: _profileType,
                          onChanged: (value) {
                            setState(() {
                              _profileType = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(
                            'CLINIC',
                            style: TextStyle(
                                color: Color.fromRGBO(26, 59, 106, 1.0),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          value: 'Clinic',
                          groupValue: _profileType,
                          onChanged: (value) {
                            setState(() {
                              _profileType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(
                          child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.showloginpage,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, left: 0),
                    child: RichText(
                      text: TextSpan(
                        text: "Already Have An Account? ",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              color: Colors.red[900],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 55.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
