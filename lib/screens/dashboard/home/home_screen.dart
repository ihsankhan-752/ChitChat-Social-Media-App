import 'package:chitchat/screens/dashboard/home/widgets/custom_post_card.dart';
import 'package:chitchat/screens/dashboard/minor_screen/bookmarks/save_posts_screen.dart';
import 'package:chitchat/screens/dashboard/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../providers/post_controller.dart';
import '../../../services/notification_services.dart';
import '../../../themes/colors.dart';
import '../../../utils/screen_navigations.dart';
import '../minor_screen/chat_screen/user_list_for_chat_screen.dart';

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
            icon: Icon(FontAwesomeIcons.paperPlane, color: AppColors.primaryWhite),
            onPressed: () {
              navigateToNext(context, const UserListForChatScreen());
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.bookmark, color: AppColors.primaryWhite),
          //   onPressed: () {
          //     navigateToNext(context, SavePostsScreen());
          //   },
          // )
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
