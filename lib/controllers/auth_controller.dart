import 'dart:io';

import 'package:bisplit/views/authgate.dart';
import 'package:bisplit/views/displayname_page.dart';
import 'package:bisplit/views/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add this import

class AuthenController extends GetxController {
  static AuthenController instance = Get.find();
  late Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseStorage storage =
      FirebaseStorage.instance; // Add this instance variable

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => AuthGate());
    } else {
      _checkUserInFirestore(user);
    }
  }

  Future<void> _saveFcmToken(User user) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await firestore.collection('users').doc(user.uid).update({
        'fcmToken': fcmToken,
      });
    }
  }

  Future<void> _checkUserInFirestore(User user) async {
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      String? displayName = userDoc['displayName'];
      if (displayName == null || displayName.isEmpty) {
        Get.offAll(() => DisplayNameScreen());
      } else {
        Get.offAll(() => HomePage());
      }
    } else {
      Get.offAll(() => DisplayNameScreen());
    }
  }

  Future<void> updateDisplayName(String displayName, File? imageFile) async {
    User? user = auth.currentUser;
    if (user != null) {
      String? photoURL;
      if (imageFile != null) {
        String fileName = '${user.uid}.jpg';
        UploadTask uploadTask = storage
            .ref()
            .child('profile_pictures')
            .child(fileName)
            .putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        photoURL = await taskSnapshot.ref.getDownloadURL();
      } else {
        photoURL = user.photoURL;
      }
      String initials = displayName.isNotEmpty ? displayName[0] : '';
      await firestore.collection('users').doc(user.uid).update({
        'displayName': displayName,
        'photoURL': photoURL ?? initials,
      });
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
    }
  }

  Future<void> register(String email, String password, String displayName,
      File? imageFile) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await updateDisplayName(
          displayName, imageFile); // Update display name and profile picture
    } catch (e) {
      Get.snackbar('Error creating account', e.message!);
    }
  }

  void login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar('Error signing in', e.message!);
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).delete();
        await user.delete();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account');
    }
  }

  void signOut() async {
    await auth.signOut();
  }
}

extension on Object {
  get message => null;
}
