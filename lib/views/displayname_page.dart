import 'package:bisplit/controllers/auth_controller.dart';
import 'package:bisplit/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class DisplayNameScreen extends StatefulWidget {
  const DisplayNameScreen({super.key});

  @override
  _DisplayNameScreenState createState() => _DisplayNameScreenState();
}

class _DisplayNameScreenState extends State<DisplayNameScreen> {
  final AuthenController authenController = Get.find<AuthenController>();
  final TextEditingController displayNameController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  void _submitDisplayName() async {
    String displayName = displayNameController.text.trim();
    await authenController.updateDisplayName(displayName, _imageFile);
    Get.offAll(() => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Display Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: displayNameController,
              decoration: const InputDecoration(labelText: 'Display Name'),
            ),
            const SizedBox(height: 20),
            _imageFile != null
                ? Image.file(_imageFile!)
                : IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: _pickImage,
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDisplayName,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
