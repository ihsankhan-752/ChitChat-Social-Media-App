// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/consts/screen_navigations.dart';
import 'package:chitchat/screens/dashboard/minor_screen/chat_screen/chat_screen.dart';
import 'package:chitchat/screens/dashboard/profile_screen/widgets/profile_header.dart';
import 'package:chitchat/screens/dashboard/profile_screen/widgets/user_custom_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../consts/colors.dart';
import '../../../models/user_model.dart';
import '../../../providers/post_controller.dart';
import '../../../providers/user_controller.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/loading_indicators.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final UserModel? userModel;
  const OtherUserProfileScreen({super.key, this.userModel});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    Provider.of<PostController>(context, listen: false).getAllMyPosts(context: context, userId: widget.userModel!.uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postController = Provider.of<PostController>(context);
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PrimaryButton(
            height: 45,
            width: 100,
            btnColor: AppColors.primaryColor,
            onPressed: () {
              navigateToNext(context, ChatScreen(userModel: widget.userModel!));
            },
            title: "Chat",
          ),
          SizedBox(width: 15),
          PrimaryButton(
            height: 45,
            width: 100,
            btnColor: AppColors.primaryColor,
            onPressed: () async {
              await userController.followAndUnFollowUser(context, widget.userModel!.uid!);
              Navigator.pop(context);
            },
            title: widget.userModel!.followers!.contains(FirebaseAuth.instance.currentUser!.uid) ? "Unfollow" : "Follow",
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: AppColors.primaryWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              height: height * 0.3,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(widget.userModel!.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  UserModel userModel = UserModel.fromDocumentSnapshot(snapshot.data!);
                  return Column(
                    children: [
                      ProfileHeader(
                        userImage: userModel.imageUrl!,
                        username: userModel.username!,
                        bio: userModel.bio!,
                      ),
                      SizedBox(height: height * 0.03),
                      Container(
                        height: height * 0.06,
                        width: width * 0.95,
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProfileScreenButton(
                                title: postController.myPostList.length.toString(),
                                subTitle: "Post",
                                titleColor: currentIndex == 0 ? AppColors.primaryWhite : AppColors.primaryBlack,
                                subTitleColor: currentIndex == 0 ? AppColors.primaryWhite : AppColors.primaryBlack,
                                btnColor: currentIndex == 0 ? AppColors.mainColor : AppColors.primaryWhite,
                                onPressed: () {
                                  setState(() {
                                    currentIndex = 0;
                                  });
                                }),
                            ProfileScreenButton(
                                titleColor: currentIndex == 1 ? AppColors.primaryWhite : AppColors.primaryBlack,
                                subTitleColor: currentIndex == 1 ? AppColors.primaryWhite : AppColors.primaryBlack,
                                title: userModel.followers != null ? userModel.followers!.length.toString() : "0",
                                subTitle: "Followers",
                                btnColor: currentIndex == 1 ? AppColors.mainColor : AppColors.primaryWhite,
                                onPressed: () {
                                  setState(() {
                                    currentIndex = 1;
                                  });
                                }),
                            ProfileScreenButton(
                                titleColor: currentIndex == 2 ? AppColors.primaryWhite : AppColors.primaryBlack,
                                subTitleColor: currentIndex == 2 ? AppColors.primaryWhite : AppColors.primaryBlack,
                                title: userModel.following != null ? userModel.following!.length.toString() : "0",
                                subTitle: "Following",
                                btnColor: currentIndex == 2 ? AppColors.mainColor : AppColors.primaryWhite,
                                onPressed: () {
                                  setState(() {
                                    currentIndex = 2;
                                  });
                                }),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (currentIndex == 0)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: postController.myPostList.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: postController.myPostList[index].postImages[0],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => spinKit2,
                    );
                  },
                ),
              ),
            if (currentIndex == 1)
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.6,
                child: StreamBuilder(
                  stream: widget.userModel!.followers != null && widget.userModel!.followers!.isNotEmpty
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .where(FieldPath.documentId, whereIn: widget.userModel!.followers)
                          .snapshots()
                      : Stream.empty(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Center(
                          child: Text(
                            "You are not Following Any One",
                            style: GoogleFonts.poppins(
                              color: AppColors.mainColor,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        UserModel userModel = UserModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
                        return UserCustomCard(userModel: userModel);
                      },
                    );
                  },
                ),
              ),
            if (currentIndex == 2)
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.6,
                child: StreamBuilder(
                  stream: widget.userModel!.following != null && widget.userModel!.following!.isNotEmpty
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .where(FieldPath.documentId, whereIn: widget.userModel!.following)
                          .snapshots()
                      : Stream.empty(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Center(
                          child: Text(
                            "You are not Following Any One",
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryWhite,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        UserModel userModel = UserModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
                        return UserCustomCard(userModel: userModel);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
