import 'package:chitchat/lib/providers/post_controller.dart';
import 'package:chitchat/lib/screens/dashboard/home/widgets/like_comment_and_share_btn_widget.dart';
import 'package:chitchat/lib/screens/dashboard/home/widgets/post_footer.dart';
import 'package:chitchat/lib/screens/dashboard/home/widgets/post_header.dart';
import 'package:chitchat/lib/screens/dashboard/home/widgets/post_main_card.dart';
import 'package:chitchat/lib/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../services/notification_services.dart';
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
            style: GoogleFonts.pacifico(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryWhite.withOpacity(0.7),
              letterSpacing: 2.5,
            )),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.message, color: AppColors.primaryWhite),
            onPressed: () {
              navigateToNext(context, const UserListForChatScreen());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const StoryCard(),
            const Divider(thickness: 0.1, color: Colors.grey),
            if (postController.postList.isEmpty)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120),
                  itemCount: postController.postList.length,
                  itemBuilder: (context, index) {
                    postController.postList.length;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      elevation: 32,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColors.primaryColor, width: 3),
                      ),
                      color: AppColors.primaryBlack,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PostHeader(
                            postController: postController,
                            index: index,
                          ),
                          Row(
                            children: [
                              LikeCommentShareButtonWidget(postController: postController, index: index),
                              PostMainCard(postController: postController, index: index),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(color: AppColors.primaryColor, height: 0.1, thickness: 1),
                          PostFooter(postController: postController, index: index),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
