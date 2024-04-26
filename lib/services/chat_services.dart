import 'package:chitchat/models/chat_model.dart';
import 'package:chitchat/models/message_model.dart';
import 'package:chitchat/providers/loading_controller.dart';
import 'package:chitchat/widgets/custom_messanger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChatServices {
  Future<void> sendMsg({
    BuildContext? context,
    String? imageUrl,
    String? userId,
    String? docId,
    String? msg,
  }) async {
    try {
      Provider.of<LoadingController>(context!, listen: false).setLoading(true);

      await Future.delayed(Duration.zero);

      DocumentSnapshot userSnap =
          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection("chat").doc(docId).get();
      ChatModel chatModel = ChatModel(
        lastMsg: msg,
        userIds: [FirebaseAuth.instance.currentUser!.uid, userId],
        createdAt: DateTime.now(),
      );

      MessageModel messageModel = MessageModel(
        msg: msg,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        userImage: userSnap['imageUrl'],
        username: userSnap['username'],
        createdAt: DateTime.now(),
        image: imageUrl,
      );

      if (snap.exists) {
        await FirebaseFirestore.instance.collection("chat").doc(docId).update({
          "lastMsg": msg,
          "createdAt": DateTime.now(),
        });
      } else {
        await FirebaseFirestore.instance.collection("chat").doc(docId).set(chatModel.toMap());
      }
      await FirebaseFirestore.instance.collection("chat").doc(docId).collection("messages").add(messageModel.toMap());
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
    } on FirebaseException catch (e) {
      Provider.of<LoadingController>(context!, listen: false).setLoading(false);
      showMessage(context, e.message!);
    }
  }
}
