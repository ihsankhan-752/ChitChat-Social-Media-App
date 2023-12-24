import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../themes/colors.dart';

class ReplyAddingWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function() onPressed;
  const ReplyAddingWidget(
      {super.key, required this.controller, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: AppColors.primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            ),
            context: context,
            builder: (_) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.white30,
                          ),
                          controller: controller,
                          decoration: InputDecoration(
                              hintText: 'write a reply.....',
                              hintStyle: const TextStyle(color: Colors.white30),
                              fillColor: AppColors.primaryColor,
                              filled: true,
                              suffixIcon: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: onPressed,
                                color: AppColors.skyColor,
                                icon: const Icon(FontAwesomeIcons.paperPlane),
                              )),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            });
      },
      child: const Text(
        "Reply",
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    );
  }
}
