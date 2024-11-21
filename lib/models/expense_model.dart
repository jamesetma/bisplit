import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  String groupId;
  String userId;
  String name;
  double amount;
  DateTime date;

  Expense({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.name,
    required this.amount,
    required this.date,
  });

  factory Expense.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Expense(
      id: doc.id,
      groupId: doc['groupId'],
      userId: doc['userId'],
      name: doc['name'],
      amount: doc['amount'],
      date: (doc['date']).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'userId': userId,
      'name': name,
      'amount': amount,
      'date': date,
    };
  }
}
