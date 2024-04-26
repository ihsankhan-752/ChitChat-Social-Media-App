import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/consts/screen_navigations.dart';
import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/screens/dashboard/home/widgets/image_full_view_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../../../../consts/colors.dart';
import '../../../../widgets/loading_indicators.dart';

class PostImagePortion extends StatelessWidget {
  final PostModel postModel;
  const PostImagePortion({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width * 1;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: MediaQuery.of(context).size.height * 0.45,
          width: width * 1,
          child: postModel.postImages.length > 1
              ? Swiper(
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
                          GestureDetector(
                            onTap: () {
                              navigateToNext(context, ImageFullViewWidget(imageUrl: postModel.postImages[i]));
                            },
                            child: CachedNetworkImage(
                              imageUrl: postModel.postImages[i],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => spinKit2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      navigateToNext(context, ImageFullViewWidget(imageUrl: postModel.postImages.first));
                    },
                    child: CachedNetworkImage(
                      imageUrl: postModel.postImages.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => spinKit2,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
