import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileController extends GetxController {
  var displayName = ''.obs;
  var photoURL = ''.obs;
  var isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  void loadUserProfile() {
    User? user = auth.currentUser;
    if (user != null) {
      displayName.value = user.displayName ?? '';
      photoURL.value = user.photoURL ?? '';
    }
  }

  Future<void> updateProfile(String newName, File? imageFile) async {
    isLoading.value = true;
    User? user = auth.currentUser;
    if (user != null) {
      String? newPhotoURL;
      if (imageFile != null) {
        String fileName = '${user.uid}.jpg';
        UploadTask uploadTask = storage
            .ref()
            .child('profile_pictures')
            .child(fileName)
            .putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        newPhotoURL = await taskSnapshot.ref.getDownloadURL();
      } else {
        newPhotoURL = user.photoURL;
      }

      await firestore.collection('users').doc(user.uid).update({
        'displayName': newName,
        'photoURL': newPhotoURL ?? '',
      });

      await user.updateDisplayName(newName);
      await user.updatePhotoURL(newPhotoURL);

      // Update local state
      displayName.value = newName;
      photoURL.value = newPhotoURL ?? '';
    }
    isLoading.value = false;
  }
}
