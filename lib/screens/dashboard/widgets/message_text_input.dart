import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/colors.dart';

class MessageTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final Function()? onPressed;
  final Function()? picSelectionTapped;
  const MessageTextInput(
      {Key? key, this.controller, this.onPressed, this.picSelectionTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: AppColors.primaryWhite,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 20),
            prefixIcon: IconButton(
              onPressed: picSelectionTapped,
              icon: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(Icons.photo, color: AppColors.primaryWhite),
              ),
            ),
            hintText: "Message....",
            suffixIcon: IconButton(
              onPressed: onPressed,
              icon: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Icon(
                  FontAwesomeIcons.paperPlane,
                  color: AppColors.skyColor,
                  size: 25,
                ),
              ),
            ),
            hintStyle: const TextStyle(
              color: Colors.grey,
            )),
      ),
    );
  }
}

// DocumentSnapshot userSnap = await _firestore.collection("users").doc(myId).get();
// try {
//   DocumentSnapshot snap = await _firestore.collection("chat").doc(docId).get();
//   if (snap.exists) {
//     await _firestore.collection("chat").doc(docId).update({
//       "lastMsg": msgController.text,
//       "createdAt": DateTime.now(),
//     });
//   } else {
//     await _firestore.collection("chat").doc(docId).set({
//       "lastMsg": msgController.text,
//       "userIds": [myId, widget.userId],
//       "createdAt": DateTime.now(),
//     });
//   }
//   await _firestore.collection("chat").doc(docId).collection("messages").add({
//     "msg": msgController.text,
//     "senderId": myId,
//     "userImage": userSnap['image'],
//     "username": userSnap['username'],
//     "createdAt": DateTime.now(),
//   });
//   msgController.clear();
//   setState(() {});
// } catch (e) {
//   showMessage(context, e.toString());
// }
