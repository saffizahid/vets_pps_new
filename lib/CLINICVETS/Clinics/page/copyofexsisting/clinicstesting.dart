import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClinicForm extends StatefulWidget {
  const ClinicForm({Key? key}) : super(key: key);

  @override
  _ClinicFormState createState() => _ClinicFormState();
}

class _ClinicFormState extends State<ClinicForm> {
  final _formKey = GlobalKey<FormState>();

  final List<int> _timeDurations = [30, 60, 90, 120];
  int? _selectedTimeDuration;

  TimeOfDay _fromTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _toTime = TimeOfDay(hour: 17, minute: 0);

  String? _clinicName;
  String? _clinicAddress;

  Future<void> _submitForm() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      try {
        await FirebaseFirestore.instance.collection('Clinics').add({
          'clinicName': _clinicName,
          'clinicAddress': _clinicAddress,
          'timeDuration': _selectedTimeDuration,
          'fromTime': DateTime(1, 1, 1, _fromTime.hour, _fromTime.minute),
          'toTime': DateTime(1, 1, 1, _toTime.hour, _toTime.minute),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clinic added successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add clinic')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Add Clinic'),
    ),
    body: SingleChildScrollView(
    child: Container(
    padding: EdgeInsets.all(16),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Clinic Name',
    border: OutlineInputBorder(),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter clinic name';
    }
    return null;
    },
    onSaved: (value) {
    _clinicName = value;
    },
    ),
    SizedBox(height: 16),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Clinic Address',
    border: OutlineInputBorder(),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter clinic address';
    }
    return null;
    },
    onSaved: (value) {
    _clinicAddress = value;
    },
    ),
    SizedBox(height: 16),
    DropdownButtonFormField<int>(
    decoration: InputDecoration(
    labelText: 'Time Duration',
    border: OutlineInputBorder(),
    ),
    value: _selectedTimeDuration,
    onChanged: (value) {
    setState(() {
    _selectedTimeDuration = value;
    });
    },
    items: _timeDurations
        .map((duration) => DropdownMenuItem<int>(
    value:
    duration,
      child: Text('$duration mins'),
    ))
        .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select time duration';
        }
        return null;
      },
    ),
      SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _fromTime,
                  useRootNavigator: false,
                );
                if (time != null) {
                  setState(() {
                    _fromTime = TimeOfDay(
                        hour: time.hour,
                        minute: time.minute -
                            time.minute.remainder(30));
                  });
                }
              },
              child: IgnorePointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'From Time',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: _fromTime.format(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select from time';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _toTime,
                  useRootNavigator: false,
                );
                if (time != null) {
                  setState(() {
                    _toTime = TimeOfDay(
                        hour: time.hour,
                        minute: time.minute -
                            time.minute.remainder(30));
                  });
                }
              },
              child: IgnorePointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'To Time',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: _toTime.format(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select to time';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Center(
        child: ElevatedButton(
          onPressed: _submitForm,
          child: Text('Add Clinic'),
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