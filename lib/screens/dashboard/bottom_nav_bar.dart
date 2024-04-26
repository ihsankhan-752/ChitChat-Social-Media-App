import 'package:chitchat/consts/app_assets.dart';
import 'package:chitchat/consts/screen_navigations.dart';
import 'package:chitchat/screens/dashboard/upload/add_post_screen.dart';
import 'package:chitchat/screens/dashboard/widgets/bottom_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../consts/colors.dart';
import '../../consts/lists.dart';
import '../../providers/user_controller.dart';
import '../../services/notification_services.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  NotificationServices notificationServices = NotificationServices();

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<UserController>(context, listen: false).getUserData(context);
    notificationServices.getPermission();
    notificationServices.initNotification(context);
    notificationServices.getDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (dipPop) {
        if (dipPop) {
          return;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GestureDetector(
          onTap: () {
            navigateToNext(context, AddPostScreen());
          },
          child: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            radius: 30,
            child: Center(
              child: Icon(Icons.add, color: AppColors.primaryWhite, size: 28),
            ),
          ),
        ),
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          color: AppColors.primaryColor,
          height: 60,
          shape: CircularNotchedRectangle(),
          notchMargin: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomTabWidget(
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  image: AppAssets.homeIcon,
                  imageColor: currentIndex == 0 ? AppColors.primaryWhite : Colors.grey.withOpacity(0.7),
                ),
                BottomTabWidget(
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  image: AppAssets.searchIcon,
                  imageColor: currentIndex == 1 ? AppColors.primaryWhite : Colors.grey.withOpacity(0.7),
                ),
                SizedBox(width: 1),
                BottomTabWidget(
                  onPressed: () {
                    setState(() {
                      currentIndex = 2;
                    });
                  },
                  image: AppAssets.chatIcon,
                  imageColor: currentIndex == 2 ? AppColors.primaryWhite : Colors.grey.withOpacity(0.7),
                ),
                BottomTabWidget(
                  onPressed: () {
                    setState(() {
                      currentIndex = 3;
                    });
                  },
                  image: AppAssets.personIcon,
                  imageColor: currentIndex == 3 ? AppColors.primaryWhite : Colors.grey.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
        body: screens[currentIndex],
      ),
    );
  }
}
