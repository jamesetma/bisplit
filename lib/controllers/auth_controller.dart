import 'package:bisplit/views/authgate.dart';
import 'package:bisplit/views/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenController extends GetxController {
  // Firebase Auth instance
  static AuthenController instance = Get.find();
  late Rx<User?> firebaseUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Observable user for real-time updates
  var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    // Bind FirebaseAuth user state changes to the `user` observable
    user.bindStream(_auth.authStateChanges());
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => AuthGate());
    } else {
      _addUserToFirestore(user);
      Get.offAll(() => HomePage());
    }
  }

  Future<void> _addUserToFirestore(User user) async {
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      await firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'uid': user.uid,
      });
    }
  }

  // Log out the user
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => AuthGate());
  }
}
