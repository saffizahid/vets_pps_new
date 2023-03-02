import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:vets_pps_new/CLINICVETS/Clinics/services/firebase_crud.dart';
import '../../home_screen_clinics.dart';
import 'ClinicsList.dart';
import 'checkbox.dart';

class AddPageSec extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPageSec();
  }
}
class _AddPageSec extends State<AddPageSec> {
  final _clinicName = TextEditingController();
  final _clinics_clinicAddress = TextEditingController();
  final _clinics_startTime = TextEditingController();
  final _clinics_endTime = TextEditingController();
  final _clinics_contact = TextEditingController();
  final clinicClinic = TextEditingController();
  final clinicTimeSlotDuration = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user= FirebaseAuth.instance.currentUser!;
  DateTime? _fromTime;
  DateTime? _toTime;
  final DateFormat _timeFormat = DateFormat('hh:mm a');
  late String startTimes;
  late String endTimes;
  List<String> _selectedDays = [];
  List<int> _unselectedDays = [];
  String dropdownValue = '30';


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


  @override
  Widget build(BuildContext context) {

    final nameField = TextFormField(
        controller: _clinicName,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
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
            return 'This field is required';
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
            hintText: "Pin Location",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));


    final viewListbutton = TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ClinicLists(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        },
        child: const Text('View List of Clinics',
            style: TextStyle(color:Color.fromRGBO(26, 59, 106, 1.0)),
      textAlign: TextAlign.center,
    ));

    final SaveButon = Material(
      //elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromRGBO(26, 59, 106, 1.0),
      child: MaterialButton(
        //color: Color.fromRGBO(26, 59, 106, 1.0),
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_fromTime == null || _toTime == null) {
              final snackBar = SnackBar(
                content: Text('Please select both From and To times.'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              // Do something with the selected times
              print('From Time: ${_timeFormat.format(_fromTime!)}');
              print('To Time: ${_timeFormat.format(_toTime!)}');
            }

            var response = await FirebaseCrud.addClinics(
              name: _clinicName.text,
              clinicAddress: _clinics_clinicAddress.text,
              startTime: startTimes,
              endTime: endTimes,
              vetid: user.uid,
              pinlocation: clinicClinic.text,
              selecteddays: _selectedDays,
              unselecteddays: _unselectedDays,
              timeslotduration: dropdownValue,

              //    contactno: _clinics_contact.text
            );
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

          };

        },
        child: Text(
          "Save",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Page",style: TextStyle(color: Color.fromRGBO(
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
          },
          child: Icon(
            Icons.arrow_back_sharp,  // add custom icons also
          ),

        ),
      ),

      body: Container(

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
                    const SizedBox(height: 35.0),
                    clinicAddressField,
                    const SizedBox(height: 35.0),
                      SizedBox(height: 8.0),

                    Column(
                      children: [
                        // Step 2.
                        Text(
                          "Time Duration",
                          style: TextStyle(fontSize: 15),
                        ),
                        DropdownButton<String>(
                          // Step 3.
                          value: dropdownValue,
                          // Step 4.
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
                          // Step 5.
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
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Colors.white)
                            ,
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
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Colors.white)
,
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),

                    SizedBox(height: 16),
                    Text("Selected Days: ${_selectedDays.join(", ")}"),
                    SizedBox(height: 16),
                    ElevatedButton(
                      child: Text("Select Days"),
                      onPressed: _showDaysPopup,
                      ),

                    const SizedBox(height: 35.0),
                    clinicpinlocation,
                    const SizedBox(height: 2.0),
                    SaveButon,
                    
                    const SizedBox(height: 00),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
