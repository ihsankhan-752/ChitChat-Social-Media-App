import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/providers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../../utils/constants.dart';
import '../../widgets/video_player_for_display_video.dart';

class ShowUserPost extends StatelessWidget {
  final PostController postController;
  const ShowUserPost({super.key, required this.postController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.of(context).size.height * 0.5,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: postController.myPostList.length,
        staggeredTileBuilder: (index) => StaggeredTile.count(
          (index % 7 == 0) ? 2 : 1,
          (index % 7 == 0) ? 2 : 1,
        ),
        itemBuilder: (context, index) {
          return postController.myPostList[index].videoUrl == ""
              ? CachedNetworkImage(
                  imageUrl: postController.myPostList[index].postImages[0],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => spinKit2,
                )
              : SizedBox(
                  height: 200,
                  child: VideoPlayerForDisplayVideo(
                    path: postController.myPostList[index].videoUrl,
                  ),
                );
        },
      ),
    );
  }
}
