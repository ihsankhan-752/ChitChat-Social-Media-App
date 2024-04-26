import 'package:chitchat/consts/app_assets.dart';
import 'package:chitchat/screens/dashboard/home/widgets/custom_post_card.dart';
import 'package:chitchat/screens/dashboard/notifications/notification_screen.dart';
import 'package:chitchat/screens/dashboard/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../consts/colors.dart';
import '../../../consts/screen_navigations.dart';
import '../../../providers/post_controller.dart';
import '../../../services/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController storyController = TextEditingController();

  @override
  void initState() {
    NotificationServices().getDeviceToken();
    Provider.of<PostController>(context, listen: false).getAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postController = Provider.of<PostController>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chit Chat",
            style: GoogleFonts.satisfy(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryWhite,
              letterSpacing: 2.5,
            )),
        centerTitle: false,
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: SizedBox(height: 25, width: 25, child: Image.asset(AppAssets.notificationIcon, color: AppColors.primaryWhite)),
            onPressed: () {
              navigateToNext(context, const NotificationScreen());
            },
          ),
        ],
      ),
      body: postController.postList.isEmpty
          ? shimmerLoading()
          : CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return CustomPostCard(postModel: postController.postList[index]);
                    },
                    childCount: postController.postList.length,
                  ),
                ),
              ],
            ),
    );
  }
}
