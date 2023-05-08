import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vets_pps_new/VETATHOME/home_screen_vetathome.dart';
import 'package:vets_pps_new/VetAtHome/ServiceTime/models/VHomeTime.dart';
import '../../../AddServicesCrud/service_list.dart';
import '../../../VETATHOME/ServiceTime/services/firebase_crud.dart';
import 'AddVHomeTime.dart';
import 'EditVHomeTime.dart';

class VHomeTimeLists extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VHomeTimeLists();
  }
}

class _VHomeTimeLists extends State<VHomeTimeLists> {
  List<VHomeTimes> vHomeTimessincart = [];
  List<String> _selectedDays = [];

  final Stream<QuerySnapshot> collectionReference = VAHFirebaseCrud.readVHomeTimes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Of VHomeTimes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_rounded),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePageVetAtHome()),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddServiceVAH()),
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  String clinicid = e.id;
                  _selectedDays = List<String>.from(e['selectedDays']);
                  bool clinicAvailable = e['CLINICAVALIBLE'] ?? false;

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            e["clinicName"],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Switch(
                            value: clinicAvailable,
                            onChanged: (value) {
                              FirebaseFirestore.instance
                                  .collection('VHomeTimes')
                                  .doc(clinicid)
                                  .update({'CLINICAVALIBLE': value});
                            },
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5),
                              Text("Clinic Address: " + e['clinicAddress']),
                              SizedBox(height: 5),
                              Text("Start Time: " + e['startTime']),
                              SizedBox(height: 5),
                              Text("End Time: " + e['endTime']),
                              SizedBox(height: 5),
                              Text("Days: " + _selectedDays.skip(1).join(", ")),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
                                primary: Colors.white,
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: const Text('Edit'),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        EditPageSec(
                                          vHomeTimes: VHomeTimes(
                                            uid: e.id,
                                            endTime: e["endTime"],
                                            startTime: e["startTime"],
                                            pinlocation: e["pinlocation"],
                                            CLINICAVALIBLE: e["CLINICAVALIBLE"],
                                          ),
                                          HomeVetTimeID: e.id,
                                        ),
                                  ),
                                      (route) => false,
                                );
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                backgroundColor: Colors.red[600],
                                primary: Colors.white,
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: const Text('Delete'),
                              onPressed: () async {
                                var response = await VAHFirebaseCrud.deleteVHomeTimes(
                                    docId: e.id);
                                if (response.code != 200) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content:
                                        Text(response.message.toString()),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
                                primary: Colors.white,
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: const Text('View Services'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceList(clinicId: clinicid, ProfileType: 'VETATHOME',),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
