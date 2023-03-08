/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

import 'common/header_widget.dart';
import 'common/theme_helper.dart';

class AddItem extends StatefulWidget {
   AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final user= FirebaseAuth.instance.currentUser!;

  TextEditingController _controllerProfileImage=TextEditingController();
  TextEditingController _controllerFirstName=TextEditingController();
  TextEditingController _controllerLastName=TextEditingController();
  TextEditingController _controllerSubtitle=TextEditingController();
  TextEditingController _controllerExperience=TextEditingController();
  TextEditingController _controllerPhoneNum=TextEditingController();
  TextEditingController _controllerEmail=TextEditingController();
  TextEditingController _controllerLicesce=TextEditingController();
  TextEditingController _controllerCNIC=TextEditingController();
  TextEditingController _controllerWriteAboutYourself=TextEditingController();
  TextEditingController _controllerTimming=TextEditingController();
  TextEditingController _controllerEducation=TextEditingController();
  TextEditingController _controllerPrice=TextEditingController();

  GlobalKey<FormState> key=GlobalKey();
 CollectionReference _reference=FirebaseFirestore.instance.collection('vets');
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
    return  HomePageClinics();
    }
    )
    );
    },),
      ),
      body:
      SingleChildScrollView(

        child: Container(
          color: Color.fromRGBO(64, 65, 66, 0.12156862745098039),

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: key,
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  GestureDetector(
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                width: 5, color: Colors.white),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                                offset: const Offset(5, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey.shade300,
                            size: 80.0,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                          child: Icon(
                            Icons.add_circle,
                            color: Colors.grey.shade700,
                            size: 25.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _controllerProfileImage,
                    decoration: InputDecoration(
                        hintText: 'Enter your ProfileImg'
                    ),
                    validator: (String? value){

                      if(value==null || value.isEmpty)
                      {
                        return 'Please enter the ProfileImage';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: _controllerFirstName,
                    decoration: InputDecoration(
                        hintText: 'Enter Your Name'
                    ),
                    validator: (String? value){

                      if(value==null || value.isEmpty)
                      {
                        return 'Please enter your name';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _controllerPhoneNum,
                    decoration: InputDecoration(

                        hintText: 'Enter your PhoneNumber'
                    ),
                    validator: (String? value){

                      if(value==null || value.isEmpty)
                      {
                        return 'Please enter the Years';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: _controllerSubtitle,
                    decoration: InputDecoration(
                        hintText: 'Enter Subtitle '
                    ),
                    validator: (String? value){

                      if(value==null || value.isEmpty)
                      {
                        return 'Please enter the item quantity';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 30,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _controllerExperience,
                    decoration: InputDecoration(

                        hintText: 'Enter your years   '
                    ),
                    validator: (String? value){

                      if(value==null || value.isEmpty)
                      {
                        return 'Please enter the Years';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: _controllerPrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Enter your Price'
                    ),
                    validator: (String? value){

                      if(value==null || value.isEmpty)
                      {
                        return 'Please enter the Price';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                      maxLines: 5,
                      minLines: 3,
                      controller: _controllerWriteAboutYourself,
                    decoration: InputDecoration(
                        hintText: 'Write About Yourself?'

                    ),
                    validator: (String? value){

                      if(value==null || value.isEmpty)
                      {
                        return 'Write About Yourself?';
                      }

                      return null;
                    }

                  ),




                  InkWell(

                    child: ElevatedButton(onPressed: () async{

                      if(key.currentState!.validate())
                      {
                        String itemName=_controllerFirstName.text;
                        String itemQuantity=_controllerLastName.text;

//Create a Map of data
                        Map<String,String> dataToSend={
                          'name':itemName,
                          'subtitle':itemQuantity,
                          'year':_controllerExperience.text,
                          'profileImg':_controllerProfileImage.text,
                          'price':_controllerPrice.text,
                          'phnum':_controllerPhoneNum.text,

                          'email':user.email!,
                          'description':_controllerWriteAboutYourself.text,

                        };

//Add a new item
                        _reference.add(dataToSend);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context)
                                {
                                  return  HomePageClinics();
                                }
                            )
                        );

                      }

                    }, style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(26, 59, 106, 0.8745098039215686),
                      ),
                    ),child: Text('Submit')),
                  )








                ],
              ),
            ),
          ),
        ),
      ),



    );
  }
}
*/
