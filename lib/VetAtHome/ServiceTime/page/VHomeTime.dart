import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vets_pps_new/VETATHOME/home_screen_vetathome.dart';
import '../../../AddServicesCrud/service_list.dart';
import '../models/VHomeTime.dart';
import '../services/firebase_crud.dart';
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

  final Stream<QuerySnapshot> collectionReference = VAHFirebaseCrud.readVHomeTimes();
  //FirebaseFirestore.instance.collection('VHomeTimes').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Vet At Home Time",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_rounded,color: Colors.white,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageVetAtHome()),
              );
            },
          ),
         ),
        body: StreamBuilder<QuerySnapshot>(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(26, 59, 106, 1.0),
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),child: Text('Please Add Timming'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddServiceVAH()),
                      );
                    },
                  ),
                );
              } else {

                return     Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView(
                    children: snapshot.data!.docs.map((e) {
                      List<String> _selectedDays = [];
                      _selectedDays = List<String>.from(e['selectedDays']);

                      String vHomeTimeid = e.id;
                      return Card(
                          elevation: 5,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(children: [
                            ListTile(
                              subtitle: Container(
                                child: (Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 5),
                                    SizedBox(height: 5),
                                    Text("Start Time: " + e['startTime'],style: TextStyle(color: Colors.black,fontSize: 17),),
                                    SizedBox(height: 5),
                                    Text("End Time: " + e['endTime'],style: TextStyle(color: Colors.black,fontSize: 17),),
                                    SizedBox(height: 5),
                                    Text("Days: " + _selectedDays.skip(1).join(", "),style: TextStyle(color: Colors.black,fontSize: 17),),
                                    SizedBox(height: 10),

                                  ],
                                )),
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
                                        builder: (BuildContext context) => EditPageSec(
                                          vHomeTimes: VHomeTimes(
                                            uid: e.id,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    backgroundColor: Colors.red[600],
                                    primary: Colors.white,
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                  child: const Text('Delete'),
                                  onPressed: () async {
                                    var response =
                                    await VAHFirebaseCrud.deleteVHomeTimes(docId: e.id);
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
                                    primary: Colors.white,
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                  child: const Text('View Services'),

                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return ServiceList(clinicId: vHomeTimeid, ProfileType: 'VETATHOME',);
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
          }
        },
      )

    );
  }
}
