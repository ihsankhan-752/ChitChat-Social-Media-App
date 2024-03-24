import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? email;
  final String? username;
  final String? bio;
  final List? followers;
  final List? following;
  final List? bookMarks;
  final String? uid;
  final String? imageUrl;

  UserModel({
    this.imageUrl,
    this.email,
    this.uid,
    this.following,
    this.followers,
    this.bio,
    this.username,
    this.bookMarks,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "bio": bio,
      "followers": followers,
      "following": following,
      "imageUrl": imageUrl,
      'bookMarks': bookMarks,
    };
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snap) {
    return UserModel(
        uid: snap['uid'],
        username: snap['username'],
        email: snap['email'],
        bio: snap['bio'],
        followers: snap['followers'],
        following: snap['following'],
        imageUrl: snap['imageUrl'],
        bookMarks: snap['bookMarks']);
  }
}
