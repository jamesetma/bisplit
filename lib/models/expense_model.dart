import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String groupId;
  final String userId;
  final String userName;
  final String name;
  final double amount;
  final DateTime date;
  final bool isCompleted;

  Expense({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.name,
    required this.amount,
    required this.date,
    this.isCompleted = false,
  });

  factory Expense.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Expense(
      id: doc.id,
      groupId: data['groupId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
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
      'isCompleted': isCompleted,
    };
  }
}
