import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vets_pps_new/AddServicesCrud/services.dart';

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
      final String serviceDescription =
          _serviceDescriptionController.text.trim();
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

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service added successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding service')),
      );
      print('Error adding service: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Service', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _serviceTitleController,
                  decoration: InputDecoration(
                    labelText: 'Service Title',
                    icon: Icon(Icons.title),
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
                    labelText: 'Service Description',
                    icon: Icon(Icons.description),
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
                    labelText: 'Service Type',
                    icon: Icon(Icons.category),
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
                    labelText: 'Price',
                    icon: Icon(Icons.price_change),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    double? price = double.tryParse(value);
                    if (price == null) {
                      return 'Please enter a valid price';
                    }
                    if (price < 50) {
                      return 'Price must be at least 50';
                    }
                    if (price < 0) {
                      return 'Price cannot be negative';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.0),
            Container(
              width: 200, // replace with your desired width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(26, 59, 106, 1.0),
                  // Replace with your desired color
                  elevation: 3, // Controls the button's elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20), // Controls the button's shape
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: _addService,
                child: Text(
                  'Add Service',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
