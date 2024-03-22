import 'package:chitchat/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../themes/colors.dart';

class ChatCard extends StatelessWidget {
  final MessageModel messageController;
  const ChatCard({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          messageController.senderId == FirebaseAuth.instance.currentUser!.uid ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 05, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: messageController.senderId == FirebaseAuth.instance.currentUser!.uid
                ? AppColors.primaryColor
                : const Color(0xff214160),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: messageController.msg == ""
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    child: Image.network(messageController.image!, fit: BoxFit.cover))
                : Text(
                    messageController.msg!,
                    style: TextStyle(
                      color: AppColors.primaryWhite,
                      fontSize: 14,
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
