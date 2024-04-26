import 'package:chitchat/consts/colors.dart';
import 'package:chitchat/consts/lists.dart';
import 'package:chitchat/consts/text_styles.dart';
import 'package:chitchat/providers/loading_controller.dart';
import 'package:chitchat/services/report_services.dart';
import 'package:chitchat/widgets/buttons.dart';
import 'package:chitchat/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/loading_indicators.dart';

class ReportScreen extends StatefulWidget {
  final String postId;
  const ReportScreen({super.key, required this.postId});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController _descriptionController = TextEditingController();
  String _selectedContent = "Select Content";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Post"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose Content",
                style: AppTextStyle.mainHeading.copyWith(fontSize: 16),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryWhite.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text(
                        _selectedContent,
                        style: AppTextStyle.mainHeading.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      items: reportCategoryList.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedContent = v.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Why you report this post? (Describe)",
                style: AppTextStyle.mainHeading.copyWith(fontSize: 16),
              ),
              SizedBox(height: 10),
              CustomTextInput(
                maxLines: 5,
                hintText: "This post contain content which is not appropriate",
                controller: _descriptionController,
              ),
              SizedBox(height: 50),
              Consumer<LoadingController>(builder: (context, loadingController, child) {
                return loadingController.isLoading
                    ? Center(
                        child: spinKit2,
                      )
                    : PrimaryButton(
                        onPressed: () async {
                          ReportServices.reportPost(
                            context: context,
                            contentType: _selectedContent,
                            description: _descriptionController.text,
                            postId: widget.postId,
                          );
                        },
                        title: "Report",
                        btnColor: AppColors.primaryColor,
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}
