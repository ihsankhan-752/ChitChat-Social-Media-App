import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../models/story_model.dart';

class GetStories extends StatelessWidget {
  const GetStories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("stories")
            .where('uploadTime',
                isGreaterThan: Timestamp.fromDate(
                  DateTime.now().subtract(Duration(days: 1))
                ))
            .orderBy('uploadTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const SizedBox();
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              StoryModel storyModel = StoryModel.fromMap(snapshot.data!.docs[index]);
              return storyModel.userId == FirebaseAuth.instance.currentUser!.uid
                  ? SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            // navigateToNext(
                            //   context,
                            //   StoryFullScreen(
                            //     data: data,
                            //   ),
                            // );
                            // await FirebaseFirestore.instance.collection("stories").doc(data.id).update({
                            //   "userCheckedList": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                            // });
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(storyModel.userImage!),
                          ),
                        ),
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}
