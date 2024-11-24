import 'package:bisplit/models/group_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth user = FirebaseAuth.instance;

  Query<Group> getUserGroupsQuery(String userId) {
    return firestore
        .collection('groups')
        .where('memberIds', arrayContains: userId)
        .withConverter<Group>(
          fromFirestore: (snapshot, _) => Group.fromDocument(snapshot),
          toFirestore: (group, _) => group.toMap(),
        );
  }

  Future<void> createGroup(String groupName, String adminId) async {
    Group newGroup = Group(
      id: '', // Firebase will assign an ID
      name: groupName,
      adminId: adminId,
      memberIds: [adminId],
    );
    await firestore.collection('groups').add(newGroup.toMap());
  }

  Future<void> inviteUserToGroup(String groupId, String userId) async {
    await firestore.collection('group_invitations').add({
      'groupId': groupId,
      'userId': userId,
      'status': 'pending',
    });
  }

  Future<void> acceptGroupInvitation(String invitationId) async {
    DocumentSnapshot<Map<String, dynamic>> invitation =
        await firestore.collection('group_invitations').doc(invitationId).get();
    if (invitation.exists) {
      String groupId = invitation.data()?['groupId'] ?? '';
      String userId = invitation.data()?['userId'] ?? '';

      await firestore.collection('groups').doc(groupId).update({
        'memberIds': FieldValue.arrayUnion([userId])
      });

      await firestore
          .collection('group_invitations')
          .doc(invitationId)
          .update({'status': 'accepted'});
    }
  }

  Future<void> rejectGroupInvitation(String invitationId) async {
    await firestore.collection('group_invitations').doc(invitationId).delete();
  }

  Future<String> lookupUserIdByEmail(String email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return '';
  }

  Query<Map<String, dynamic>> getPendingInvitationsQuery() {
    return firestore
        .collection('group_invitations')
        .where('userId', isEqualTo: user.currentUser!.uid)
        .where('status', isEqualTo: 'pending');
  }

  Stream<List<Map<String, String>>> getGroupMembersStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .asyncMap((groupDoc) async {
      List<String> memberIds =
          List<String>.from(groupDoc.data()?['memberIds'] ?? []);
      List<Map<String, String>> members = [];
      for (String memberId in memberIds) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await firestore.collection('users').doc(memberId).get();
        if (userDoc.exists) {
          members.add({
            'userId': memberId,
            'displayName': userDoc.data()?['displayName'] ?? '',
            'email': userDoc.data()?['email'] ?? '',
          });
        }
      }
      return members;
    });
  }

  Future<void> removeUserFromGroup(String groupId, String userId) async {
    QuerySnapshot expensesSnapshot = await firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .where('userId', isEqualTo: userId)
        .get();
    for (DocumentSnapshot expense in expensesSnapshot.docs) {
      await expense.reference.delete();
    }
    await firestore.collection('groups').doc(groupId).update({
      'memberIds': FieldValue.arrayRemove([userId])
    });
  }
}
