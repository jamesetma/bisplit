import 'package:bisplit/models/expense_model.dart';
import 'package:bisplit/models/group_model.dart';
import 'package:bisplit/views/user_invite_page.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;
  GroupDetailScreen({required this.group});

  final ExpenseController expenseController = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          IconButton(
            icon: Icon(Icons.group_add),
            onPressed: () {
              Get.to(() => InviteUserScreen(groupId: group.id));
            },
          ),
        ],
      ),
      body: FirestoreListView<Expense>(
        query: expenseController.getGroupExpensesQuery(group.id),
        itemBuilder: (context, snapshot) {
          final expense = snapshot.data();
          return ListTile(
            title: Text(expense.name),
            subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                expenseController.deleteExpense(expense.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExpenseBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddExpenseBottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    DateTime date = DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Expense Name'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  Expense newExpense = Expense(
                    id: '', // Firebase will assign an ID
                    groupId: group.id,
                    userId:
                        'currentUserId', // Replace with the current user's ID
                    name: nameController.text,
                    amount: double.parse(amountController.text),
                    date: date,
                  );
                  expenseController.addExpense(newExpense);
                  Navigator.pop(context);
                },
                child: Text('Add Expense'),
              ),
            ],
          ),
        );
      },
    );
  }
}
