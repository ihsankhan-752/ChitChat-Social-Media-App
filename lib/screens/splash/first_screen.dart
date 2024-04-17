import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../utils/screen_navigations.dart';
import '../../utils/text_styles.dart';
import '../../widgets/buttons.dart';
import '../auth/login_screen.dart';
import '../auth/sign_up_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/images/logo.png")),
            const SizedBox(height: 20),
            Text(
              "Let's You in",
              style: AppTextStyle.mainHeading.copyWith(color: AppColors.primaryWhite),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                navigateToNext(context, const SignUpScreen());
              },
              isIconReq: true,
              title: "Register Yourself",
              icon: Icons.login,
              iconColor: AppColors.skyColor,
              btnColor: AppColors.primaryGrey,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                navigateToNext(context, const LoginScreen());
              },
              isIconReq: true,
              title: "Login With Email",
              icon: Icons.email,
              iconColor: AppColors.primaryWhite,
              btnColor: AppColors.primaryGrey,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
