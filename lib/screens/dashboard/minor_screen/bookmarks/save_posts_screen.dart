import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/models/user_model.dart';
import 'package:chitchat/utils/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home/widgets/custom_post_card.dart';

class SavePostsScreen extends StatelessWidget {
  const SavePostsScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Save Posts"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            UserModel userModel = UserModel.fromDocumentSnapshot(snapshot.data!);

            List ids = List.from(userModel.bookMarks!);

            if (ids.isEmpty) {
              return Center(
                child: Text(
                  "No Save Post Found !",
                  style: AppTextStyle.mainHeading.copyWith(
                    fontSize: 20,
                  ),
                ),
              );
            }

            return Center(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts').where(FieldPath.documentId, whereIn: ids).snapshots(),
                builder: (context, snap2) {
                  if (!snap2.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snap2.data!.docs.length,
                    itemBuilder: (context, index) {
                      PostModel postModel = PostModel.fromDoc(snap2.data!.docs[index]);

                      return CustomPostCard(postModel: postModel);
                    },
                  );
                },
              ),
            );
          }),
    );
  }
}
