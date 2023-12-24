// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/firestore_services.dart';
import '../../../themes/colors.dart';
import '../../../utils/custom_messanger.dart';
import '../../../utils/screen_navigations.dart';
import '../minor_screen/story_full_screen.dart';

class StoryCard extends StatefulWidget {
  const StoryCard({Key? key}) : super(key: key);

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  TextEditingController storyController = TextEditingController();
  bool showTextField = false;
  bool isLoading = false;
  File? selectedImage;
  uploadPicForStory() async {
    XFile? currentPic =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(currentPic!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return selectedImage == null
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(width: 3, color: AppColors.mainColor),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(1.5),
                            child: CircleAvatar(
                              backgroundColor: AppColors.primaryBlack,
                              radius: 40,
                              backgroundImage:
                                  const AssetImage("assets/images/guest.png"),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                uploadPicForStory();
                              },
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: AppColors.primaryBlack),
                                  color: AppColors.skyColor,
                                ),
                                child: Icon(Icons.add,
                                    size: 15, color: AppColors.primaryWhite),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("stories")
                        .where(
                          'createdAt',
                          isGreaterThan: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                        )
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return const SizedBox();
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: data['userCheckedList'].contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? null
                                  : Border.all(color: Colors.red),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  navigateToNext(
                                    context,
                                    StoryFullScreen(
                                      data: data,
                                    ),
                                  );
                                  await FirebaseFirestore.instance
                                      .collection("stories")
                                      .doc(data.id)
                                      .update({
                                    "userCheckedList": FieldValue.arrayUnion([
                                      FirebaseAuth.instance.currentUser!.uid
                                    ]),
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(data['userImage']),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            width: double.infinity,
            child: Stack(
              children: [
                Image.file(
                  File(selectedImage!.path),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.9,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedImage = null;
                        });
                      },
                      icon: Icon(Icons.arrow_back,
                          color: AppColors.appCircularRadius),
                    ),
                    const SizedBox(width: 30),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showTextField = !showTextField;
                        });
                      },
                      icon: Icon(Icons.abc_outlined,
                          color: AppColors.appCircularRadius, size: 35),
                    ),
                  ],
                ),
                showTextField
                    ? Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: TextField(
                            controller: storyController,
                            style: TextStyle(
                              color: AppColors.primaryWhite,
                            ),
                            autofocus: showTextField ? true : false,
                            cursorColor: AppColors.primaryWhite,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 80, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryGrey.withOpacity(0.7),
                          ),
                          child: Center(
                            child: Text(
                              "Your Story",
                              style: TextStyle(
                                color: AppColors.primaryWhite,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                        TextButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await fireStoreServices().uploadStory(context,
                                    storyController.text, selectedImage!);
                                setState(() {
                                  isLoading = false;
                                  selectedImage = null;
                                  storyController.clear();
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                showMessage(context, e.toString());
                              }
                            },
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    "Post",
                                    style: TextStyle(
                                      color: AppColors.primaryWhite,
                                    ),
                                  ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
