// ignore_for_file: use_build_context_synchronously

import 'package:chitchat/screens/dashboard/profile_screen/widgets/custom_drawer.dart';
import 'package:chitchat/screens/dashboard/profile_screen/widgets/profile_header.dart';
import 'package:chitchat/screens/dashboard/profile_screen/widgets/show_user_followers.dart';
import 'package:chitchat/screens/dashboard/profile_screen/widgets/show_user_following.dart';
import 'package:chitchat/screens/dashboard/profile_screen/widgets/show_user_posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../providers/post_controller.dart';
import '../../../providers/user_controller.dart';
import '../../../themes/colors.dart';
import '../../../widgets/buttons.dart';

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
      drawer: CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
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
            const SizedBox(height: 20),
            ProfileHeader(
              userImage: userController.userModel.imageUrl ?? "",
              username: userController.userModel.username ?? "",
              bio: userController.userModel.bio ?? "",
            ),
            SizedBox(height: height * 0.03),
            Container(
              height: height * 0.07,
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
            SizedBox(height: 10),
            if (currentIndex == 0) ShowUserPost(postController: postController),
            if (currentIndex == 1) ShowUserFollowers(),
            if (currentIndex == 2) ShowUserFollowing(),
          ],
        ),
      ),
    );
  }
}
