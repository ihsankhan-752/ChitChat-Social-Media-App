import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String uid;
  String postId;
  String userName;
  String userImage;
  List postImages;
  String postTitle;
  String videoUrl;
  DateTime createdAt;
  List likes;

  PostModel({
    required this.uid,
    required this.postId,
    required this.userName,
    required this.userImage,
    required this.postImages,
    required this.postTitle,
    required this.videoUrl,
    required this.createdAt,
    required this.likes,
  });

  factory PostModel.fromDoc(DocumentSnapshot snap) {
    return PostModel(
      uid: snap['uid'],
      postId: snap['postId'],
      userName: snap['username'],
      userImage: snap['userImage'],
      postImages: snap['postImages'],
      postTitle: snap['postTitle'],
      videoUrl: snap['videoUrl'],
      createdAt: (snap['createdAt'].toDate()),
      likes: snap['likes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'postId': postId,
      'username': userName,
      'userImage': userImage,
      'postImages': postImages,
      'postTitle': postTitle,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
      'likes': likes,
    };
  }
}
