import 'package:chitchat/providers/chat_controller.dart';
import 'package:chitchat/screens/dashboard/minor_screen/chat_screen/widgets/user_card_chat_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../themes/colors.dart';
import '../../../../widgets/text_input.dart';

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
    _loadUsers();
  }

  _loadUsers() async {
    await Provider.of<ChatController>(context, listen: false).getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<ChatController>(context).userModel;
    final chatController = Provider.of<ChatController>(context).chatModel;

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
              userController.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.35),
                      child: Center(
                        child: Text(
                          "No User Found!",
                          style: TextStyle(
                            color: AppColors.primaryWhite,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.sizeOf(context).height * .7,
                      child: ListView.builder(
                        itemCount: userController.length,
                        itemBuilder: (context, index) {
                          return UserCardChatList(userModel: userController[index], chatModel: chatController[index]);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
