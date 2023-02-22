import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vets_pps_new/ServiceNew/services.dart';


class AddService extends StatefulWidget {
  final String clinicId;

  const AddService({required this.clinicId});

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _formKey = GlobalKey<FormState>();
  final _serviceTitleController = TextEditingController();
  final _serviceDescriptionController = TextEditingController();
  final _serviceTypeController = TextEditingController();
  final _priceController = TextEditingController();

  final Services _services = Services();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _addService() async {
    try {
      final String serviceTitle = _serviceTitleController.text.trim();
      final String serviceDescription = _serviceDescriptionController.text.trim();
      final String serviceType = _serviceTypeController.text.trim();
      final String price = _priceController.text.trim();

      if (_formKey.currentState!.validate()) {
        await _services.addService(
          widget.clinicId,
          serviceTitle,
          serviceDescription,
          serviceType,
          price,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error adding service: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Service',style: TextStyle(color: Color.fromRGBO(
            214, 217, 220, 1.0), fontSize: 15),),
      backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        centerTitle: true,

      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _serviceTitleController,
                decoration: InputDecoration(
                  hintText: 'Service Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _serviceDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Service Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _serviceTypeController,
                decoration: InputDecoration(
                  hintText: 'Service Type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: 'Price',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(26, 59, 106, 1.0),
                  // Replace with your desired color
                  elevation: 3, // Controls the button's elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Controls the button's shape
                  ),
                ),

                onPressed: _addService,
                child: Text('Add Service',style: TextStyle(color: Color.fromRGBO(
                    214, 217, 220, 1.0), fontSize: 15),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
