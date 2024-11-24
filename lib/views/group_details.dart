import 'package:bisplit/controllers/auth_controller.dart';
import 'package:bisplit/models/expense_model.dart';
import 'package:bisplit/models/group_model.dart';
import 'package:bisplit/views/user_invite_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';
import '../controllers/group_controller.dart';
import '../controllers/settings_controller.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;
  GroupDetailScreen({required this.group});

  final ExpenseController expenseController = Get.find<ExpenseController>();
  final GroupController groupController = Get.find<GroupController>();
  final AuthenController authenController = Get.find<AuthenController>();
  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final String currentUserId = authenController.firebaseUser.value?.uid ?? '';

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
            String selectedCurrency = settingsController.selectedCurrency.value;

            return FutureBuilder<double>(
              future: expenseController.convertCurrency(
                  totalExpenses, 'USD', selectedCurrency),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                double convertedTotalExpenses = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                          'Total Expenses: ${convertedTotalExpenses.toStringAsFixed(2)} $selectedCurrency'),
                      FutureBuilder<double>(
                        future: expenseController.convertCurrency(
                            sharePerMember, 'USD', selectedCurrency),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          double convertedSharePerMember = snapshot.data!;
                          return Text(
                              'Each member should contribute: ${convertedSharePerMember.toStringAsFixed(2)} $selectedCurrency');
                        },
                      ),
                      SizedBox(height: 16),
                      Text('Expenses by User:'),
                      ...expenseController.userExpenses.entries.map((entry) {
                        return FutureBuilder<String>(
                          future: expenseController.getUserNameById(entry.key),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            String userName = snapshot.data!;
                            double convertedExpense = entry.value;
                            return Text(
                                '$userName\'s total: ${convertedExpense.toStringAsFixed(2)} $selectedCurrency');
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
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
                    return FutureBuilder<double>(
                      future: expenseController.convertCurrency(expense.amount,
                          'USD', settingsController.selectedCurrency.value),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        double convertedAmount = snapshot.data!;
                        return CheckboxListTile(
                          title: Text(expense.name),
                          subtitle: Text(
                              'Amount: ${convertedAmount.toStringAsFixed(2)} ${settingsController.selectedCurrency.value}\nAdded by: ${expense.userName}'),
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
