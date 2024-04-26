import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../consts/colors.dart';
import '../../../../../providers/image_controller.dart';
import '../../../../../providers/loading_controller.dart';
import '../../../../../services/chat_services.dart';
import '../../../../../widgets/buttons.dart';
import '../../../widgets/message_text_input.dart';
import 'image_sending_option_bottomsheet.dart';

class TextSendingWidget extends StatefulWidget {
  final ImageController imageController;
  final TextEditingController msgController;
  final String userId, docId;

  const TextSendingWidget(
      {super.key, required this.imageController, required this.msgController, required this.userId, required this.docId});

  @override
  State<TextSendingWidget> createState() => _TextSendingWidgetState();
}

class _TextSendingWidgetState extends State<TextSendingWidget> {
  @override
  Widget build(BuildContext context) {
    return MessageTextInput(
      picSelectionTapped: () {
        showModalBottomSheet(
            backgroundColor: AppColors.primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            context: context,
            builder: (_) {
              return imageSendingOptionBottomSheet(context, widget.imageController);
            });
      },
      controller: widget.msgController,
      sendingTextBtn: Consumer<LoadingController>(builder: (context, loadingController, child) {
        return loadingController.isLoading
            ? SizedBox(
                height: 35,
                width: 35,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primaryWhite),
                ),
              )
            : TextSendingButton(
                onPressed: () async {
                  await ChatServices().sendMsg(
                    context: context,
                    imageUrl: "",
                    userId: widget.userId,
                    docId: widget.docId,
                    msg: widget.msgController.text,
                  );
                  setState(() {
                    widget.msgController.clear();
                    FocusScope.of(context).unfocus();
                  });
                },
              );
      }),
    );
  }
}
