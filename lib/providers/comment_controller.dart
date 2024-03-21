import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/comment_model.dart';

class CommentController extends ChangeNotifier {
  List<CommentModel> _commentModel = [];
  List<CommentModel> get commentModel => _commentModel;

  Future<void> getAllComments(String postId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen(
      (snap) {
        _commentModel.clear();
        for (var comment in snap.docs) {
          CommentModel _comments = CommentModel.fromDoc(comment);
          _commentModel.add(_comments);
        }
        notifyListeners();
      },
    );
  }
}
