import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/loading_indicators.dart';

class ImageFullViewWidget extends StatelessWidget {
  final String imageUrl;
  const ImageFullViewWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full View"),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => Center(child: spinKit2),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
