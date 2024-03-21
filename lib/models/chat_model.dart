import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? lastMsg;

  DateTime? createdAt;

  List? userIds;

  ChatModel({this.createdAt, this.lastMsg, this.userIds});

  Map<String, dynamic> toMap() {
    return {
      'lastMsg': this.lastMsg,
      'createdAt': this.createdAt,
      'userIds': this.userIds,
    };
  }

  factory ChatModel.fromMap(DocumentSnapshot snap) {
    return ChatModel(
      lastMsg: snap['lastMsg'] as String,
      createdAt: (snap['createdAt'].toDate()),
      userIds: snap['userIds'] as List,
    );
  }
}
