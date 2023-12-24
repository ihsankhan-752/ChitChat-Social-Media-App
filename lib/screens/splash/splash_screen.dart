import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../themes/colors.dart';
import '../../utils/screen_navigations.dart';
import '../dashboard/bottom_nav_bar.dart';
import 'first_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        navigateToNext(context, const FirstScreen());
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BottomNavBar()));
      }
    });
    super.initState();
  }

  isUserLogin() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/logo.png")),
          const SizedBox(height: 50),
          SpinKitSpinningLines(
            size: 100,
            color: AppColors.mainColor,
          ),
        ],
      ),
    );
  }
}
