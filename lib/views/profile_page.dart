import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final TextEditingController displayNameController = TextEditingController();

    Future<void> _pickImage() async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        profileController.updateProfile(
            displayNameController.text, File(pickedFile.path));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          displayNameController.text = profileController.displayName.value;
          String? photoURL = profileController.photoURL.value.isNotEmpty
              ? profileController.photoURL.value
              : null;

          return profileController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          photoURL != null ? NetworkImage(photoURL) : null,
                      child: photoURL == null
                          ? Text(
                              profileController.displayName.value.isNotEmpty
                                  ? profileController.displayName.value[0]
                                  : '',
                              style: TextStyle(fontSize: 40),
                            )
                          : null,
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.add_a_photo),
                      label: Text('Change Photo'),
                      onPressed: _pickImage,
                    ),
                    TextField(
                      controller: displayNameController,
                      decoration: InputDecoration(labelText: 'Display Name'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        profileController.updateProfile(
                            displayNameController.text, null);
                      },
                      child: Text('Update Profile'),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
