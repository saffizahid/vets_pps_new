import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_range/time_range.dart';
import 'package:vets_pps_new/VetAtHome/ServiceTime/services/firebase_crud.dart';
import '../../../CLINICVETS/Clinics/page/location.dart';
import '../../../VETATHOME/ServiceTime/page/VHomeTime.dart';
import 'checkbox.dart';

class AddServiceVAH extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddServiceVAH();
  }
}

class _AddServiceVAH extends State<AddServiceVAH> {
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
            var response = await VAHFirebaseCrud.addVHomeTimes(
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
              return VHomeTimeLists();
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
              return  VHomeTimeLists();
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
