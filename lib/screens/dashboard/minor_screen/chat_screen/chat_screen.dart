// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chitchat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/firebase_storage_services.dart';
import '../../../../services/firestore_services.dart';
import '../../../../themes/colors.dart';
import '../../../../utils/custom_messanger.dart';
import '../../widgets/message_text_input.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userModel;
  // final String? username;
  // final String? userImage;
  // final String? userBio;
  // final String? userId;
  const ChatScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();
  bool isLoading = false;
  String docId = '';
  File? selectedImage;
  String myId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    if (myId.hashCode > widget.userModel.uid.hashCode) {
      docId = myId + widget.userModel.uid!;
    } else {
      docId = widget.userModel.uid! + myId;
    }
    super.initState();
  }

  uploadImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.userModel.imageUrl!),
          ),
          title: Text(
            widget.userModel.username!,
            style: TextStyle(color: AppColors.primaryWhite, fontSize: 14),
          ),
          subtitle: Text(
            widget.userModel.bio!,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            selectedImage == null
                ? const SizedBox()
                : Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: double.infinity,
                        color: Colors.red,
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(AppColors.primaryBlack.withOpacity(0.5), BlendMode.srcATop),
                            child: Image.file(File(selectedImage!.path), fit: BoxFit.cover)),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              String imageUrl = await StorageServices().uploadPhoto(selectedImage);
                              await fireStoreServices().userChat(
                                context: context,
                                myId: myId,
                                userId: widget.userModel.uid!,
                                docId: docId,
                                msg: msgController.text.isEmpty ? "" : msgController.text,
                                imageUrl: imageUrl.isEmpty ? "" : imageUrl,
                              );
                              setState(() {
                                isLoading = false;
                                selectedImage = null;
                              });
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              showMessage(context, e.toString());
                            }
                          },
                          child: Container(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: isLoading
                                  ? const Center(
                                      child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: CircularProgressIndicator(),
                                    ))
                                  : const Text(
                                      "send",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.72,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chat")
                    .doc(docId)
                    .collection("messages")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Chat Found !!",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var userData = snapshot.data!.docs[index];
                      return Row(
                        mainAxisAlignment: userData['senderId'] == myId ? MainAxisAlignment.start : MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 05, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: userData['senderId'] == myId ? AppColors.primaryColor : const Color(0xff214160),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: userData['msg'] == ""
                                  ? SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.height * 0.2,
                                      child: Image.network(userData['image'], fit: BoxFit.cover))
                                  : Text(
                                      userData['msg'],
                                      style: TextStyle(
                                        color: AppColors.primaryWhite,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MessageTextInput(
                picSelectionTapped: () {
                  showModalBottomSheet(
                      backgroundColor: AppColors.primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      ),
                      context: context,
                      builder: (_) {
                        return SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  uploadImage(ImageSource.gallery);
                                  Navigator.of(context).pop();
                                },
                                title: Text(
                                  "Upload From Gallery",
                                  style: TextStyle(color: AppColors.primaryWhite),
                                ),
                                trailing: Icon(Icons.photo, color: AppColors.primaryWhite),
                              ),
                              Divider(thickness: 1, color: AppColors.mainColor, height: 0.3),
                              ListTile(
                                onTap: () {
                                  uploadImage(ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                                title: Text(
                                  "Upload From Camera",
                                  style: TextStyle(color: AppColors.primaryWhite),
                                ),
                                trailing: Icon(Icons.camera, color: AppColors.primaryWhite),
                              ),
                              Divider(thickness: 1, color: AppColors.mainColor, height: 0.3),
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                title: Text("Cancel", style: TextStyle(color: AppColors.primaryWhite)),
                                trailing: Icon(Icons.cancel, color: AppColors.primaryWhite),
                              )
                            ],
                          ),
                        );
                      });
                },
                controller: msgController,
                onPressed: () async {
                  FocusScopeNode focus = FocusScope.of(context);
                  await fireStoreServices().userChat(
                    context: context,
                    myId: myId,
                    userId: widget.userModel.uid!,
                    docId: docId,
                    msg: msgController.text.isEmpty ? "" : msgController.text,
                    imageUrl: "",
                  );
                  setState(() {
                    msgController.clear();
                  });
                  if (!focus.hasPrimaryFocus) {
                    focus.unfocus();
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  //todo code Refactoring is Remain
}
