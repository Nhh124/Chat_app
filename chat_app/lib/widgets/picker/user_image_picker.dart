import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    Key? key,
    required this.imagepickFn,
  }) : super(key: key);
  final Function(File pickedImage) imagepickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _pickImage() async {
    final pickerImageFile =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = File(pickerImageFile!.path);
    });
    widget.imagepickFn(File(pickerImageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Avarta'),
        ),
      ],
    );
  }
}
