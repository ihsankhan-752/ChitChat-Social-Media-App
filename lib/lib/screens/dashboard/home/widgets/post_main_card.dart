import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/lib/providers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../../../../themes/colors.dart';
import '../../../../utils/constants.dart';
import '../../widgets/video_player_for_display_video.dart';

class PostMainCard extends StatelessWidget {
  final PostController postController;
  final int index;
  const PostMainCard({super.key, required this.postController, required this.index});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width * 1;

    return Column(
      children: [
        postController.postList[index].videoUrl != ""
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: VideoPlayerForDisplayVideo(
                  path: postController.postList[index].videoUrl,
                ),
              )
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: MediaQuery.of(context).size.height * 0.45,
                width: width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Swiper(
                  controller: SwiperController(),
                  pagination: SwiperPagination(
                    builder: FractionPaginationBuilder(
                      color: AppColors.primaryWhite,
                      activeColor: AppColors.primaryWhite,
                      fontSize: 22,
                      activeFontSize: 22,
                    ),
                  ),
                  itemCount: postController.postList[index].postImages.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: postController.postList[index].postImages[i],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => spinKit2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
      ],
    );
  }
}
