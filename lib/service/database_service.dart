import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future saveUserData(
    String fullname,
    String email,
    String profilePicture,
  ) async {
    return await userCollection.doc(uid).set({
      'fullName': fullname,
      'email': email,
      'groups': [],
      'profilePic': profilePicture,
      'uid': uid,
    });
  }

  Future editUserData({
    required String fullname,
    required String profilePicture,
  }) async {
    return await userCollection.doc(uid).update({
      'fullName': fullname,
      'profilePic': profilePicture,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  Future createGroup({
    required String username,
    required String id,
    required String groupName,
  }) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': '${id}_$username',
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
    });

    await groupDocumentReference.update({
      'members': FieldValue.arrayUnion(['${id}_$username']),
      'groupId': groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      'groups':
          FieldValue.arrayUnion(['${groupDocumentReference.id}_$groupName']),
    });
  }

  getChats({required String grubId}) async {
    return groupCollection
        .doc(grubId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future getGruopAdmin({required String groupId}) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();

    return documentSnapshot['admin'];
  }

  getGroupMembers({required String groupId}) async {
    return groupCollection.doc(groupId).snapshots();
  }

  searchByName({required String groupName}) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      {required String groupName,
      required String groupId,
      required String userName}) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(
      {required String groupId,
      required String username,
      required String groupName}) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$username"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$username"])
      });
    }
  }

  sendMessage({
    required String groupId,
    required Map<String, dynamic> chatMessagesData,
  }) async {
    groupCollection.doc(groupId).collection('messages').add(chatMessagesData);
    groupCollection.doc(groupId).update({
      'recentMessage': chatMessagesData['message'],
      'recentMessageSender': chatMessagesData['sender'],
      'recentMessageTime': chatMessagesData['time'].toString(),
    });
  }
}
