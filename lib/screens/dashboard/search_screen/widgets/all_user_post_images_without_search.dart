import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../../providers/post_controller.dart';
import '../../../../widgets/loading_indicators.dart';
import '../../widgets/video_player_for_display_video.dart';

class AllUserPostImagesWithOutSearch extends StatelessWidget {
  const AllUserPostImagesWithOutSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final postController = Provider.of<PostController>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.of(context).size.height * 0.7,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: postController.postList.length,
        staggeredTileBuilder: (index) => StaggeredTile.count(
          (index % 7 == 0) ? 2 : 1,
          (index % 7 == 0) ? 2 : 1,
        ),
        itemBuilder: (context, index) {
          return postController.postList[index].videoUrl == ""
              ? CachedNetworkImage(
                  imageUrl: postController.postList[index].postImages[0],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => spinKit2,
                )
              : SizedBox(
                  height: 200,
                  child: VideoPlayerForDisplayVideo(
                    path: postController.postList[index].videoUrl,
                  ),
                );
        },
      ),
    );
  }
}
