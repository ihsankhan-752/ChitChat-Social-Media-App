import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/notification_model.dart';
import '../../themes/colors.dart';
import '../../utils/text_styles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Notifications",
            style: AppTextStyle.mainHeading.copyWith(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('notification')
              .where('toUserId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No Notifications Found",
                  style: AppTextStyle.mainHeading.copyWith(
                    color: Colors.blueGrey,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                NotificationModel notificationModel =
                    NotificationModel.fromDoc(snapshot.data!.docs[index]);
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(notificationModel.userImage),
                      ),
                      title: Text(
                        notificationModel.title,
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        timeago.format(notificationModel.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Divider(thickness: 0.7, color: Colors.blueGrey),
                  ],
                );
              },
            );
          },
        ));
  }
}
