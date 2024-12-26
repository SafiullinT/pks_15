import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pks_14/models/message.dart';
import 'package:flutter/cupertino.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //SEND
  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    await _fireStore
        .collection('conversations')
        .doc(currentUserId)
        .set({
      receiverId: timestamp
    }, SetOptions(merge: true));

    await _fireStore
        .collection('conversations')
        .doc(receiverId)
        .set({
      currentUserId: timestamp
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> getUsersWithConversations() {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    return _fireStore
        .collection('conversations')
        .doc(currentUserId)
        .snapshots();
  }

  Future<List<DocumentSnapshot>> getUsersFromConversations(List<String> userIds) async {
    List<DocumentSnapshot> users = [];
    for (String userId in userIds) {
      DocumentSnapshot userDoc = await _fireStore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        users.add(userDoc);
      }
    }
    return users;
  }


  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

}