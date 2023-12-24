import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showCustomAlertDialog({
  required BuildContext context,
  required String content,
  required Function() onPressed,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return CupertinoAlertDialog(
        title: const Text("Wait"),
        content: Text(content),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
          ),
          CupertinoActionSheetAction(onPressed: onPressed, child: const Text("Yes")),
        ],
      );
    },
  );
}
