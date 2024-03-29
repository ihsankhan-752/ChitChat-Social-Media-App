import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../models/notification_model.dart';
import '../../../themes/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/text_styles.dart';

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
              .where('toUserId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                NotificationModel notificationModel = NotificationModel.fromDoc(snapshot.data!.docs[index]);
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        height: 45,
                        width: 45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: notificationModel.userImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => spinKit2,
                          ),
                        ),
                      ),
                      title: Text(
                        notificationModel.title,
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        timeago.format(notificationModel.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Divider(thickness: 0.1, color: Colors.blueGrey),
                  ],
                );
              },
            );
          },
        ));
  }
}
