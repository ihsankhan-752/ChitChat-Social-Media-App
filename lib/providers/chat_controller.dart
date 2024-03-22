import 'package:chitchat/models/message_model.dart';
import 'package:chitchat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';

class ChatController extends ChangeNotifier {
  List<ChatModel> _chatModel = [];
  List<ChatModel> get chatModel => _chatModel;

  List<MessageModel> _messageModel = [];
  List<MessageModel> get messageModel => _messageModel;

  List<UserModel> _userModel = [];
  List<UserModel> get userModel => _userModel;

  Future<void> getAllMessages(String docId) async {
    await FirebaseFirestore.instance
        .collection('chat')
        .doc(docId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((chatSnap) {
      _messageModel.clear();

      for (var messages in chatSnap.docs) {
        MessageModel _newMsgModel = MessageModel.fromMap(messages);
        _messageModel.add(_newMsgModel);
      }
      notifyListeners();
    });
  }

  Future<void> getAllUsers() async {
    await FirebaseFirestore.instance
        .collection('chat')
        .where('userIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen(
      (snap) async {
        _chatModel.clear();
        _userModel.clear();

        for (var chatSnap in snap.docs) {
          ChatModel _newChat = ChatModel.fromMap(chatSnap);
          _chatModel.add(_newChat);

          getUserById() {
            if (chatSnap['userIds'][0] == FirebaseAuth.instance.currentUser!.uid) {
              return chatSnap['userIds'][1];
            } else {
              return chatSnap['userIds'][0];
            }
          }

          DocumentSnapshot _userSnap = await FirebaseFirestore.instance.collection("users").doc(getUserById()).get();
          UserModel _newUser = UserModel.fromDocumentSnapshot(_userSnap);
          _userModel.add(_newUser);
        }
        notifyListeners();
      },
    );
  }
}
