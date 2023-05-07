import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditService extends StatefulWidget {
  final String clinicId;
  final String serviceId;

  EditService({required this.clinicId, required this.serviceId});

  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final _formKey = GlobalKey<FormState>();
   String _title ='';
   String _description='';
   String _type='';
   String _price='';

  Future<DocumentSnapshot> _getServiceData() async {
    return await FirebaseFirestore.instance
        .collection('Services')
        .doc(widget.serviceId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),

        title: Text('Edit Service',style: TextStyle(color: Color.fromRGBO(
            214, 217, 220, 1.0), fontSize: 15),),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: _getServiceData(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching data'));
              } else {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                _title = data['serviceTitle'] ?? '';
                _description = data['serviceDescription'] ?? '';
                _type = data['serviceType'] ?? '';
                _price = data['price'] ?? '';
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                     /* TextFormField(
                        initialValue: widget.serviceId,
                        decoration: InputDecoration(labelText: 'Service ID'),
                        enabled: false,
                      ),
                     */ TextFormField(
                        initialValue: _title,
                        decoration: InputDecoration(
                          labelText: 'Service Title',
                          icon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onSaved: (value) => _title = value!,
                      ),
                      TextFormField(
                        initialValue: _description,
                        decoration: InputDecoration(
                          labelText: 'Service Description',
                          icon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        onSaved: (value) => _description = value!,
                      ),
                      TextFormField(
                        initialValue: _type,
                        decoration: InputDecoration(
                          labelText: 'Service Type',
                          icon: Icon(Icons.category),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a type';
                          }
                          return null;
                        },
                        onSaved: (value) => _type = value!,
                      ),
                      TextFormField(
                        initialValue: _price,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          icon: Icon(Icons.price_change),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Price';
                          }
                          return null;
                        },
                        onSaved: (value) => _price = value!,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(26, 59, 106, 1.0),
                        // Replace with your desired color
                           elevation: 3, // Controls the button's elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Controls the button's shape
                          ),
                        ),
                        onPressed: _editService,
                        child: Text('Save',style: TextStyle(color: Color.fromRGBO(
                            214, 217, 220, 1.0), fontSize: 15),),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _editService() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final data = {
        'clinicId': widget.clinicId,
        'serviceTitle': _title,
        'serviceDescription': _description,
        'serviceType': _type,
        'price': _price,
        'userId': user.uid,
      };

      await FirebaseFirestore.instance
          .collection('Services')
          .doc(widget.serviceId)
          .update(data);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Service updated'),
        duration: Duration(seconds: 3),
      ));

      Navigator.pop(context);
    }
  }
}