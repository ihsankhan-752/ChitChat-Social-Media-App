import 'package:chitchat/screens/dashboard/profile_screen/widgets/user_custom_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../models/user_model.dart';
import '../../../../providers/user_controller.dart';
import '../../../../themes/colors.dart';

class ShowUserFollowers extends StatelessWidget {
  const ShowUserFollowers({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    return userController.userModel.followers!.isEmpty
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
          );
  }
}
