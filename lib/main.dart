import 'package:bisplit/controllers/auth_controller.dart';
import 'package:bisplit/controllers/expense_controller.dart';
import 'package:bisplit/controllers/group_controller.dart';
import 'package:bisplit/controllers/settings_controller.dart';
import 'package:bisplit/firebase_options.dart';
import 'package:bisplit/localization/translations.dart';
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
  Get.put(ExpenseController());
  Get.put(GroupController());
  Get.put(SettingsController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      title: 'Budget App',
      home: AuthGate(),
    );
  }
}
