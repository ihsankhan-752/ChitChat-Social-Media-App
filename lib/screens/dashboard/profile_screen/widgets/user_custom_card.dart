import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/user_model.dart';
import '../../../../themes/colors.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/screen_navigations.dart';
import '../../minor_screen/chat_screen/chat_screen.dart';

class UserCustomCard extends StatelessWidget {
  final UserModel userModel;
  const UserCustomCard({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ListTile(
          leading: Container(
            height: MediaQuery.sizeOf(context).height * 0.08,
            width: MediaQuery.sizeOf(context).width * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: userModel.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => spinKit2,
              ),
            ),
          ),
          title: Text(
            userModel.username!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryWhite,
            ),
          ),
          subtitle: Text(
            userModel.bio!,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryWhite,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.message, color: AppColors.primaryWhite),
            onPressed: () {
              navigateToNext(
                  context,
                  ChatScreen(
                    userId: userModel.uid,
                    userBio: userModel.bio,
                    userImage: userModel.imageUrl,
                    username: userModel.username,
                  ));
            },
          ),
        ),
        Divider(color: AppColors.mainColor, thickness: 1, height: 0.3),
      ],
    );
  }
}
