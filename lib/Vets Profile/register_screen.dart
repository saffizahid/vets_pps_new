import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../home_screen.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({Key? key}) : super(key: key);

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController ClinicController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController yourselfController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController LiceanceController = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController SpecializationController = TextEditingController();
  TextEditingController QualificationController = TextEditingController();

  String dropdownValue="Mr.";
  String imageLink='';
  List<String> list=["Mr.","Dr.","Mrs.","Sr."];
  int _currentValue = 3;
  String startTime = 'Opening Time';
  String endTime = 'Closing Time';

  void showTimePicker() {
    showDialog(

        context: context,
        builder: (_) => FromToTimePicker(
          headerText: "Clinic Timmings",
          dayText: "AM",
          nightText: "PM",
          onTab: (from, to) {
            print('from $from to $to');
            setState(() {
              startTime = from.hour.toString();
              endTime = to.hour.toString();

            });
          },
        ));
  }

  Future ProfileCreationF() async {

    final User? currentUser = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore.instance.collection("vets").doc(currentUser?.uid).set({
      "uid": currentUser?.uid,
      'name': firstNameController.text,
      //'last name': lastNameController.text,
      'year': _currentValue.toString(),
      'subtitle': subtitleController.text,//dropdownValue,
      'specialization': SpecializationController.text,
      'qualification': QualificationController.text,//dropdownValue,
      //dropdownValue,
      'phone number': phoneNumberController.text,
      'email': currentUser?.email,
      'cnic': cnicController.text,
      'ClinicName': ClinicController.text,
      'location': locationController.text,
      'VetLiceance': LiceanceController.text,
      'start time': startTime,
      'end time': endTime,
      'description': yourselfController.text,
      'profileImg': imageLink,
      'price': pricecontroller.text,
      'ProfileStatus': "UnApproved"
    },
    );
  }

    @override
  Widget build(BuildContext context) {

      double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
     // final _formKey = GlobalKey<FormState>();

      return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("VETS",style: TextStyle(color: Color.fromRGBO(
              214, 217, 220, 1.0), fontSize: 15),),

          centerTitle: true,
          backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
          elevation: 0,
          leading: GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)
                      {
                        return  HomePage();
                      }
                  )
              );
            },
            child: Icon(
              Icons.arrow_back_sharp,  // add custom icons also
            ),

          ),
        ),
        body: SingleChildScrollView(

          child: Container(
            height: height,
            child: ListView(
              padding: EdgeInsets.only(top: height*0.02,left: width*0.05,right: width*0.05),
              children: [
                ///////////////////////////////////////////////////////////Profile image and adding image from gallery/////////////////////////////////////////////////////////////////////////////////////////////////
                InkWell(
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                if(image != null){
                  File file = File(image.path);
                  print("file path is ${file.path}");
                  String fileName = file.path.split("/").last;
                  Reference firebaseStorageRef =
                  FirebaseStorage.instance.ref().child('uploads/$fileName');
                  TaskSnapshot uploadTask = await firebaseStorageRef.putFile(file);
                  // TaskSnapshot taskSnapshot =  uploadTask.snapshot;
                  uploadTask.ref.getDownloadURL().then(
                          (value){
                            setState(() {
                              imageLink=value;
                            });
                      });
                }
                  },
                  child: Container(
                    height: height * 0.2,
                    decoration: BoxDecoration(
                     // color: Color.fromRGBO(26, 59, 106, 1.0),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                    imageLink!=""?imageLink:"https://www.iconpacks.net/icons/2/free-user-camera-icon-3355-thumb.png"),
                              )
                  ),
                ),
                ),
                ///////////////////////////////////////////////////////////First Name Field /////////////////////////////////////////////////////////////////////////////////////////////////

                Container(
                  child: Form(
                      //key: _formKey,
                      child: Column(
                    children: [
                      SizedBox(height: height*0.03,),
                      TextFormField(
                        controller: firstNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'Enter Your Full Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },

                      ),

                      SizedBox(height: height*0.02,),
                      TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.call),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'Phone Number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Phone Number';
                          }
                          else if (value.length < 5) {
                            return 'Phone Number is Too short';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: height*0.02,),
                      TextFormField(
                        controller: cnicController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'C.N.I.C',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter CNIC';
                          }
                          else if (value.length < 6) {
                            return 'CNIC is Too short';
                          }
                          return null;
                        },
                      ),

                      ///////////////////////////////////////////////////////////Describe Field /////////////////////////////////////////////////////////////////////////////////////////////////
                      SizedBox(height: height*0.02,),
                      const Center(child: Text("Vet Information",style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 19,),)),
                      SizedBox(height: height*0.02,),
                      TextFormField(
                        controller: QualificationController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'Enter Your Qualification',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },

                      ),
                      SizedBox(height: height*0.02,),
                      TextFormField(
                        controller: SpecializationController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'Enter Your Specialization',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },

                      ),

                      Row(
                        children: [
                          Text("Experience(Years):",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color: Color.fromRGBO(26, 59, 106, 1.0)),),
                          SizedBox(width: width*0.05,),

                          Expanded(
                            child: NumberPicker(
                              itemWidth: width*0.1,
                              value: _currentValue,
                              minValue: 0,
                              axis: Axis.horizontal,
                              maxValue: 100,
                              onChanged: (value) => setState(() => _currentValue = value),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height*0.02,),
                      TextFormField(
                        controller: LiceanceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'Vet Licence Number ',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },

                      ),
                      SizedBox(height: height*0.02,),
                      SizedBox(
                        height: height*0.2,
                        child: TextFormField(
                          controller: yourselfController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.details),
                            contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                            labelText: 'Write About YourSelf.',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },

                        ),
                      ),

                      ///////////////////////////////////////////////////////////Submit button /////////////////////////////////////////////////////////////////////////////////////////////////



                      SizedBox(height: height*0.02,),
                      const Center(child: Text("Clinic Information",style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 19,),)),

                      ///////////////////////////////////////////////////////////Subtitle drop down /////////////////////////////////////////////////////////////////////////////////////////////////
                      /* SizedBox(height:height*0.02,),
                  Row(
                    children: [
                      Text("Subtitle:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color: Colors.grey.shade700),),
                      SizedBox(width: width*0.05,),
                      Expanded(
                        child: DropdownButton<String>(
                          focusColor:Colors.white,
                          value: dropdownValue,
                          isExpanded: true,
                          //elevation: 5,
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor:Colors.black,
                          items: list.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style:TextStyle(color:Colors.black),),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  ///////////////////////////////////////////////////////////Location text Field /////////////////////////////////////////////////////////////////////////////////////////////////
 */ SizedBox(height: height*0.02,),
                      TextFormField(
                        controller: ClinicController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.pets),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'Enter Your Clinic Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },

                      ),
                      SizedBox(height: height*0.02,),
                      const Center(child: Text("Vet Information",style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 19,),)),
                      SizedBox(height: height*0.02,),
                      TextFormField(
                        controller: subtitleController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'Enter Your Job Description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },

                      ),

                      SizedBox(height: height*0.02,),
                      TextFormField(
                        controller: locationController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'Location',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required';
                          }
                        },

                      ),
                      ///////////////////////////////////////////////////////////Phone Number Field /////////////////////////////////////////////////////////////////////////////////////////////////
                      SizedBox(height:height*0.02,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(" Clinic Timings:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Color.fromRGBO(26, 59, 106, 1.0)),),
                          TextButton(onPressed: () => showTimePicker(), child: Container(child: Text(startTime,style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 13,)))),
                          Text("To",style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 11,)),
                          TextButton( onPressed: () => showTimePicker(), child: Text(endTime, style: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),fontWeight: FontWeight.bold,fontSize: 13,))),
                        ],
                      ),
                      SizedBox(height: height*0.02,),
                      TextFormField(
                        controller: pricecontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.price_check),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          labelText: 'Enter Your Checkup Charges',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },

                      ),
                      SizedBox(height: height*0.02,),

                    ],
                  )),
                ),

                MaterialButton(

                  onPressed: () {
                    print("donenew");
                    ProfileCreationF();
                    //Add a new item
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)
                            {
                              return  HomePage();
                            }
                        )
                    );

                    print("done");

                    /*if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing')),
                      );

                    }*/
                  },
                  color: Color.fromRGBO(25, 58, 106, 5),
                  child: Text("Create Profile",style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
