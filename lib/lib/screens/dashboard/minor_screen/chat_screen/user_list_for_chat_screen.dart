import 'package:chitchat/lib/models/user_model.dart';
import 'package:chitchat/lib/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../utils/screen_navigations.dart';
import '../../../../widgets/text_input.dart';
import 'chat_screen.dart';

class UserListForChatScreen extends StatefulWidget {
  const UserListForChatScreen({Key? key}) : super(key: key);

  @override
  State<UserListForChatScreen> createState() => _UserListForChatScreenState();
}

class _UserListForChatScreenState extends State<UserListForChatScreen> {
  TextEditingController searchController = TextEditingController();
  var userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInputForSearch(
                controller: searchController,
                onChanged: (v) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chat")
                      .where('userIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("You Have No Chat Yet"),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          getUserById() {
                            List<dynamic> users = snapshot.data!.docs[index]['userIds'];
                            if (users[0] == FirebaseAuth.instance.currentUser!.uid) {
                              return users[1];
                            } else {
                              return users[0];
                            }
                          }

                          return SizedBox(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection("users").doc(getUserById()).snapshots(),
                              builder: (context, userSnap) {
                                if (userSnap.hasData) {
                                  UserModel userModel = UserModel.fromDocumentSnapshot(userSnap.data!);

                                  if (searchController.text.isEmpty ||
                                      userModel.username
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchController.text.toLowerCase())) {
                                    return Card(
                                      color: AppColors.primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: ListTile(
                                          onTap: () {
                                            navigateToNext(
                                                context,
                                                ChatScreen(
                                                  userBio: userModel.bio,
                                                  userId: userModel.uid,
                                                  userImage: userModel.imageUrl,
                                                  username: userModel.username,
                                                ));
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
                                          subtitle: Row(
                                            children: [
                                              snapshot.data!.docs[index]['lastMsg'] == ""
                                                  ? const Text(
                                                      "send an Image",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  : Text(
                                                      snapshot.data!.docs[index]['lastMsg'],
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                      ),
                                                    )
                                            ],
                                          ),
                                          trailing: Text(
                                            timeago.format(
                                              snapshot.data!.docs[index]['createdAt'].toDate(),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
