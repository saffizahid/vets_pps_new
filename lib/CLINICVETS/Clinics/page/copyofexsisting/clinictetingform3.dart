import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class VetClinicShopForm extends StatefulWidget {
  @override
  _VetClinicShopFormState createState() => _VetClinicShopFormState();
}

class _VetClinicShopFormState extends State<VetClinicShopForm> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _shopLocation;
  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      // You can request the permission here
      status = await Permission.locationWhenInUse.request();
      if (status.isDenied) {
        // Handle the case where the user has denied or disabled the permission
      }
    }

    if (status.isGranted) {
      // The permission was granted
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onShopLocationChanged(LatLng location) {
    setState(() {
      _shopLocation = location;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final shopName = _shopNameController.text;
      final shopAddress = _shopAddressController.text;
      final shopLocation = GeoPoint(_shopLocation!.latitude, _shopLocation!.longitude);

      await FirebaseFirestore.instance
          .collection('vetclinicshoptest')
          .add({'shopName': shopName, 'shopAddress': shopAddress, 'shopLocation': shopLocation});

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully!')));
    }
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _shopAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _requestLocationPermission();
    return Scaffold(
      appBar: AppBar(
        title: Text('Vet Clinic Shop Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _shopNameController,
                decoration: InputDecoration(labelText: 'Shop Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a shop name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _shopAddressController,
                decoration: InputDecoration(labelText: 'Shop Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a shop address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Shop Location'),
              SizedBox(height: 8.0),
              Expanded(
                child: GoogleMap(
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 14.0,
                  ),
                  onTap: _onShopLocationChanged,
                  markers: _shopLocation == null
                      ? Set<Marker>()
                      : {
                    Marker(
                      markerId: MarkerId('shopLocation'),
                      position: _shopLocation!,
                    ),
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
