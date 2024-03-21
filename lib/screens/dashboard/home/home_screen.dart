import 'package:chitchat/screens/dashboard/home/widgets/custom_post_card.dart';
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
        leading: Icon(Icons.camera_alt_outlined, color: AppColors.primaryWhite),
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(thickness: 0.5),
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
                    return CustomPostCard(postController: postController, index: index);
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
