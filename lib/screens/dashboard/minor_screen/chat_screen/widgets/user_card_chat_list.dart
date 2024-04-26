import 'package:chitchat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../consts/colors.dart';
import '../../../../../consts/screen_navigations.dart';
import '../../../../../models/chat_model.dart';
import '../chat_screen.dart';

class UserCardChatList extends StatelessWidget {
  final UserModel userModel;
  final ChatModel chatModel;
  const UserCardChatList({super.key, required this.userModel, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        navigateToNext(
          context,
          ChatScreen(userModel: userModel),
        );
      },
      contentPadding: const EdgeInsets.only(right: 20),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(userModel.imageUrl!),
      ),
      title: Text(
        userModel.username!,
        style: GoogleFonts.poppins(
          color: AppColors.primaryWhite,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      subtitle: chatModel.lastMsg == ""
          ? const Text(
              "send an Image",
              style: TextStyle(
                color: Colors.grey,
              ),
            )
          : Text(
              chatModel.lastMsg!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
      trailing: Text(
        timeago.format(
          chatModel.createdAt!,
        ),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 10,
        ),
      ),
    );
    ;
  }
}
