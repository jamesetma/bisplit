import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('change_language'.tr),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      settingsController.changeLanguage('en', 'US'),
                  child: Text('English'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      settingsController.changeLanguage('ar', 'SA'),
                  child: Text('العربية'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Currency'),
            Obx(() => DropdownButton<String>(
                  value: settingsController.selectedCurrency.value,
                  items: settingsController.currencies.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    settingsController.changeCurrency(newValue!);
                  },
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: settingsController.logout,
              child: Text('logout'.tr),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: settingsController.deleteAccount,
              child: Text('delete_account'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
