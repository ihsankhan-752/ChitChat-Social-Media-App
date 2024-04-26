import 'package:chitchat/providers/loading_controller.dart';
import 'package:chitchat/widgets/custom_messanger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ReportServices {
  static reportPost({
    required BuildContext context,
    required String contentType,
    required String description,
    required String postId,
  }) async {
    if (contentType.isEmpty) {
      showMessage(context, "Choose Content");
    } else if (description.isEmpty) {
      showMessage(context, "Describe why you want to report?");
    } else {
      try {
        var reportId = const Uuid().v4();
        Provider.of<LoadingController>(context, listen: false).setLoading(true);
        ReportModel reportModel = ReportModel(
          reportId: reportId,
          userId: FirebaseAuth.instance.currentUser!.uid,
          postId: postId,
          description: description,
          contentType: contentType,
          reportOn: DateTime.now(),
        );

        await FirebaseFirestore.instance.collection('reports').doc(reportId).set(reportModel.toMap());
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showMessage(context, "Post is reported after careful examine we will take action");
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showMessage(context, e.message!);
      }
    }
  }
}

class ReportModel {
  String? reportId;
  String? userId;
  String? postId;
  DateTime? reportOn;
  String? contentType;
  String? description;

  ReportModel({
    this.reportId,
    this.userId,
    this.postId,
    this.reportOn,
    this.contentType,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'reportId': this.reportId,
      'userId': this.userId,
      'postId': this.postId,
      'reportOn': this.reportOn,
      'contentType': this.contentType,
      'description': this.description,
    };
  }

  factory ReportModel.fromMap(DocumentSnapshot map) {
    return ReportModel(
      reportId: map['reportId'] as String,
      userId: map['userId'] as String,
      postId: map['postId'] as String,
      reportOn: (map['reportOn'].toDate()),
      contentType: map['contentType'] as String,
      description: map['description'] as String,
    );
  }
}
