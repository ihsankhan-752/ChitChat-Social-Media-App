import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../themes/colors.dart';

class ProfileHeader extends StatelessWidget {
  final String userImage, username, bio;
  const ProfileHeader({super.key, required this.userImage, required this.username, required this.bio});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    return Column(
      children: [
        Center(
          child: Container(
            height: height * 0.1,
            width: width * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(userImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          username,
          style: GoogleFonts.poppins(
            color: AppColors.primaryWhite,
            fontSize: 18,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: height * 0.0015),
        Text(
          bio,
          style: GoogleFonts.poppins(
            color: AppColors.primaryWhite,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: height * 0.03),
      ],
    );
  }
}
