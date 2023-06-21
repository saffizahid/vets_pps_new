/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_range/time_range.dart';
import 'package:vets_pps_new/CLINICVETS/Clinics/services/firebase_crud.dart';
import 'ClinicsList.dart';
import 'checkbox.dart';
import 'location.dart';

class AddPageClinics extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPageClinics();
  }
}

class _AddPageClinics extends State<AddPageClinics> {
  final _clinicName = TextEditingController();
  final _clinics_clinicAddress = TextEditingController();
  final clinicClinic = TextEditingController();
  final clinicTimeSlotDuration = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  late String startTimes;
  late String endTimes;
  List<String> _selectedDays = [];
  List<int> _unselectedDays = [];
  String dropdownValue = '30';
  static const orange = Color(0xFFFE9A75);
  static const dark = Color(0xFF333A47);
  static const double leftPadding = 50;

  TimeRangeResult? _timeRange;

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

  LatLng _selectedLocation = LatLng(31.364200566573757, 74.21615783125164);
  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
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
          return null;
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
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Enter Clinic Location",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final SaveButon = Material(
      //elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color.fromRGBO(26, 59, 106, 1.0),
      child: MaterialButton(
        //color: Color.fromRGBO(26, 59, 106, 1.0),
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          GeoPoint pinLocations = GeoPoint(_selectedLocation.latitude, _selectedLocation.longitude);
          if (_formKey.currentState!.validate()&& _timeRange != null ) {

            // Query Firestore to get all clinics assigned to the vet.
            var clinicsSnapshot = await FirebaseFirestore.instance
                .collection('Clinics')
                .where('vetids', isEqualTo: user.uid)
                .get();

            // Check if any existing clinic has the same time range and days as the new clinic.
            for (var doc in clinicsSnapshot.docs) {
              Map<String, dynamic> clinicData = doc.data();

              // Note: Change 'startTime', 'endTime' and 'selectedDays' to match the actual field names in Firestore.
              if (clinicData['startTime'] == _timeRange!.start.format(context) &&
                  clinicData['endTime'] == _timeRange!.end.format(context) &&
                  _selectedDays.every((day) => clinicData['selectedDays'].contains(day))) {

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("You already have a clinic scheduled within this time range on the selected days."),
                      );
                    });

                return;  // Don't add the new clinic, just return.
              }
            }

            // If no conflicting clinic is found, proceed to add the new clinic.
            var response = await FirebaseCrud.addClinics(
              name: _clinicName.text,
              clinicAddress: _clinics_clinicAddress.text,
              startTime: _timeRange!.start.format(context),
              endTime: _timeRange!.end.format(context),
              vetid: user.uid,
              pinlocation: pinLocations,
              selecteddays: _selectedDays,
              unselecteddays: _unselectedDays,
              timeslotduration: dropdownValue,
              CLINICAVALIBLE: false,
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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ClinicLists();
            }));


          }

        },
        child: const Text(
          "Save",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Add Page",
          style: TextStyle(
              color: Color.fromRGBO(214, 217, 220, 1.0), fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return  ClinicLists();
            }));
          },
          child: const Icon(
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
                      const SizedBox(height: 35.0),
                      clinicAddressField,
                      const SizedBox(height: 35.0),
                      const SizedBox(height: 8.0),
                      Column(
                        children: [
                          // Step 2.
                          const Text(
                            "Time Slot Duration",
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
                                  style: const TextStyle(fontSize: 15),
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
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(26, 59, 106, 1.0),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: _showDaysPopup,
                        child: const Text("Select Days",style: TextStyle(color: Colors.white),),
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
      ),
    );
  }







}
*//*






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_range/time_range.dart';
import 'package:vets_pps_new/CLINICVETS/Clinics/services/firebase_crud.dart';
import 'ClinicsList.dart';
import 'checkbox.dart';
import 'location.dart';

class AddPageClinics extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPageClinics();
  }
}

class _AddPageClinics extends State<AddPageClinics> {
  final _clinicName = TextEditingController();
  final _clinics_clinicAddress = TextEditingController();
  final clinicClinic = TextEditingController();
  final clinicTimeSlotDuration = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  late String startTimes;
  late String endTimes;
  List<String> _selectedDays = [];
  List<int> _unselectedDays = [];
  String dropdownValue = '30';
  static const orange = Color(0xFFFE9A75);
  static const dark = Color(0xFF333A47);
  static const double leftPadding = 50;

  TimeRangeResult? _timeRange;

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

  LatLng _selectedLocation = LatLng(31.364200566573757, 74.21615783125164);
  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
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
          return null;
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
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Enter Clinic Location",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    DateTime _parseDateTime(String time) {
      // Parse the time string in format "1:30 PM" to a DateTime object.
      final timeParts = time.split(' ');
      final hourMinute = timeParts[0].split(':');
      final hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final isPM = timeParts[1] == 'PM';
      return DateTime(0, 0, 0, isPM ? hour + 12 : hour, minute);
    }
    TimeOfDay _parseTime(String time) {
      // Parse the time string in format "1:30 PM" to a TimeOfDay object.
      final parts = time.split(' ');
      final hourMinute = parts[0].split(':');
      final hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final isPM = parts[1] == 'PM';
      return TimeOfDay(hour: isPM ? hour + 12 : hour, minute: minute);
    }
    DateTime _combineDateTime(TimeOfDay time, DateTime date) {
      // Combine the TimeOfDay object with the given DateTime object.
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }
    String _formatTime(TimeOfDay time) {
      // Format the TimeOfDay object to a string in format "1:30 PM".
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    final SaveButon = Material(
      //elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color.fromRGBO(26, 59, 106, 1.0),
      child: MaterialButton(
        //color: Color.fromRGBO(26, 59, 106, 1.0),
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          GeoPoint pinLocations = GeoPoint(_selectedLocation.latitude, _selectedLocation.longitude);
          if (_formKey.currentState!.validate() && _timeRange != null) {
            // Query Firestore to get all clinics assigned to the vet.
            var clinicsSnapshot = await FirebaseFirestore.instance
                .collection('Clinics')
                .where('vetids', isEqualTo: user.uid)
                .get();

            // Convert the selected time range to DateTime objects.
            DateTime newStartDateTime = _combineDateTime(_timeRange!.start, DateTime.now());
            DateTime newEndDateTime = _combineDateTime(_timeRange!.end, DateTime.now());

            // Check if any existing clinic overlaps with the new clinic's time range on any day.
            for (var doc in clinicsSnapshot.docs) {
              Map<String, dynamic> clinicData = doc.data();

              // Check if the new clinic's time range overlaps with the existing clinic on any day.
              bool hasOverlap = false;
              for (String selectedDay in _selectedDays) {
                if (clinicData['selectedDays'].contains(selectedDay)) {
                  // Extract the start and end times of the existing clinic.
                  String existingStartTime = clinicData['startTime'];
                  String existingEndTime = clinicData['endTime'];

                  // Convert the start and end times to DateTime objects.
                  DateTime existingStartDateTime = _combineDateTime(_parseTime(existingStartTime), DateTime.now());
                  DateTime existingEndDateTime = _combineDateTime(_parseTime(existingEndTime), DateTime.now());

                  // Check for overlap between the new clinic and the existing clinic.
                  if (newStartDateTime.isBefore(existingEndDateTime) && newEndDateTime.isAfter(existingStartDateTime)) {
                    hasOverlap = true;
                    break;
                  }
                }
              }

              // If overlap is found, show the dialog and return.
              if (hasOverlap) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("You already have a clinic scheduled within this time range on the selected day(s)."),
                    );
                  },
                );
                return; // Don't add the new clinic, just return.
              }
            }

            // If no overlapping clinic is found, proceed to add the new clinic.
            var response = await FirebaseCrud.addClinics(
              name: _clinicName.text,
              clinicAddress: _clinics_clinicAddress.text,
              startTime: _formatTime(_timeRange!.start),
              endTime: _formatTime(_timeRange!.end),
              vetid: user.uid,
              pinlocation: pinLocations,
              selecteddays: _selectedDays,
              unselecteddays: _unselectedDays,
              timeslotduration: dropdownValue,
              CLINICAVALIBLE: false,
            );

            if (response.code != 200) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(response.message.toString()),
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(response.message.toString()),
                  );
                },
              );
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ClinicLists();
            }));
          }
        },


        child: const Text(
          "Save",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Add Page",
          style: TextStyle(
              color: Color.fromRGBO(214, 217, 220, 1.0), fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return  ClinicLists();
            }));
          },
          child: const Icon(
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
                      const SizedBox(height: 35.0),
                      clinicAddressField,
                      const SizedBox(height: 35.0),
                      const SizedBox(height: 8.0),
                      Column(
                        children: [
                          // Step 2.
                          const Text(
                            "Time Slot Duration",
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
                                  style: const TextStyle(fontSize: 15),
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
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(26, 59, 106, 1.0),
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: _showDaysPopup,
                        child: const Text("Select Days",style: TextStyle(color: Colors.white),),
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
      ),
    );
  }







}
*/
