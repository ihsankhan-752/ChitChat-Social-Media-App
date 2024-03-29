import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  String? storyId;
  String? userId;
  String? storyImage;
  String? storyTitle;
  String? userImage;
  String? username;
  List? seenBy;
  DateTime? uploadTime;
  List? likes;

  StoryModel({
    this.userId,
    this.seenBy,
    this.likes,
    this.storyId,
    this.userImage,
    this.username,
    this.storyImage,
    this.storyTitle,
    this.uploadTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'storyId': this.storyId,
      'userId': this.userId,
      'storyImage': this.storyImage,
      'storyTitle': this.storyTitle,
      'seenBy': this.seenBy,
      'uploadTime': this.uploadTime,
      'likes': this.likes,
      'username': this.username,
      'userImage': this.userImage,
    };
  }

  factory StoryModel.fromMap(DocumentSnapshot snap) {
    return StoryModel(
      storyId: snap['storyId'] as String,
      userId: snap['userId'] as String,
      storyImage: snap['storyImage'] as String,
      storyTitle: snap['storyTitle'] as String,
      seenBy: snap['seenBy'] as List,
      uploadTime: (snap['uploadTime'].toDate()),
      likes: snap['likes'] as List,
      username: snap['username'] as String,
      userImage: snap['userImage'] as String,
    );
  }
}
