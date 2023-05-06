import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class ShopForm extends StatefulWidget {
  @override
  _ShopFormState createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  TimeOfDay _fromTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _toTime = TimeOfDay(hour: 0, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Form'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _shopNameController,
                decoration: InputDecoration(
                  labelText: 'Shop Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a shop name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('From Time'),
                  TimePickerSpinner(
                    time: DateTime(2000, 1, 1, _fromTime.hour, _fromTime.minute),
                    spacing: 10,
                    itemHeight: 40,
                    is24HourMode: false,
                    minutesInterval: 30,
                    onTimeChange: (time) {
                      setState(() {
                        _fromTime = TimeOfDay(hour: time.hour, minute: time.minute);
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('To Time'),
                  TimePickerSpinner(
                    time: DateTime(2000, 1, 1, _toTime.hour, _toTime.minute),
                    spacing: 10,
                    itemHeight: 40,
                    is24HourMode: false,
                    minutesInterval: 30,
                    onTimeChange: (time) {
                      setState(() {
                        _toTime = TimeOfDay(hour: time.hour, minute: time.minute);
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_isTimeValid()) {
                      _saveData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('"To Time" should be after "From Time"'),
                        ),
                      );
                    }
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isTimeValid() {
    final fromTime = _fromTime;
    final toTime = _toTime;

    if (fromTime == null || toTime == null) {
      return false;
    }

    final fromDateTime = DateTime(0, 0, 0, fromTime.hour, fromTime.minute);
    final toDateTime = DateTime(0, 0, 0, toTime.hour, toTime.minute);

    if (toDateTime.isBefore(fromDateTime)) {
      return false;
    }

    return true;
  }

  void _saveData() {
    final shopName = _shopNameController.text;
    final fromTime = _fromTime.format(context);
    final toTime = _toTime.format(context);

    FirebaseFirestore.instance.collection('shops').add({
      'name': shopName,
      'from_time': fromTime,
      'to_time': toTime,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data saved successfully'),
        ),
      );
      _formKey.currentState!.reset();
      _shopNameController.clear();
      setState(() {
        _fromTime = TimeOfDay(hour: 0, minute: 0);
        _toTime = TimeOfDay(hour: 0, minute: 0);
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save data: $error'),
        ),
      );
    });
  }}