import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'VetProfile.dart';
import '../CLINICVETS/home_screen_clinics.dart';

class EditRegisterationScreen extends StatefulWidget {
  String ProfileType;
   EditRegisterationScreen({Key? key,required this.ProfileType}) : super(key: key);

  @override
  State<EditRegisterationScreen> createState() => _EditRegisterationScreenState();
}

class _EditRegisterationScreenState extends State<EditRegisterationScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController yourselfController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController LiceanceController = TextEditingController();
  TextEditingController SpecializationController = TextEditingController();
  TextEditingController QualificationController = TextEditingController();

  int _currentValue = 3;
  String imageLink='';
  String licenseImageLink = '';
  DateTime? _issueDate;
  DateTime? _expiryDate;

  Future<void> _updateProfile() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection("vets")
            .doc(currentUser.uid)
            .update({
          'name': firstNameController.text,
          'year': _currentValue.toString(),
          'specialization': SpecializationController.text,
          'qualification': QualificationController.text,
          'phone number': phoneNumberController.text,
          'email': currentUser.email,
          'cnic': cnicController.text,
          'VetLiceance': LiceanceController.text,
          'description': yourselfController.text,
          'profileImg': imageLink,
          'licenseImageLink': licenseImageLink,

          'LicenseIssueDate': _issueDate != null
              ? Timestamp.fromDate(_issueDate!)
              : null,
          'LicenseExpiryDate': _expiryDate != null
              ? Timestamp.fromDate(_expiryDate!)
              : null,

        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile!')));
      }
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    // Fetch the current user's profile data and populate the form fields
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection("vets")
          .doc(currentUser.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            firstNameController.text = snapshot.data()?['name'] ?? '';
            _currentValue = int.tryParse(snapshot.data()?['year'] ?? '') ?? 3;
            SpecializationController.text =
                snapshot.data()?['specialization'] ?? '';
            QualificationController.text =
                snapshot.data()?['qualification'] ?? '';
            phoneNumberController.text =
                snapshot.data()?['phone number'] ?? '';
            cnicController.text = snapshot.data()?['cnic'] ?? '';
            LiceanceController.text = snapshot.data()?['VetLiceance'] ?? '';
            yourselfController.text = snapshot.data()?['description'] ?? '';
            imageLink = snapshot.data()?['profileImg'] ?? '';
            licenseImageLink = snapshot.data()?['licenseImageLink'] ?? '';

            Timestamp? issueDate = snapshot.data()?['LicenseIssueDate'];
            _issueDate = issueDate?.toDate();
            Timestamp? expiryDate = snapshot.data()?['LicenseExpiryDate'];
            _expiryDate = expiryDate?.toDate();
          });
        }
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VETS",
          style: TextStyle(
              color: Color.fromRGBO(214, 217, 220, 1.0), fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserdetailsPage(ProfileType: widget.ProfileType,);
            }));
          },
          child: Icon(
            Icons.arrow_back_sharp, // add custom icons also
          ),
        ),
      ),
      body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(14),
            child: Form(
                key: _formKey,

                child: Column(
                  children: [
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

                    SizedBox(height: height*0.03,),
                    TextFormField(
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: 'Enter Your Full Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.call),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: 'Phone Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Phone Number';
                        } else if (value.length != 11 || !value.startsWith('03')) {
                          return 'Phone Number should be 11 digits long and start with 03';
                        }
                        return null;
                      },),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    TextFormField(
                      controller: cnicController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: 'C.N.I.C',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter CNIC';
                        } else if (value.length != 13) {
                          return 'CNIC should be 13 digits Long';
                        }
                        return null;
                      }, ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                     Center(
                        child: Text(
                          "Vet Information",
                          style: TextStyle(
                            color: Color.fromRGBO(26, 59, 106, 1.0),
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        )),
                    SizedBox(
                      height: height * 0.02,
                    ),

                    GestureDetector(
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          File file = File(image.path);
                          print("file path is ${file.path}");
                          String fileName = file.path.split("/").last;
                          Reference firebaseStorageRef = FirebaseStorage
                              .instance
                              .ref()
                              .child('license-uploads/$fileName');
                          TaskSnapshot uploadTask =
                          await firebaseStorageRef.putFile(file);
                          uploadTask.ref.getDownloadURL().then((value) {
                            setState(() {
                              licenseImageLink = value;
                            });
                          });
                        }
                      },
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          height: height * 0.2,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(
                                licenseImageLink != "NULL"
                                    ? licenseImageLink
                                    : "https://icon-library.com/images/id-icon/id-icon-15.jpg",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    TextFormField(
                      controller: LiceanceController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: 'PVMC Licence Number ',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'PVMC Licence Number is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final DateTime? selectedDate =
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2018),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _issueDate = selectedDate;
                                });
                              }
                            },
                            child: Container(
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _issueDate == null
                                      ? 'Issue Date'
                                      : DateFormat('yyyy-MM-dd')
                                      .format(_issueDate!),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.05),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final DateTime? selectedDate =
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2040),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _expiryDate = selectedDate;
                                });
                              }
                            },
                            child: Container(
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _expiryDate == null
                                      ? 'Expiry Date'
                                      : DateFormat('yyyy-MM-dd')
                                      .format(_expiryDate!),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    TextFormField(
                      controller: QualificationController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: 'Enter Your Qualification',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Qualification is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    TextFormField(
                      controller: SpecializationController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: 'Enter Your Specialization',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Specialization is required';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          "Experience(Years):",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Color.fromRGBO(26, 59, 106, 1.0)),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Expanded(
                          child: NumberPicker(
                            itemWidth: width * 0.1,
                            value: _currentValue,
                            minValue: 0,
                            axis: Axis.horizontal,
                            maxValue: 100,
                            onChanged: (value) =>
                                setState(() => _currentValue = value),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: yourselfController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.details),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 40.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        labelText: 'Write About Yourself.',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),

                  ],
                )),
          ),
          Padding(
            padding:  EdgeInsets.only(left: 8.0,right: 8.0,),
            child: GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _updateProfile();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UserdetailsPage(ProfileType: widget.ProfileType,);
                  }));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(25, 58, 106, 5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.07,
          ),

        ],
      )
        ,
      ),
    );
  }}
