import 'package:chitchat/screens/dashboard/profile_screen/profile_screen.dart';
import 'package:chitchat/screens/dashboard/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_controller.dart';
import '../../services/notification_services.dart';
import '../../themes/colors.dart';
import 'home/home_screen.dart';
import 'notification_screen.dart';
import 'upload/upload_post_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  NotificationServices notificationServices = NotificationServices();
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<UserController>(context, listen: false).getUserData();
    notificationServices.getPermission();
    notificationServices.initNotification(context);
    notificationServices.getDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryBlack,
          border: Border(
            top: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                child: Icon(Icons.home, color: currentIndex == 0 ? AppColors.primaryWhite : Colors.grey, size: 27),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                child: Icon(Icons.search, color: currentIndex == 1 ? AppColors.primaryWhite : Colors.grey, size: 27),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                child: Icon(Icons.add_box_outlined, color: currentIndex == 2 ? AppColors.primaryWhite : Colors.grey, size: 27),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
                child:
                    Icon(Icons.notifications_on_sharp, color: currentIndex == 3 ? AppColors.primaryWhite : Colors.grey, size: 27),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 4;
                  });
                },
                child: Icon(Icons.person, color: currentIndex == 4 ? AppColors.primaryWhite : Colors.grey, size: 27),
              ),
            ],
          ),
        ),
      ),
      body: _screens[currentIndex],
    );
  }
}
