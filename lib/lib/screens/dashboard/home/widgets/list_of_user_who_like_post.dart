import 'package:chitchat/lib/models/user_model.dart';
import 'package:chitchat/lib/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListOfUsersWhoLikePost extends StatelessWidget {
  final List<dynamic>? likes;
  const ListOfUsersWhoLikePost({Key? key, this.likes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Likes"),
      ),
      body: ListView.builder(
        itemCount: likes!.length,
        itemBuilder: (context, index) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(likes![index]).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                UserModel userModel = UserModel.fromDocumentSnapshot(snapshot.data!);
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userModel.imageUrl!),
                      ),
                      title: Text(
                        userModel.email!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        userModel.username!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Divider(endIndent: 20, thickness: 0.8, color: AppColors.mainColor, indent: 20),
                  ],
                );
              });
        },
      ),
    );
  }
}
