import 'package:bisplit/models/expense_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var expenses = <Expense>[].obs;
  var totalExpenses = 0.0.obs;
  var userExpenses = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Query<Expense> getGroupExpensesQuery(String groupId) {
    return firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .withConverter<Expense>(
          fromFirestore: (snapshot, _) => Expense.fromDocument(snapshot),
          toFirestore: (expense, _) => expense.toMap(),
        );
  }

  Stream<List<Expense>> getGroupExpensesStream(String groupId) {
    return firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .withConverter<Expense>(
          fromFirestore: (snapshot, _) => Expense.fromDocument(snapshot),
          toFirestore: (expense, _) => expense.toMap(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  void calculateTotals(String groupId) async {
    QuerySnapshot<Map<String, dynamic>> expensesSnapshot = await firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .get();

    double total = 0.0;
    Map<String, double> userTotals = {};

    for (var doc in expensesSnapshot.docs) {
      if (!doc['isCompleted']) {
        double amount = doc['amount'];
        total += amount;

        String userName = doc['userName'];
        userTotals[userName] = (userTotals[userName] ?? 0) + amount;
      }
    }

    totalExpenses.value = total;
    userExpenses.value = userTotals;
  }

  Future<void> addExpense(Expense expense) async {
    await firestore.collection('expenses').add(expense.toMap());
    calculateTotals(expense.groupId); // Recalculate totals
  }

  Future<void> deleteExpense(String id, String groupId) async {
    await firestore.collection('expenses').doc(id).delete();
    calculateTotals(groupId); // Recalculate totals
  }

  Future<void> toggleExpenseCompletion(
      String expenseId, bool isCompleted, String groupId) async {
    await firestore.collection('expenses').doc(expenseId).update({
      'isCompleted': isCompleted,
    });
    calculateTotals(groupId); // Recalculate totals
  }
}
