import 'package:flutter/material.dart';
import 'services.dart';
import 'service.dart';
import 'add_service.dart';
import 'edit_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceList extends StatefulWidget {
  final String clinicId;

  ServiceList({required this.clinicId});

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  final Services _services = Services();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services',style: TextStyle(color: Color.fromRGBO(
            214, 217, 220, 1.0), fontSize: 15),),
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        centerTitle: true,


      ),
      body: StreamBuilder<List<Service>>(
        stream: _services.getServices(widget.clinicId),
        builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: Text('No services found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Service service = snapshot.data![index];
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(service.serviceTitle),
                      subtitle: Text(service.serviceDescription),
                      trailing: Text('\Rs. ${service.price}'),


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
                          onPressed: () => _editService(service.serviceId),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            primary: const Color.fromARGB(255, 143, 133, 226),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('Delete'),
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
        child: Icon(Icons.add),
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
        builder: (context) => EditService(serviceId: serviceId, clinicId: widget.clinicId,),
      ),
    );
  }

  void _deleteService(String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete service?'),
          content: Text('Are you sure you want to delete this service?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Delete'),
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

