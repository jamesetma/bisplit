import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  String groupId;
  String userId;
  String userName;
  String name;
  double amount;
  DateTime date;
  bool isCompleted; // New field

  Expense({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.name,
    required this.amount,
    required this.date,
    this.isCompleted = false, // New field
  });

  factory Expense.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Expense(
      id: doc.id,
      groupId: doc.data()?['groupId'] ?? '',
      userId: doc.data()?['userId'] ?? '',
      userName: doc.data()?['userName'] ?? '',
      name: doc.data()?['name'] ?? '',
      amount: doc.data()?['amount']?.toDouble() ?? 0.0,
      date: (doc.data()?['date'] as Timestamp).toDate(),
      isCompleted: doc.data()?['isCompleted'] ?? false, // New field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'userId': userId,
      'userName': userName,
      'name': name,
      'amount': amount,
      'date': date,
      'isCompleted': isCompleted, // New field
    };
  }
}
