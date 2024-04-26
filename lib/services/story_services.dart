import 'dart:io';

import 'package:chitchat/models/story_model.dart';
import 'package:chitchat/providers/loading_controller.dart';
import 'package:chitchat/services/firebase_storage_services.dart';
import 'package:chitchat/widgets/custom_messanger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class StoryServices {
  Future<void> uploadStory({
    required BuildContext context,
    required File storyImage,
    required String storyTitle,
  }) async {
    if (storyImage == null) {
      showMessage(context, "Image required");
    } else {
      try {
        DocumentSnapshot snap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
        var storyId = const Uuid().v4();
        Provider.of<LoadingController>(context, listen: false).setLoading(true);
        String? storyImageUrl = await StorageServices().uploadPhoto(storyImage);
        StoryModel storyModel = StoryModel(
          userId: FirebaseAuth.instance.currentUser!.uid,
          storyId: storyId,
          storyImage: storyImageUrl,
          storyTitle: storyTitle,
          seenBy: [],
          uploadTime: DateTime.now(),
          likes: [],
          userImage: snap['imageUrl'],
          username: snap['username'],
        );
        await FirebaseFirestore.instance.collection('stories').doc(storyId).set(storyModel.toMap());
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showMessage(context, e.message!);
      }
    }
  }
}
