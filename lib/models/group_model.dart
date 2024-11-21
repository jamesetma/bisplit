import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String id;
  String name;
  String adminId;
  List<String> memberIds;

  Group(
      {required this.id,
      required this.name,
      required this.adminId,
      required this.memberIds});

  factory Group.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Group(
      id: doc.id,
      name: doc['name'],
      adminId: doc['adminId'],
      memberIds: List<String>.from(doc['memberIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'adminId': adminId,
      'memberIds': memberIds,
    };
  }
}
