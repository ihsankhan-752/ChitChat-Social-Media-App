import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../../../../themes/colors.dart';
import '../../../../utils/constants.dart';
import '../../widgets/video_player_for_display_video.dart';

class PostImagePortion extends StatelessWidget {
  final PostModel postModel;
  const PostImagePortion({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width * 1;

    return Column(
      children: [
        postModel.videoUrl != ""
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: VideoPlayerForDisplayVideo(
                  path: postModel.videoUrl,
                ),
              )
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.height * 0.45,
                width: width * 1,
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
                  itemCount: postModel.postImages.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: postModel.postImages[i],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => spinKit2,
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
