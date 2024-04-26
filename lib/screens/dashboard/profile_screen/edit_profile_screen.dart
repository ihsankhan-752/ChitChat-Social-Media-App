import 'package:chitchat/consts/colors.dart';
import 'package:chitchat/providers/loading_controller.dart';
import 'package:chitchat/providers/user_controller.dart';
import 'package:chitchat/screens/dashboard/profile_screen/widgets/image_portion.dart';
import 'package:chitchat/services/user_profile_services.dart';
import 'package:chitchat/widgets/buttons.dart';
import 'package:chitchat/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(child: ImagePortion()),
              SizedBox(height: 30),
              Text(
                "username".toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryWhite,
                ),
              ),
              SizedBox(height: 5),
              CustomTextInput(hintText: userController.userModel.username!, controller: nameController),
              SizedBox(height: 30),
              Text(
                "bio".toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryWhite,
                ),
              ),
              SizedBox(height: 5),
              CustomTextInput(hintText: userController.userModel.bio!, controller: bioController),
              SizedBox(height: 50),
              Consumer<LoadingController>(builder: (context, loadingController, child) {
                return loadingController.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : PrimaryButton(
                        onPressed: () async {
                          UserProfileServices().updateProfile(
                            context: context,
                            username: nameController.text.isEmpty ? userController.userModel.username : nameController.text,
                            bio: bioController.text.isEmpty ? userController.userModel.bio : bioController.text,
                          );
                        },
                        title: "Update",
                        btnColor: AppColors.primaryColor,
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}
