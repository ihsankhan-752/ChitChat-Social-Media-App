import 'package:chitchat/widgets/loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../consts/colors.dart';
import '../../consts/text_styles.dart';
import '../../providers/loading_controller.dart';
import '../../services/auth_services.dart';
import '../../widgets/buttons.dart';
import '../../widgets/text_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loadingController = Provider.of<LoadingController>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Forgot Password?", style: AppTextStyle.mainHeading),
            const SizedBox(height: 20),
            TextInputField(
              controller: emailController,
              hintText: "E-mail",
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 30),
            loadingController.isLoading
                ? Center(
                    child: spinKit2,
                  )
                : PrimaryButton(
                    onPressed: () {
                      AuthServices().resetPassword(
                        context,
                        emailController.text,
                      );
                    },
                    title: "Reset",
                    btnColor: AppColors.mainColor,
                  ),
          ],
        ),
      ),
    );
  }
}
