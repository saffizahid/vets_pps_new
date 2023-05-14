import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final LatLng initialLocation;

  LocationPicker({required this.initialLocation});

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _controller;
  late LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: widget.initialLocation,
            zoom: 16.0,
          ),
          onMapCreated: (controller) => _controller = controller,
          onTap: _selectLocation,
          markers: {
            Marker(
              markerId: MarkerId("selected_location"),
              position: _selectedLocation,
            ),
          },
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () => Navigator.pop(context, _selectedLocation),
            child: Icon(Icons.check),
          ),
        ),
      ],
    );
  }

  void _selectLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }
}
