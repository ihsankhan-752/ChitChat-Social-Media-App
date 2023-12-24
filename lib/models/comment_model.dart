import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String commentId;
  String userId;
  String postId;
  String userImage;
  String username;
  String comment;
  DateTime createdAt;
  List likes;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.postId,
    required this.userImage,
    required this.username,
    required this.comment,
    required this.createdAt,
    required this.likes,
  });

  factory CommentModel.fromDoc(DocumentSnapshot snap) {
    return CommentModel(
      commentId: snap['commentId'],
      userId: snap['userId'],
      postId: snap['postId'],
      username: snap['username'],
      userImage: snap['userImage'],
      comment: snap['comment'],
      createdAt: (snap['createdAt'].toDate()),
      likes: snap['likes'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'postId': postId,
      'userImage': userImage,
      'comment': comment,
      'username': username,
      'createdAt': createdAt,
      'likes': likes,
    };
  }
}
