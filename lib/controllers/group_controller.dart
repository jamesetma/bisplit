import 'package:bisplit/models/group_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .where('status', isEqualTo: 'pending');
  }
}
