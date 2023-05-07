import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';
import 'package:vets_pps_new/CLINICVETS/Clinics/services/firebase_crud.dart';
import '../models/clinics.dart';
import 'ClinicsList.dart';
import 'checkbox.dart';
import 'location.dart';

class EditPageSec extends StatefulWidget {
  final Clinics? clinics;
  final String? clinicid;

  EditPageSec({super.key, this.clinics, this.clinicid});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditPageSec();
  }
}

class _EditPageSec extends State<EditPageSec> {
  final _clinicName = TextEditingController();
  final _clinics_startTime = TextEditingController();
  final _clinics_clinicAddress = TextEditingController();
  final _clinics_endTime = TextEditingController();
  final _docid = TextEditingController();
  final clinicClinic = TextEditingController();
  final clinicTimeSlotDuration = TextEditingController();

  List<String> _selectedDays = [];
  List<int> _unselectedDays = [];
  String dropdownValue = '30';

  late String initialValue;
  static const orange = Color(0xFFFE9A75);
  static const dark = Color(0xFF333A47);
  static const double leftPadding = 50;

  TimeRangeResult? _timeRange;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;

  void _showDaysPopup() async {
    Map<String, dynamic> result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DaysCheckboxWidget(
          selectedDays: _selectedDays,
          unselectedDays: _unselectedDays,
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedDays = result['selectedDays'];
        _unselectedDays = result['unselectedDays'];
      });
    }
  }
  late LatLng _selectedLocation = LatLng(0, 0);
  late GeoPoint pinLocations;

  @override
  void initState() {
    super.initState(); // Add this line
    _docid.value = TextEditingValue(text: widget.clinics!.uid.toString());
    _clinicName.value =
        TextEditingValue(text: widget.clinics!.clinicName.toString());
    _clinics_clinicAddress.value =
        TextEditingValue(text: widget.clinics!.clinicAddress.toString());
   _clinics_startTime.value =
        TextEditingValue(text: widget.clinics!.startTime.toString());
    _clinics_endTime.value =
        TextEditingValue(text: widget.clinics!.endTime.toString());
    clinicClinic.value =
        TextEditingValue(text: widget.clinics!.pinlocation.toString());
    pinLocations= widget.clinics!.pinlocation;

    final startTime = DateFormat('hh:mm a').parse(widget.clinics!.startTime);
    final endTime = DateFormat('hh:mm a').parse(widget.clinics!.endTime);

    final startTime24Hr = TimeOfDay(hour: startTime.hour, minute: startTime.minute);
    final endTime24Hr = TimeOfDay(hour: endTime.hour, minute: endTime.minute);

    _timeRange = TimeRangeResult(startTime24Hr, endTime24Hr);

    FirebaseFirestore.instance
        .collection('Clinics')
        .doc(widget.clinicid)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          _selectedDays = List<String>.from(doc['selectedDays']);
          _unselectedDays = List<int>.from(doc['unselectedDays']);
          initialValue = doc['timeSlotDuration'];
          dropdownValue = initialValue;
          _selectedLocation = LatLng(pinLocations.latitude, pinLocations.longitude);


        });
        print('Selected Days: $_selectedDays');
        print('Unselected Days: $_unselectedDays');
      } else {
        print('Document does not exist');
      }
    }).catchError((error) => print('Error getting document: $error'));
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
        controller: _clinicName,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Clinic Name  is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Enter Clinic Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final clinicAddressField = TextFormField(
        controller: _clinics_clinicAddress,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Clinic Location is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Enter Clinic Location",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final clinicpinlocation = TextFormField(
        controller: clinicClinic,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Enter Clinic Pin Location",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final SaveButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromRGBO(26, 59, 106, 1.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await FirebaseCrud.updateClinics(
                name: _clinicName.text,
                clinicAddress: _clinics_clinicAddress.text,
                startTime: _timeRange!.start.format(context),
                endTime: _timeRange!.end.format(context),
                docId: _docid.text,
                pinlocation: GeoPoint(0,0),
                selecteddays: _selectedDays,
                unselecteddays: _unselectedDays,
                timeslotduration: dropdownValue);
            if (response.code != 200) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            }
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ClinicLists();
          }));

        },
        child: Text(
          "Update",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Edit",
          style: TextStyle(
              color: Color.fromRGBO(214, 217, 220, 1.0), fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ClinicLists();
            }));
          },
          child: Icon(
            Icons.arrow_back_sharp, // add custom icons also
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       nameField,
                      const SizedBox(height: 20.0),
                      clinicAddressField,
                      const SizedBox(height: 25.0),
                      SizedBox(height: 8.0),
                      Column(
                        children: [
                          // Step 2.
                          Text(
                            "Time Slot Duration",
                            style: TextStyle(fontSize: 15),
                          ),
                          DropdownButton<String>(
                            // Step 6.
                            value: dropdownValue,
                            items: <String>['30', '60', '90', '120']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value + " mins",
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }).toList(),
                            // Step 7.
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),


                      TimeRange(
                        fromTitle: const Text(
                          'FROM',
                          style: TextStyle(
                            fontSize: 14,
                            color: dark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        toTitle: const Text(
                          'TO',
                          style: TextStyle(
                            fontSize: 14,
                            color: dark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        titlePadding: leftPadding,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: dark,
                        ),
                        activeTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: orange,
                        ),
                        borderColor: dark,
                        activeBorderColor: dark,
                        backgroundColor: Colors.transparent,
                        activeBackgroundColor: dark,
                        firstTime: const TimeOfDay(hour: 00, minute: 00),
                        lastTime: const TimeOfDay(hour: 23, minute: 30),
                        initialRange: _timeRange,
                        timeStep: 30,
                        timeBlock: 30,
                        onRangeCompleted: (range) => setState(() => _timeRange = range),
                        onFirstTimeSelected: (startHour) {},
                      ),

                      const SizedBox(height: 16),

                      Text("Selected Days: ${_selectedDays.skip(1).join(", ")}"),
                      SizedBox(height: 16),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(26, 59, 106, 1.0),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(color: Colors.white),
                          ),
                        ),

                        child: Text("Select Days",style: TextStyle(color: Colors.white)),
                        onPressed: _showDaysPopup,
                      ),
                      const SizedBox(height: 30.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Selected Location: $_selectedLocation"),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(26, 59, 106, 1.0),
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(color: Colors.white),
                              ),
                            ),

                            onPressed: () async {
                              LatLng? result = await showDialog(
                                context: context,
                                builder: (context) => LocationPicker(
                                  initialLocation: _selectedLocation,
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _selectedLocation = result;
                                });
                              }
                            },
                            child: Text("Select Location",style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),
                      SaveButon,
                      const SizedBox(height: 00),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
