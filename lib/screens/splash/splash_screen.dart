import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      if (FirebaseAuth.instance.currentUser == null) {
        navigateToNext(context, const FirstScreen());
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BottomNavBar()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/logo.png")),
        ],
      ),
    );
  }
}
