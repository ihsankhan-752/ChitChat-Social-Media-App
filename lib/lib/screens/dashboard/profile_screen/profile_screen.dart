// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/lib/models/user_model.dart';
import 'package:chitchat/lib/providers/post_controller.dart';
import 'package:chitchat/lib/providers/user_controller.dart';
import 'package:chitchat/lib/screens/dashboard/profile_screen/widgets/profile_header.dart';
import 'package:chitchat/lib/screens/dashboard/profile_screen/widgets/user_custom_card.dart';
import 'package:chitchat/lib/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../utils/constants.dart';
import '../../../widgets/buttons.dart';
import '../../auth/login_screen.dart';
import '../widgets/video_player_for_display_video.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentIndex = 0;
  @override
  void initState() {
    Provider.of<PostController>(context, listen: false)
        .getAllMyPosts(context: context, userId: FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postController = Provider.of<PostController>(context);
    final userController = Provider.of<UserController>(context);
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: AppColors.primaryWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (_) {
                      return SimpleDialog(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Center(
                            child: Text(
                          "Logout",
                          style: TextStyle(
                            color: AppColors.primaryWhite,
                          ),
                        )),
                        children: [
                          const SizedBox(height: 10),
                          Center(
                              child: Text(
                            "Are you sure, you want to log out?",
                            style: TextStyle(
                              color: AppColors.primaryWhite,
                            ),
                          )),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff283648),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff2381E3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      )),
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text("Logout")),
                            ],
                          )
                        ],
                      );
                    });
              },
              child: const Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ProfileHeader(
              userImage: userController.userModel.imageUrl ?? "",
              username: userController.userModel.username ?? "",
              bio: userController.userModel.bio ?? "",
            ),
            SizedBox(height: height * 0.03),
            Container(
              height: height * 0.06,
              width: width * 0.8,
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
                      title: userController.userModel.followers!.length.toString(),
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
                      title: userController.userModel.following!.length.toString(),
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
            if (currentIndex == 0)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.height * 0.5,
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: postController.myPostList.length,
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 7 == 0) ? 2 : 1,
                    (index % 7 == 0) ? 2 : 1,
                  ),
                  itemBuilder: (context, index) {
                    return postController.myPostList[index].videoUrl == ""
                        ? CachedNetworkImage(
                            imageUrl: postController.myPostList[index].postImages[0],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => spinKit2,
                          )
                        : SizedBox(
                            height: 200,
                            child: VideoPlayerForDisplayVideo(
                              path: postController.myPostList[index].videoUrl,
                            ),
                          );
                  },
                ),
              ),
            if (currentIndex == 1)
              userController.userModel.followers!.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        "No User Found",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: height * 0.6,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where(FieldPath.documentId, whereIn: userController.userModel.followers)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
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
              userController.userModel.following!.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        "No User Found",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: height * 0.6,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where(FieldPath.documentId, whereIn: userController.userModel.following)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
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
