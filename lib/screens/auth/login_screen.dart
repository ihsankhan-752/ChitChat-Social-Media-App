// ignore_for_file: use_build_context_synchronously
import 'package:chitchat/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/loading_controller.dart';
import '../../services/auth_services.dart';
import '../../themes/colors.dart';
import '../../utils/screen_navigations.dart';
import '../../utils/text_styles.dart';
import '../../widgets/buttons.dart';
import '../../widgets/text_input.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loadingController = Provider.of<LoadingController>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              SizedBox(height: 150, child: Center(child: Image.asset("assets/images/logo.png"))),
              SizedBox(height: 30),
              Text("Login to Your Account", style: AppTextStyle.mainHeading.copyWith(fontSize: 20)),
              const SizedBox(height: 20),
              TextInputField(controller: emailController, hintText: "email", prefixIcon: Icons.email),
              const SizedBox(height: 20),
              TextInputField(
                controller: passwordController,
                hintText: "password",
                prefixIcon: Icons.lock,
                isTextSecure: isVisible,
                suffixChild: IconButton(
                  icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  navigateToNext(context, const ForgotPasswordScreen());
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: AppTextStyle.buttonTextStyle.copyWith(color: AppColors.primaryWhite),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              loadingController.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : PrimaryButton(
                      onPressed: () {
                        AuthServices().signIn(
                          context,
                          emailController.text,
                          passwordController.text,
                        );
                      },
                      title: "Sign In",
                      btnColor: AppColors.mainColor,
                    ),
              const SizedBox(height: 40),
              InkWell(
                highlightColor: AppColors.primaryBlack,
                onTap: () {
                  navigateToNext(context, const SignUpScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an Account ?",
                      style: AppTextStyle.buttonTextStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.primaryWhite.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "  Sign Up ",
                      style: AppTextStyle.buttonTextStyle.copyWith(
                        fontSize: 18,
                        color: AppColors.primaryWhite,
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
