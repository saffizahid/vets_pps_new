import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vets_pps_new/CLINICVETS/Clinics/services/firebase_crud.dart';
import 'package:vets_pps_new/CLINICVETS/home_screen_clinics.dart';
import '../../../AddServicesCrud/service_list.dart';
import '../models/clinics.dart';
import 'addpageClinics.dart';
import 'editpagesec.dart';

class ClinicLists extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClinicLists();
  }
}

class _ClinicLists extends State<ClinicLists> {
  List<Clinics> clinicssincart = [];
  List<String> _selectedDays = [];

  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readClinics();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("List Of Clinics",style: TextStyle(color: Color.fromRGBO(
            214, 217, 220, 1.0), fontSize: 15),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,
        leading:   GestureDetector(
          child: Icon(Icons.arrow_back_rounded),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePageClinics()),
            );
          },
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.app_registration,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPageClinics()),
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
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  String clinicid = e.id;
                  _selectedDays = List<String>.from(e['selectedDays']);
                  bool clinicAvailable = e['CLINICAVALIBLE'] ?? false; // assuming default value is false

                  return Card(
                      child: Column(children: [
                    ListTile(
                      title: Text(e["clinicName"],style: const TextStyle(fontSize: 17)),
                    trailing: Switch(
                      value: clinicAvailable,
                      onChanged: (value) {
                        // update CLINICAVALIBLE in Firestore
                        FirebaseFirestore.instance
                            .collection('Clinics')
                            .doc(clinicid)
                            .update({'CLINICAVALIBLE': value});
                      },
                    ),
                  subtitle: Container(
                        child: (Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Clinic Address: " + e['clinicAddress'],
                                style: const TextStyle(fontSize: 14)),
                            Text("Start Time: " + e['startTime'],
                                style: const TextStyle(fontSize: 14)),
                            Text("End Time: " + e['endTime'],
                                style: const TextStyle(fontSize: 14)),
                            Text("Days: " + _selectedDays.skip(1).join(", "),
                                style: const TextStyle(fontSize: 14)),

                          ],
                        )),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            primary: const Color.fromARGB(255, 143, 133, 226),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('Edit'),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => EditPageSec(
                                  clinics: Clinics(
                                      uid: e.id,
                                      clinicName: e["clinicName"],
                                      clinicAddress: e["clinicAddress"],
                                      endTime: e["endTime"],
                                      startTime: e["startTime"],
                                      pinlocation: e["pinlocation"],
                                      CLINICAVALIBLE: e["CLINICAVALIBLE"],


                                  ),
                                  clinicid: e.id,
                                ),
                              ),
                              (route) =>
                                  false, //if you want to disable back feature set to false
                            );
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            primary: const Color.fromARGB(255, 143, 133, 226),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('Delete'),
                          onPressed: () async {
                            var response =
                                await FirebaseCrud.deleteClinics(docId: e.id);
                            if (response.code != 200) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content:
                                          Text(response.message.toString()),
                                    );
                                  });
                            }
                          },
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(5.0),
                              primary: const Color.fromARGB(255, 143, 133, 226),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            child: const Text('View Services'),

                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ServiceList(clinicId: clinicid,);
                            }));
                          },

                        ),
                      ],
                    ),
                  ]));
                }).toList(),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
