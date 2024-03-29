import 'package:chitchat/screens/dashboard/minor_screen/stories/upload_story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../themes/colors.dart';
import '../../../utils/screen_navigations.dart';
import '../minor_screen/stories/widgets/get_stories.dart';

class StoryCard extends StatefulWidget {
  const StoryCard({Key? key}) : super(key: key);

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  String? userImageUrl;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 3, color: AppColors.mainColor),
                ),
                child: Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('stories')
                          .where(
                            'uploadTime',
                            isGreaterThan: Timestamp.fromDate(
                              DateTime.now().subtract(
                                Duration(days: 1),
                              ),
                            ),
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        String currentUserId = FirebaseAuth.instance.currentUser!.uid;

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          bool currentUserUploadedStory = snapshot.data!.docs.any((story) => story['userId'] == currentUserId);
                          if (currentUserUploadedStory) {
                            var currentUserStory = snapshot.data!.docs.firstWhere((story) => story['userId'] == currentUserId);
                            userImageUrl = currentUserStory['storyImage'];
                          }
                        }

                        return Padding(
                          padding: EdgeInsets.all(1.5),
                          child: userImageUrl != null
                              ? CircleAvatar(
                                  backgroundColor: AppColors.primaryBlack,
                                  radius: 40,
                                  backgroundImage: NetworkImage(userImageUrl!),
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColors.primaryBlack,
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/guest.png"),
                                ),
                        );
                      },
                    ),
                    userImageUrl != null
                        ? SizedBox()
                        : Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                navigateToNext(context, UploadStoryScreen());
                              },
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primaryBlack),
                                  color: AppColors.skyColor,
                                ),
                                child: Icon(Icons.add, size: 15, color: AppColors.primaryWhite),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
          GetStories(),
        ],
      ),
    );
  }
}
