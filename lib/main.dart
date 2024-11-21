import 'package:bisplit/controllers/auth_controller.dart';
import 'package:bisplit/controllers/expense_controller.dart';
import 'package:bisplit/controllers/group_controller.dart';
import 'package:bisplit/firebase_options.dart';
import 'package:bisplit/views/authgate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthenController());
  // Get.put(BudgetController());
  Get.put(ExpenseController());
  Get.put(GroupController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Budget App',
      home: AuthGate(),
    );
  }
}
