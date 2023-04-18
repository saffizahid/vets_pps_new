import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicturePicker extends StatefulWidget {
  final void Function(File?) onImageSelected;

  ProfilePicturePicker({required this.onImageSelected});

  @override
  _ProfilePicturePickerState createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  File? _imageFile;

  String? _validateImage(File? image) {
    if (image == null) {
      return 'Please select a profile picture';
    }
    return null;
  }

  Future<void> _getImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedImage != null ? File(pickedImage.path) : null;
    });
    widget.onImageSelected(_imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _getImage,
          child: CircleAvatar(
            radius: 70.0,
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
            child: _imageFile == null ? Icon(Icons.add_a_photo) : null,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          _validateImage(_imageFile) ?? '',
          style: TextStyle(color: Colors.red, fontSize: 12.0),
        ),
      ],
    );
  }
}
