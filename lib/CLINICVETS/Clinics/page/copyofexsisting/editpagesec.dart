/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vets_pps_new/CLINICVETS/Clinics/services/firebase_crud.dart';
import '../models/clinics.dart';
import 'ClinicsList.dart';
import 'checkbox.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  DateTime? _fromTime;
  DateTime? _toTime;
  final DateFormat _timeFormat = DateFormat('hh:mm a');
  late String startTimes;
  late String endTimes;

  Future<void> _selectFromTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      final DateTime now = DateTime.now();
      final DateTime fromTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
      setState(() {
        _fromTime = fromTime;
        startTimes = _timeFormat.format(_fromTime!);
      });
    }
  }

  Future<void> _selectToTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      final DateTime now = DateTime.now();
      final DateTime toTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      if (_fromTime != null && toTime.isBefore(_fromTime!)) {
        final snackBar = SnackBar(
          content: Text('To time should be greater than From time.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          _toTime = toTime;
          endTimes = _timeFormat.format(_toTime!);
        });
      }
    }
  }

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

  @override
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
                startTime: _clinics_startTime.text,
                endTime: _clinics_endTime.text,
                docId: _docid.text,
                pinlocation: clinicClinic.text,
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
      body: Column(
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
                  */
/* DocIDField,
                  const SizedBox(height: 15.0),
                 *//*

                  nameField,
                  const SizedBox(height: 25.0),
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
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
                        ),
                        onPressed: () => _selectFromTime(context),
                        child: Text(
                          _fromTime == null
                              ? 'Select From Time'
                              : 'From Time: ${_timeFormat.format(_fromTime!)}',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
                        ),
                        onPressed: () => _selectToTime(context),
                        child: Text(
                          _toTime == null
                              ? 'Select To Time'
                              : 'To Time: ${_timeFormat.format(_toTime!)}',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                  Text("Selected Days: ${_selectedDays.skip(1).join(", ")}"),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text("Select Days"),
                    onPressed: _showDaysPopup,
                  ),
                  const SizedBox(height: 35.0),
                  clinicpinlocation,
                  const SizedBox(height: 10.0),
                  SaveButon,
                  const SizedBox(height: 00),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
