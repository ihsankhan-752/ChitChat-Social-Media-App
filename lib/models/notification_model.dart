import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String fromUserId;
  String toUserId;
  String docId;
  String title;
  String userImage;
  DateTime createdAt;

  NotificationModel({
    required this.fromUserId,
    required this.toUserId,
    required this.title,
    required this.createdAt,
    required this.docId,
    required this.userImage,
  });

  factory NotificationModel.fromDoc(DocumentSnapshot snap) {
    return NotificationModel(
        fromUserId: snap['fromUserId'],
        toUserId: snap['toUserId'],
        title: snap['title'],
        createdAt: (snap['createdAt'].toDate()),
        docId: snap['docId'],
        userImage: snap['userImage']);
  }
  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'title': title,
      'docId': docId,
      'createdAt': createdAt,
      'userImage': userImage,
    };
  }
}
