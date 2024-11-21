// import 'package:bisplit/models/expense_model.dart';
// import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/expense_controller.dart';

// class ExpensePage extends StatelessWidget {
//   final ExpenseController expenseController = Get.find<ExpenseController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expenses'),
//       ),
//       body: FirestoreListView<Expense>(
//         query: expenseController.collection,
//         itemBuilder: (context, snapshot) {
//           final expense = snapshot.data();
//           return ListTile(
//             title: Text(expense.name),
//             subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 expenseController.deleteExpense(expense.id);
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Add functionality to add a new expense
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
