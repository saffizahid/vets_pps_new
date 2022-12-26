import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'item_list.dart';

class ItemDetails extends StatelessWidget {
  ItemDetails(this.itemId, {Key? key}) : super(key: key) {
    _reference =
        FirebaseFirestore.instance.collection('vets').doc(itemId);
    _futureData = _reference.get();
  }

  String itemId;
  late DocumentReference _reference;

  //_reference.get()  --> returns Future<DocumentSnapshot>
  //_reference.snapshots() --> Stream<DocumentSnapshot>
  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      /*appBar: AppBar(
        title: Text('Item details'),
        actions: [
          IconButton(
              onPressed: () {
                //add the id to the map
                data['id'] = itemId;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditItem(data)));
              },
              icon: Icon(Icons.edit)),
          IconButton(onPressed: (){
            //Delete the item
            _reference.delete();
          }, icon: Icon(Icons.delete))
        ],
      ),
      */body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            //Get the data
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;

            //display the data
             return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: Color.fromRGBO(26, 59, 106, 1.0),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return ItemList();
                                      }));
                                },
                                child: Icon(
                                  Icons.arrow_back_sharp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Nisebuschgardens',
                            ),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Container(
                            height: height * 0.43,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double innerHeight = constraints.maxHeight;
                                double innerWidth = constraints.maxWidth;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: innerHeight * 0.72,
                                        width: innerWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 80,
                                            ),
                                            Text(
                                                '${data['name']}',
                                              style: TextStyle(
                                                color: Color.fromRGBO(39, 105, 171, 1),
                                                fontFamily: 'Nunito',
                                                fontSize: 37,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      '${data['subtitle']}', style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontFamily: 'Nunito',
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.location_on),
                                                        Text(
                                                          'Asim Vet Clinic',
                                                          style: TextStyle(
                                                            color: Color.fromRGBO(
                                                                39, 105, 171, 1),
                                                            fontFamily: 'Nunito',
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 110,
                                      right: 20,
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.grey[700],
                                        size: 30,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          child: Image.network(
                                            'https://media.istockphoto.com/id/177373093/photo/indian-male-doctor.jpg?s=612x612&w=0&k=20&c=5FkfKdCYERkAg65cQtdqeO_D0JMv6vrEdPw3mX1Lkfg=',
                                            width: innerWidth * 0.45,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: height * 0.5,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromRGBO(26, 59, 106, 1.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      color: Color.fromRGBO(39, 105, 171, 1),
                                      fontSize: 1,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  //Divider(
                                  // thickness: 2.5,
                                  //),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: height * 0.3,
                                    width: width * 2.2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top:10),
                                          child: Text(
                                            'About Us',
                                            style: TextStyle(
                                              color: Color.fromRGBO(39, 105, 171, 1),
                                              fontSize: 20,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2.5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "Dr. Sajjad Javaid is one of the best veterinary doctors in Lahore with a high patient satisfaction rate. "
                                                "He earned his in veterinary sciences which involves diagnosis, and treatment of animal diseases such as brucellosis, anthrax, Q fever and lumpy skin diseases etc.",
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: height * 0.22,
                                      width: width * 1.6,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:8),
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                color: Color.fromRGBO(39, 105, 171, 1),
                                                fontSize: 18,
                                                fontFamily: 'Nunito',
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 2.5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  color: Colors.grey[600],
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "10:00 AM -",
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 15,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.access_time,
                                                  color: Colors.grey[600],
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "11:00 PM ",
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 15,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                              ],
                                            ),


                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  color: Colors.grey[600],
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "0300-3344567",
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 17,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );














          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
