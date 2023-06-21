import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'listofpastcheckups.dart';

class ViewPetProfile extends StatefulWidget {
  final String petId;

  ViewPetProfile({required this.petId});

  @override
  _ViewPetProfileState createState() => _ViewPetProfileState();
}

class _ViewPetProfileState extends State<ViewPetProfile> {
  List<bool> _expandedPanelList = [false, false, false, false, false];
  late Future<DocumentSnapshot> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = FirebaseFirestore.instance
        .collection('Pets Profile')
        .doc(widget.petId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Pet Profile', style: TextStyle(
            color: Color.fromRGBO(214, 217, 220, 1.0), fontSize: 15),
        ),
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Pet profile not found.'),
            );
          }

          final petProfile = snapshot.data!.data() as Map<String, dynamic>;

          // Convert Timestamp to DateTime
          DateTime? dateOfBirth;
          if (petProfile['Date of Birth'] is Timestamp) {
            dateOfBirth = (petProfile['Date of Birth'] as Timestamp).toDate();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: petProfile['Pet Photo'] != null
                      ? Image.network(
                    petProfile['Pet Photo'],
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.pets,
                    size: 100,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  leading: Icon(Icons.pets),
                  title: Text('Pet Name'),
                  subtitle: Text(petProfile['Pet Name']),
                ),
                ListTile(
                  leading: Icon(Icons.category),
                  title: Text('Pet Type'),
                  subtitle: Text(petProfile['Pet Type']),
                ),
                ListTile(
                  leading: Icon(Icons.pets),
                  title: Text('Breed'),
                  subtitle: Text(petProfile['Breed']),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens),
                  title: Text('Color'),
                  subtitle: Text(petProfile['Color']),
                ),
                ListTile(
                  leading: Icon(Icons.cake),
                  title: Text('Date of Birth'),
                  subtitle: Text(
                    dateOfBirth != null
                        ? dateOfBirth.toString()
                        : 'Not available',
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.wc),
                  title: Text('Sex'),
                  subtitle: Text(petProfile['Sex']),
                ),
                ListTile(
                  leading: Icon(Icons.pets),
                  title: Text('Neuter/Spay Status'),
                  subtitle: Text(petProfile['Neuter/Spay Status']),
                ),
                ListTile(
                  leading: Icon(Icons.collections_bookmark),
                  title: Text('Pedigree Status'),
                  subtitle: Text(petProfile['Pedigree Status']),
                ),
                ListTile(
                  leading: Icon(Icons.restaurant),
                  title: Text('Diet Details'),
                  subtitle: Text(petProfile['Diet Details']),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Other Details'),
                  subtitle: Text(petProfile['Other Details']),
                ),
                SizedBox(height: 16.0),
                ExpansionPanelList(
                  elevation: 1,
                  expandedHeaderPadding: EdgeInsets.all(0),
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      _expandedPanelList[panelIndex] = !isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: Icon(Icons.warning),
                          title: Text('Allergies'),
                        );
                      },
                      body: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: petProfile['Allergies'] != null
                              ? petProfile['Allergies']
                              .map<Widget>((allergy) => Text(allergy))
                              .toList()
                              : [Text('No allergies')],
                        ),
                      ),
                      isExpanded: _expandedPanelList[0],
                    ),
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: Icon(Icons.medical_services),
                          title: Text('Medications'),
                        );
                      },
                      body: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: petProfile['Medications'] != null
                              ? petProfile['Medications']
                              .map<Widget>((medication) => Text(medication))
                              .toList()
                              : [Text('No medications')],
                        ),
                      ),
                      isExpanded: _expandedPanelList[1],
                    ),
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: Icon(Icons.history),
                          title: Text('Past Medical History'),
                        );
                      },
                      body: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          petProfile['Past Medical History'] != null
                              ? petProfile['Past Medical History']
                              .map<Widget>((history) => Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${history['Date']}'),
                              Text('Type: ${history['Type']}'),
                              Text('Description: ${history['Description']}'),
                              SizedBox(height: 8.0),
                            ],
                          ))
                              .toList()
                              : [Text('No past medical history')],
                        ),
                      ),
                      isExpanded: _expandedPanelList[2],
                    ),
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: Icon(Icons.healing),
                          title: Text('Past Surgeries'),
                        );
                      },
                      body: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          petProfile['Past Surgeries History'] != null
                              ? petProfile['Past Surgeries History']
                              .map<Widget>((surgery) => Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${surgery['Date']}'),
                              Text('Type: ${surgery['Type']}'),
                              Text('Description: ${surgery['Description']}'),
                              SizedBox(height: 8.0),
                            ],
                          ))
                              .toList()
                              : [Text('No past surgeries')],
                        ),
                      ),
                      isExpanded: _expandedPanelList[3],
                    ),
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: Icon(Icons.local_hospital),
                          title: Text('Past Vaccinations'),
                        );
                      },
                      body: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          petProfile['Past Vaccination History'] != null
                              ? petProfile['Past Vaccination History']
                              .map<Widget>((vaccination) => Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${vaccination['Date']}'),
                              Text('Type: ${vaccination['Type']}'),
                              Text('Description: ${vaccination['Description']}'),
                              SizedBox(height: 8.0),
                            ],
                          ))
                              .toList()
                              : [Text('No past vaccinations')],
                        ),
                      ),
                      isExpanded: _expandedPanelList[4],
                    ),
                  ],
                ),

            Column(
              children: [
                // Other content of the pet profile page
                PetBookingsCard(petId: widget.petId),
              ],),
              ],
            ),
          );
        },
      ),
    );
  }
}
