import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../themes/colors.dart';

logOutDialog(BuildContext context) {
  return SimpleDialog(
    backgroundColor: AppColors.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    title: Center(
        child: Text(
      "Wait",
      style: TextStyle(
        color: AppColors.primaryWhite,
      ),
    )),
    children: [
      Center(
          child: Text(
        "Are you sure, you want to log out?",
        style: TextStyle(
          color: AppColors.primaryWhite,
        ),
      )),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.primaryBlack,
              ),
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
            child: Text(
              "Logout",
              style: TextStyle(
                color: AppColors.primaryBlack,
              ),
            ),
          ),
        ],
      )
    ],
  );
}
