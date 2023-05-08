/*

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/VHomeTime.dart';
import '../services/firebase_crud.dart';
import 'VHomeTime.dart';

class EditPageSec extends StatefulWidget {
  final VHomeTimes? vHomeTimes;
  EditPageSec({super.key, this.vHomeTimes});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditPageSec();
  }
}

class _EditPageSec extends State<EditPageSec> {
  final _vHomeTimes_startTime = TextEditingController();
  final _vHomeTimes_endTime = TextEditingController();
  final _docid = TextEditingController();
  final vHomeTimeVHomeTime = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user= FirebaseAuth.instance.currentUser!;
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
        final snackBar = const SnackBar(
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
  void initState() {
    // TODO: implement initState
    _docid.value = TextEditingValue(text: widget.vHomeTimes!.uid.toString());
    _vHomeTimes_startTime.value = TextEditingValue(text: widget.vHomeTimes!.startTime.toString());
    _vHomeTimes_endTime.value = TextEditingValue(text: widget.vHomeTimes!.endTime.toString());
    vHomeTimeVHomeTime.value = TextEditingValue(text: widget.vHomeTimes!.pinlocation.toString());


  }

  @override
  Widget build(BuildContext context) {








    final vHomeTimepinlocation = TextFormField(
        controller: vHomeTimeVHomeTime,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Enter VHomeTime Pin Location",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));


    final SaveButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color.fromRGBO(26, 59, 106, 1.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await VAHFirebaseCrud.updateVHomeTimes(
                startTime: _vHomeTimes_startTime.text,
                endTime: _vHomeTimes_endTime.text,
                //contactno: _vHomeTimes_contact.text,
                docId: _docid.text,
                pinlocation: vHomeTimeVHomeTime.text,
                selecteddays: [],
                unselecteddays: [],
                timeslotduration: '');
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
        child: const Text(
          "Update",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,

        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Edit",style: TextStyle(color: Color.fromRGBO(
            214, 217, 220, 1.0), fontSize: 15),),

        centerTitle: true,
        backgroundColor: const Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context)
                    {
                      return  VHomeTimeLists();
                    }
                )
            );
          },
          child: const Icon(
            Icons.arrow_back_sharp,  // add custom icons also
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
 const SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(26, 59, 106, 1.0),
                        ),

                        onPressed: () => _selectFromTime(context),
                        child: Text(
                          _fromTime == null
                              ? 'Select From Time'
                              : 'From Time: ${_timeFormat.format(_fromTime!)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Colors.white)
                          ,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(26, 59, 106, 1.0),
                        ),


                        onPressed: () => _selectToTime(context),
                        child: Text(
                          _toTime == null
                              ? 'Select To Time'
                              : 'To Time: ${_timeFormat.format(_toTime!)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Colors.white)
                          ,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),

                  const SizedBox(height: 35.0),
                  vHomeTimepinlocation,
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
