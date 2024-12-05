import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  SettingsScreen({super.key});

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
                  child: const Text('English'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      settingsController.changeLanguage('ar', 'SA'),
                  child: const Text('العربية'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Currency'),
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
              onPressed: () => _showDeleteAccountDialog(context),
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              settingsController.deleteAccount();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
