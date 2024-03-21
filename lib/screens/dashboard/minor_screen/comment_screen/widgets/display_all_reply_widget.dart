import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../themes/colors.dart';

class DisplayAllReplayWidget extends StatelessWidget {
  final String postId;
  final String commentId;
  const DisplayAllReplayWidget({super.key, required this.postId, required this.commentId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .collection('reply')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text(''),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }
        return Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 3, right: 15),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: AppColors.primaryColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                        ),
                        context: context,
                        builder: (_) {
                          return SizedBox(
                            height: 400,
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(data['userImage']),
                                      ),
                                      title: Text(
                                        data['username'],
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      subtitle: Text(
                                        data['text'],
                                        style: TextStyle(
                                          color: AppColors.primaryWhite,
                                          fontSize: 13,
                                        ),
                                      ),
                                      trailing: Text(
                                        timeago.format(data['createdAt'].toDate()),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    Divider(thickness: 0.5, height: 0.2, color: Colors.grey),
                                  ],
                                );
                              },
                            ),
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2, left: 50),
                    child: Text(
                      "------view all ${snapshot.data!.docs.length} reply",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
