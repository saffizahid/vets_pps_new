/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../CLINICVETS/home_screen_clinics.dart';
import 'add_item.dart';
import 'item_details.dart';

class ItemList extends StatelessWidget {
  ItemList({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference =
  FirebaseFirestore.instance.collection('vets');

  //_reference.get()  ---> returns Future<QuerySnapshot>
  //_reference.snapshots()--> Stream<QuerySnapshot> -- realtime updates
  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VETS",style: TextStyle(color: Color.fromRGBO(
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Check error
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          //Check if data arrived
          if (snapshot.hasData) {
            //get the data
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Convert the documents to Maps
            List<Map> items = documents.map((e) =>
            {
              'id': e.id,
              'name': e['name'],
              'subtitle': e['subtitle'],
              'profileImg': e['profileImg'],
              'year': e['year'],
              'price': e['price']
            }).toList();

            //Display the list
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  //Get the item at this index
                  Map thisItem = items[index];
                  //REturn the widget for the list items
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: InkWell(

                      child: Container(
                        color: Color.fromRGBO(97, 97, 98, 0.08235294117647059),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Vet nearby".toUpperCase()),
                                Text(
                                  "".toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: Color.fromRGBO(
                                      26, 59, 106, 1.0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundImage: NetworkImage("${thisItem['profileImg']}"),

                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      "${thisItem['name']}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        "${thisItem['subtitle']}",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.blueGrey),
                                      ),
                                    ),
                                    Row(
                                      children:  [
                                        CircleAvatar(
                                          radius: 10,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "${thisItem['year']} Years",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.blueGrey),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        // CircleAvatar(
                                        // radius: 10,
                                        //),
                                        SizedBox(
                                          width: 4,
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    Text("Total fee"),
                                    Text(
                                      "${thisItem['price']}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemDetails(thisItem['id'] )));
                                      },

                                      child: Container(
                                        decoration:
                                        BoxDecoration(color: const Color.fromRGBO(
                                            26, 59, 106, 1.0),
                                            borderRadius: BorderRadius.circular(24)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: const Center(
                                          child: Text(
                                            "View Details",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }

          //Show loader
          return Center(child: CircularProgressIndicator());
        },
      ), //Display a list // Add a FutureBuilder
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddItem()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/
