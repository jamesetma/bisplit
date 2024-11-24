import 'dart:convert';

import 'package:bisplit/config.dart';
import 'package:bisplit/models/expense_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ExpenseController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var totalExpenses = 0.0.obs;
  var userExpenses = <String, double>{}.obs;
  var selectedCurrency = 'USD'.obs;
  var currencies = <String>[].obs;
  final String apiKey = Config.apiKey; // Load API key from config
  Stream<List<Expense>> getGroupExpensesStream(String groupId) {
    return firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Expense.fromDocument(doc)).toList());
  }

  void calculateTotals(String groupId) {
    firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .listen((snapshot) {
      double total = 0;
      Map<String, double> userExp = {};

      for (var doc in snapshot.docs) {
        var expense = Expense.fromDocument(doc);
        total += expense.amount;
        if (userExp.containsKey(expense.userId)) {
          userExp[expense.userId] = userExp[expense.userId]! + expense.amount;
        } else {
          userExp[expense.userId] = expense.amount;
        }
      }

      totalExpenses.value = total;
      userExpenses.value = userExp;
    });
  }

  Future<void> addExpense(Expense expense) async {
    await firestore.collection('expenses').add(expense.toMap());
  }

  Future<String> getUserNameById(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await firestore.collection('users').doc(userId).get();
    return userDoc.data()?['displayName'] ?? 'Unknown User';
  }

  Future<void> deleteExpense(String expenseId, String groupId) async {
    await firestore.collection('expenses').doc(expenseId).delete();
  }

  Future<void> toggleExpenseCompletion(
      String expenseId, bool isCompleted, String groupId) async {
    await firestore
        .collection('expenses')
        .doc(expenseId)
        .update({'isCompleted': isCompleted});
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
}
