import 'package:chitchat/screens/dashboard/profile_screen/profile_screen.dart';
import 'package:chitchat/screens/dashboard/search_screen/search_screen.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
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
  final List _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];
  int currentIndex = 0;
  @override
  void initState() {
    Provider.of<UserController>(context, listen: false).getUserData();
    notificationServices.getPermission();
    notificationServices.initNotification(context);
    notificationServices.getDeviceToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        elevation: 10,
        borderRadius: 10,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        selectedItemColor: AppColors.primaryWhite,
        backgroundColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        selectedBackgroundColor: AppColors.mainColor,
        onTap: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          FloatingNavbarItem(
            icon: Icons.home,
            title: "Home",
          ),
          FloatingNavbarItem(
            icon: Icons.search,
            title: "Search",
          ),
          FloatingNavbarItem(
            icon: Icons.upload,
            title: "Upload",
          ),
          FloatingNavbarItem(
            icon: Icons.notification_important_outlined,
            title: "Alerts",
          ),
          FloatingNavbarItem(
            icon: Icons.person,
            title: "Profile",
          ),
        ],
        currentIndex: currentIndex,
      ),
      body: _screens[currentIndex],
    );
  }
}
