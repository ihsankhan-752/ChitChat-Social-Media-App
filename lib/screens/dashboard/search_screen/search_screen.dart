import 'package:chitchat/screens/dashboard/search_screen/widgets/all_user_post_images_without_search.dart';
import 'package:chitchat/screens/dashboard/search_screen/widgets/user_custom_card_from_search.dart';
import 'package:flutter/material.dart';

import '../../../widgets/text_input.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextInputForSearch(
          controller: searchController,
          onChanged: (v) {
            setState(() {});
            FocusScopeNode focusScopeNode = FocusScope.of(context);
            if (focusScopeNode.hasPrimaryFocus) {
              focusScopeNode.unfocus();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            searchController.text.isNotEmpty
                ? UserCustomCardFromSearch(searchController: searchController)
                : const AllUserPostImagesWithOutSearch()
          ],
        ),
      ),
    );
  }
}
