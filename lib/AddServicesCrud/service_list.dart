import 'package:flutter/material.dart';
import '../CLINICVETS/home_screen_clinics.dart';
import '../VETATHOME/home_screen_vetathome.dart';
import 'services.dart';
import 'service.dart';
import 'add_service.dart';
import 'edit_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceList extends StatefulWidget {
  final String clinicId;
  String ProfileType;

   ServiceList({super.key,required this.clinicId,required this.ProfileType});

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  final Services _services = Services();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Services',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              if (widget.ProfileType == 'Clinic') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageClinics()),
                );
              } else if (widget.ProfileType == 'VETATHOME') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePageVetAtHome()),
                );
              }
            },
            child: Icon(
              Icons.arrow_back_sharp,color: Colors.white, // add custom icons also
            ),
          )
      ),
      body: StreamBuilder<List<Service>>(
        stream: _services.getServices(widget.clinicId),
        builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No services found',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final Service service = snapshot.data![index];
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Title: "+service.serviceTitle,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Type: "+service.serviceType,

                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      trailing: Text(
                        'Rs. ${service.price}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton.icon(
                          icon: const Icon(
                            Icons.edit,
                            color: Color.fromRGBO(26, 59, 106, 1.0),
                          ),
                          label: const Text(
                            'Edit',
                            style: TextStyle(
                              color: Color.fromRGBO(26, 59, 106, 1.0),
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () => _editService(service.serviceId),
                        ),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () => _deleteService(service.serviceId),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        onPressed: () => _addService(widget.clinicId),
      ),
    );
  }

  void _addService(String clinicId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddService(clinicId: clinicId),
      ),
    );
  }

  void _editService(String serviceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditService(
          serviceId: serviceId,
          clinicId: widget.clinicId,
        ),
      ),
    );
  }

  void _deleteService(String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete service?'),
          content: const Text('Are you sure you want to delete this service?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                await _services.deleteService(widget.clinicId, serviceId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
