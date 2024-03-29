import 'package:chitchat/screens/dashboard/profile_screen/change_password.dart';
import 'package:chitchat/screens/dashboard/profile_screen/edit_profile_screen.dart';
import 'package:chitchat/screens/dashboard/profile_screen/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/user_controller.dart';
import '../../../../themes/colors.dart';
import '../../../../utils/screen_navigations.dart';
import '../../../../widgets/dialogs.dart';
import '../../minor_screen/bookmarks/save_posts_screen.dart';
import 'custom_list_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.3,
            width: MediaQuery.sizeOf(context).width,
            color: AppColors.primaryColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: ProfileHeader(
                  userImage: userController.userModel.imageUrl ?? "",
                  username: userController.userModel.username ?? "",
                  bio: userController.userModel.bio ?? "",
                ),
              ),
            ),
          ),
          CustomListTile(
            onPressed: () {
              Navigator.pop(context);
            },
            title: "My Profile",
            icon: Icons.person,
          ),
          Divider(height: 0.1),
          CustomListTile(
            onPressed: () {
              navigateToNext(context, EditProfileScreen());
            },
            title: "Edit Profile",
            icon: Icons.edit,
          ),
          Divider(height: 0.1),
          CustomListTile(
            onPressed: () {
              navigateToNext(context, SavePostsScreen());
            },
            title: "Save Posts",
            icon: Icons.bookmark,
          ),
          Divider(height: 0.1),
          CustomListTile(
            onPressed: () {
              navigateToNext(context, ChangePasswordScreen());
            },
            title: "Change Password",
            icon: Icons.lock_person_outlined,
          ),
          Divider(height: 0.1),
          CustomListTile(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return logOutDialog(context);
                  });
            },
            title: "LogOut",
            image: 'assets/images/logOut.png',
            isImage: true,
          ),
        ],
      ),
    );
  }
}
