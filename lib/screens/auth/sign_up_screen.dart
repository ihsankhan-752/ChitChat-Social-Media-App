// ignore_for_file: use_build_context_synchronously

import 'package:chitchat/screens/auth/widgets/image_picking_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/image_controller.dart';
import '../../providers/loading_controller.dart';
import '../../services/auth_services.dart';
import '../../themes/colors.dart';
import '../../utils/screen_navigations.dart';
import '../../utils/text_styles.dart';
import '../../widgets/buttons.dart';
import '../../widgets/text_input.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loadingController = Provider.of<LoadingController>(context);
    final imageController = Provider.of<ImageController>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Create Your Account",
            style: AppTextStyle.mainHeading.copyWith(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      Center(
                        child: imageController.selectedImage == null
                            ? const CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    AssetImage("assets/images/guest.png"))
                            : CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    FileImage(imageController.selectedImage!),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.btnColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.btnColor),
                          ),
                          child: InkWell(
                            onTap: () {
                              imagePickingDialogBox(
                                  context: context,
                                  cameraTapped: () {
                                    Navigator.of(context).pop();
                                    imageController
                                        .uploadImage(ImageSource.camera);
                                  },
                                  galleryTapped: () {
                                    Navigator.of(context).pop();
                                    imageController
                                        .uploadImage(ImageSource.gallery);
                                  });
                            },
                            child: Icon(Icons.image,
                                color: AppColors.primaryWhite, size: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextInputField(
                controller: usernameController,
                hintText: "username",
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 20),
              TextInputField(
                controller: emailController,
                hintText: "email",
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 20),
              TextInputField(
                controller: passwordController,
                hintText: "password",
                prefixIcon: Icons.lock,
                isTextSecure: isVisible,
                suffixChild: IconButton(
                  icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextInputField(
                controller: bioController,
                hintText: "bio",
                prefixIcon: Icons.edit,
              ),
              const SizedBox(height: 30),
              loadingController.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : PrimaryButton(
                      onPressed: () {
                        AuthServices().signUp(
                          context: context,
                          email: emailController.text,
                          password: passwordController.text,
                          file: imageController.selectedImage!,
                          username: usernameController.text,
                          bio: bioController.text,
                        );
                      },
                      title: "Sign Up",
                      btnColor: AppColors.mainColor,
                    ),
              const SizedBox(height: 40),
              InkWell(
                highlightColor: AppColors.primaryBlack,
                onTap: () {
                  navigateToNext(context, const LoginScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: AppTextStyle.buttonTextStyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      " Sign In",
                      style: AppTextStyle.buttonTextStyle.copyWith(
                        fontSize: 18,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
