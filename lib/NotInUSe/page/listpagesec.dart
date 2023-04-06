import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/services.dart';
import '../services/firebase_crud.dart';
import 'addpagesec.dart';
import 'editpagesec.dart';

class ListPageSec extends StatefulWidget {
  String clinicid;
  ListPageSec({required this.clinicid});

  @override
  State<StatefulWidget> createState() {
    return _ListPageSec();
  }
}

class _ListPageSec extends State<ListPageSec> {
  List<Services> servicessincart = [];

  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readServices();
  //FirebaseFirestore.instance.collection('Services').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("List Of Services",style: TextStyle(color: Color.fromRGBO(
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
                  return Card(
                      child: Column(children: [
                    ListTile(
                      title: Text(e["servicetitle"]),
                      subtitle: Container(
                        child: (Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                           /* Text("Contact Number: " + e['contact_no'],
                                style: const TextStyle(fontSize: 12)),
                           */ Text("price: " + e['price'],
                                style: const TextStyle(fontSize: 12)),
                            Text("servicetype: " + e['servicetype'],
                                style: const TextStyle(fontSize: 14)),
                            Text("servicedescription: " + e['servicedescription'],
                                style: const TextStyle(fontSize: 14)),
                            Text("Service Clinic: " + e['ClinicName'],
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
                                  services: Services(
                                      uid: e.id,
                                      servicetitle: e["servicetitle"],
                                      servicetype: e["servicetype"],
                                      //contactno: e["contact_no"],
                                      price: e["price"],
                                      servicedescription: e["servicedescription"],
                                      ClinicName: e["ClinicName"],

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
                                await FirebaseCrud.deleteServices(docId: e.id);
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
                            child: const Text('Add To Cart'),
                            onPressed: () async {
                              final _db = FirebaseFirestore.instance;

                              await _db.collection("cart").add({
                                "servicetitle": e["servicetitle"],
                                "servicetype": e["servicetype"],
                                "price": e["price"],
                                "servicedescription": e["servicedescription"]
                                 });

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content:
                                      Text("Added To Cart"),
                                    );
                                  });
                            }

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
