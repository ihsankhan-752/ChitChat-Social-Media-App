import 'package:flutter/material.dart';

Future imagePickingDialogBox({BuildContext? context, Function()? cameraTapped, Function()? galleryTapped}) async {
  return showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: cameraTapped,
              child: const Text("From Camera"),
            ),
            const Divider(),
            SimpleDialogOption(
              onPressed: galleryTapped,
              child: const Text("From Gallery"),
            ),
            const Divider(),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      });
}
