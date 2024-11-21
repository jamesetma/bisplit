import 'package:bisplit/models/expense_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Query<Expense> getGroupExpensesQuery(String groupId) {
    return firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .withConverter<Expense>(
          fromFirestore: (snapshot, _) => Expense.fromDocument(snapshot),
          toFirestore: (expense, _) => expense.toMap(),
        );
  }

  Future<void> addExpense(Expense expense) async {
    await firestore.collection('expenses').add(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await firestore.collection('expenses').doc(id).delete();
  }
}
