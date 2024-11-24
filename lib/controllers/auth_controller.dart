import 'package:bisplit/views/authgate.dart';
import 'package:bisplit/views/displayname_page.dart';
import 'package:bisplit/views/home_page.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenController extends GetxController {
  static AuthenController instance = Get.find();
  late Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => AuthGate());
    } else {
      _checkUserInFirestore(user);
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

  Future<void> updateDisplayName(String displayName) async {
    User? user = auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'displayName': displayName,
        'photoURL': user.photoURL,
        'uid': user.uid,
      });
    }
  }

  void register(String email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
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

  void signOut() async {
    await auth.signOut();
  }
}

extension on Object {
  get message => null;
}
