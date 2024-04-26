import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

import '../../../../consts/colors.dart';
import '../../../../consts/screen_navigations.dart';
import '../../../../consts/text_styles.dart';
import '../../../../models/user_model.dart';
import '../../profile_screen/other_user_profile_screen.dart';

class UserCustomCardFromSearch extends StatelessWidget {
  final TextEditingController searchController;
  const UserCustomCardFromSearch({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: MediaQuery.of(context).size.height * 0.75,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DelayedDisplay(
                slidingCurve: Curves.decelerate,
                slidingBeginOffset: const Offset(0.0, 0.35),
                fadingDuration: const Duration(milliseconds: 0),
                delay: const Duration(seconds: 0),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    UserModel userModel = UserModel.fromDocumentSnapshot(snapshot.data!.docs[index]);

                    if (searchController.text.isEmpty) {
                      return const SizedBox();
                    } else if (userModel.username.toString().toLowerCase().contains(searchController.text.toLowerCase())) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              navigateToNext(
                                context,
                                OtherUserProfileScreen(userModel: userModel),
                              );
                            },
                            leading: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.mainColor, width: 3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(userModel.imageUrl!, fit: BoxFit.cover),
                              ),
                            ),
                            title: Text(
                              userModel.username!,
                              style: AppTextStyle.mainHeading.copyWith(fontSize: 18),
                            ),
                            subtitle: Text(
                              userModel.bio!,
                              style: AppTextStyle.mainHeading.copyWith(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Divider(thickness: 1, height: 0.9, color: AppColors.mainColor),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No Post Found',
                  style: TextStyle(
                    color: AppColors.primaryWhite,
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
