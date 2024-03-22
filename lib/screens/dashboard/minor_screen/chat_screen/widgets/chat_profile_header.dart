import 'package:flutter/material.dart';

import '../../../../../models/user_model.dart';
import '../../../../../themes/colors.dart';

class ChatProfileHeader extends StatelessWidget {
  final UserModel userModel;
  const ChatProfileHeader({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(userModel.imageUrl!),
      ),
      title: Text(
        userModel.username!,
        style: TextStyle(color: AppColors.primaryWhite, fontSize: 14),
      ),
      subtitle: Text(
        userModel.bio!,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
