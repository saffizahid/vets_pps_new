import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  LatLng? _pinLocation;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final userInformation = {
        'name': _nameController.text,
        'address': _addressController.text,
        'pinLocation': GeoPoint(
          _pinLocation!.latitude,
          _pinLocation!.longitude,
        ),
      };
      await FirebaseFirestore.instance
          .collection('userinformation')
          .add(userInformation);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User information saved.')),
      );
    }
  }

  void _selectLocation(LatLng location) {
    setState(() {
      _pinLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Information Form')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(onSelectLocation: _selectLocation),
                    ),
                  );
                },
                child: const Text('Select Pin Location on Map'),
              ),
              if (_pinLocation != null) ...[
                const SizedBox(height: 16),
                Text('Pin Location: (${_pinLocation!.latitude}, ${_pinLocation!.longitude})'),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save User Information'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final void Function(LatLng location) onSelectLocation;

  const MapScreen({Key? key, required this.onSelectLocation}) : super(key: key);
      @override
      _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
    widget.onSelectLocation(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Pin Location')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.422, -122.084),
          zoom: 15,
        ),
        onTap: _selectLocation,
        markers: _pickedLocation != null
            ? {
          Marker(
            markerId: const MarkerId('p1'),
            position: _pickedLocation!,
          ),
        }
            : {},
      ),
    );
  }
}

