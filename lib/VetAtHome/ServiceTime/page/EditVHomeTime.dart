
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';
import '../models/VHomeTime.dart';
import '../services/firebase_crud.dart';
import 'VHomeTime.dart';
import 'checkbox.dart';

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

  late String initialValue;
  static const orange = Color(0xFFFE9A75);
  static const dark = Color(0xFF333A47);
  static const double leftPadding = 50;

  TimeRangeResult? _timeRange;
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

  @override
  void initState() {
    // TODO: implement initState
    _docid.value = TextEditingValue(text: widget.vHomeTimes!.uid.toString());
    _vHomeTimes_startTime.value = TextEditingValue(text: widget.vHomeTimes!.startTime.toString());
    _vHomeTimes_endTime.value = TextEditingValue(text: widget.vHomeTimes!.endTime.toString());
    vHomeTimeVHomeTime.value = TextEditingValue(text: widget.vHomeTimes!.pinlocation.toString());

    final startTime = DateFormat('hh:mm a').parse(widget.vHomeTimes!.startTime);
    final endTime = DateFormat('hh:mm a').parse(widget.vHomeTimes!.endTime);

    final startTime24Hr = TimeOfDay(hour: startTime.hour, minute: startTime.minute);
    final endTime24Hr = TimeOfDay(hour: endTime.hour, minute: endTime.minute);

    _timeRange = TimeRangeResult(startTime24Hr, endTime24Hr);
     String? VHOMEID= widget.vHomeTimes!.uid;
    FirebaseFirestore.instance
        .collection('HomeVetTime')
        .doc(VHOMEID)
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
                startTime: _timeRange!.start.format(context),
                endTime: _timeRange!.end.format(context),
                //contactno: _vHomeTimes_contact.text,
                docId: _docid.text,
                pinlocation: GeoPoint(0,0),
                selecteddays: _selectedDays,
                unselecteddays: _unselectedDays,
                timeslotduration: dropdownValue
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
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return VHomeTimeLists();
          }));

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
