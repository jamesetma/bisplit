import 'package:bisplit/controllers/auth_controller.dart';
import 'package:bisplit/models/expense_model.dart';
import 'package:bisplit/models/group_model.dart';
import 'package:bisplit/views/user_invite_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';
import '../controllers/group_controller.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;
  GroupDetailScreen({required this.group});

  final ExpenseController expenseController = Get.find<ExpenseController>();
  final GroupController groupController = Get.find<GroupController>();
  final AuthenController authenController = Get.find<AuthenController>();

  @override
  Widget build(BuildContext context) {
    final String currentUserId = authenController.firebaseUser.value?.uid ?? '';

    // Initialize total calculations
    expenseController.calculateTotals(group.id);

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
      body: Column(
        children: [
          Obx(() {
            double totalExpenses = expenseController.totalExpenses.value;
            int numberOfMembers = group.memberIds.length;
            double sharePerMember = totalExpenses / numberOfMembers;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Total Expenses: \$${totalExpenses.toStringAsFixed(2)}'),
                  Text(
                      'Each member should contribute: \$${sharePerMember.toStringAsFixed(2)}'),
                  SizedBox(height: 16),
                  Text('Expenses by User:'),
                  ...expenseController.userExpenses.entries.map((entry) {
                    return Text(
                        '${entry.key}\'s total: \$${entry.value.toStringAsFixed(2)}');
                  }).toList(),
                ],
              ),
            );
          }),
          Expanded(
            child: StreamBuilder<List<Expense>>(
              stream: expenseController.getGroupExpensesStream(group.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final expenses = snapshot.data!;
                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return CheckboxListTile(
                      title: Text(expense.name),
                      subtitle: Text(
                          'Amount: \$${expense.amount.toStringAsFixed(2)}\nAdded by: ${expense.userName}'),
                      value: expense.isCompleted,
                      onChanged: currentUserId == expense.userId
                          ? (bool? value) {
                              expenseController.toggleExpenseCompletion(
                                  expense.id, value ?? false, group.id);
                            }
                          : null,
                      secondary: currentUserId == expense.userId
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                expenseController.deleteExpense(
                                    expense.id, group.id);
                              },
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
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
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
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
                      final String userId =
                          authenController.firebaseUser.value?.uid ?? '';
                      final String userName =
                          authenController.firebaseUser.value?.displayName ??
                              '';

                      Expense newExpense = Expense(
                        id: '', // Firebase will assign an ID
                        groupId: group.id,
                        userId: userId,
                        userName: userName,
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
            ),
          ),
        );
      },
    );
  }
}
