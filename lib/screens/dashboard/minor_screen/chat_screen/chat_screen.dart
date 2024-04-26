import 'package:chitchat/models/user_model.dart';
import 'package:chitchat/providers/chat_controller.dart';
import 'package:chitchat/providers/image_controller.dart';
import 'package:chitchat/screens/dashboard/minor_screen/chat_screen/widgets/chat_card.dart';
import 'package:chitchat/screens/dashboard/minor_screen/chat_screen/widgets/chat_profile_header.dart';
import 'package:chitchat/screens/dashboard/minor_screen/chat_screen/widgets/image_sending_widget.dart';
import 'package:chitchat/screens/dashboard/minor_screen/chat_screen/widgets/text_sending_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../consts/colors.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userModel;

  const ChatScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();
  bool isLoading = false;
  String docId = '';
  String myId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    if (myId.hashCode > widget.userModel.uid.hashCode) {
      docId = myId + widget.userModel.uid!;
    } else {
      docId = widget.userModel.uid! + myId;
    }
    super.initState();
    _loadMessages();
  }

  _loadMessages() async {
    await Provider.of<ChatController>(context, listen: false).getAllMessages(docId);
  }

  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final messageController = Provider.of<ChatController>(context).messageModel;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: ChatProfileHeader(userModel: widget.userModel),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (imageController.selectedImage != null)
            ImageSendingWidget(
              imageController: imageController,
              userId: widget.userModel.uid!,
              docId: docId,
            ),
          Expanded(
            child: messageController.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Text(
                        "No Chat Found!",
                        style: GoogleFonts.acme(
                          fontSize: 20,
                          color: AppColors.primaryWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: messageController.length,
                    itemBuilder: (context, index) {
                      return ChatCard(messageController: messageController[index]);
                    },
                  ),
          ),
          if (imageController.selectedImage == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextSendingWidget(
                imageController: imageController,
                msgController: msgController,
                userId: widget.userModel.uid!,
                docId: docId,
              ),
            ),
        ],
      ),
    );
  }
}
