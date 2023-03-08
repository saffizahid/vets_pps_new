import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vets_pps_new/CLINICVETS/Clinics/services/firebase_crud.dart';
import '../../../AddServicesCrud/service_list.dart';
import '../models/clinics.dart';
import 'addpagesec.dart';
import 'editpagesec.dart';

class ClinicLists extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClinicLists();
  }
}

class _ClinicLists extends State<ClinicLists> {
  List<Clinics> clinicssincart = [];

  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readClinics();
  //FirebaseFirestore.instance.collection('Clinics').snapshots();
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.app_registration,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => AddPageSec(),
                ),
                (route) =>
                    false, //if you want to disable back feature set to false
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

                  return Card(
                      child: Column(children: [
                    ListTile(
                      title: Text(e["clinicName"]),
                      subtitle: Container(
                        child: (Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                           /* Text("Contact Number: " + e['contact_no'],
                                style: const TextStyle(fontSize: 12)),
                           */ Text("endTime: " + e['endTime'],
                                style: const TextStyle(fontSize: 12)),
                            Text("clinicAddress: " + e['clinicAddress'],
                                style: const TextStyle(fontSize: 14)),
                            Text("startTime: " + e['startTime'],
                                style: const TextStyle(fontSize: 14)),
                            Text("Clinic Clinic: " + e['pinlocation'],
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
                                      //contactno: e["contact_no"],
                                      endTime: e["endTime"],
                                      startTime: e["startTime"],
                                      pinlocation: e["pinlocation"],

                                  ),
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
