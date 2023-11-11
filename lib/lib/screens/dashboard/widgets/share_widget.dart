import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareWidget extends StatelessWidget {
  final String image, title;
  const ShareWidget({Key? key, required this.image, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final box = context.findRenderObject() as RenderBox?;
        await Share.share(
          image,
          subject: title,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
      },
      child: const Icon(Icons.send, color: Colors.white),
    );
  }
}
