import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart'; // Import the config file

class SettingsController extends GetxController {
  var selectedCurrency = 'USD'.obs;
  var currencies = <String>[].obs;
  final String apiKey = Config.apiKey; // Load API key from config
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadCurrency();
    loadSupportedCurrencies();
  }

  void loadCurrency() async {
    // Load the selected currency from the database
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await firestore.collection('users').doc('USER_ID').get();
    if (userDoc.exists && userDoc.data()?['currency'] != null) {
      selectedCurrency.value = userDoc.data()?['currency'];
    }
  }

  void loadSupportedCurrencies() async {
    // Fetch supported currencies from the API
    final response = await http
        .get(Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/codes'));
    if (response.statusCode == 200) {
      final List<dynamic> currencyCodes =
          jsonDecode(response.body)['supported_codes'];
      currencies.value =
          currencyCodes.map((code) => code[0].toString()).toList();
    } else {
      throw Exception('Failed to load supported currencies');
    }
  }

  void changeCurrency(String currency) async {
    selectedCurrency.value = currency;
    // Update the currency in the database
    await firestore.collection('users').doc('USER_ID').update({
      'currency': currency,
    });
  }

  Future<double> convertCurrency(
      double amount, String fromCurrency, String toCurrency) async {
    if (fromCurrency == toCurrency) {
      return amount;
    }

    final response = await http.get(Uri.parse(
        'https://v6.exchangerate-api.com/v6/$apiKey/latest/$fromCurrency'));

    if (response.statusCode == 200) {
      final rates = jsonDecode(response.body)['conversion_rates'];
      double rate = rates[toCurrency];
      return amount * rate;
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }

  void changeLanguage(String langCode, String countryCode) {
    var locale = Locale(langCode, countryCode);
    Get.updateLocale(locale);
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

  void logout() async {
    await auth.signOut();
  }
}
