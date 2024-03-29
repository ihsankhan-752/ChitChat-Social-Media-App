import 'package:chitchat/services/auth_services.dart';
import 'package:chitchat/themes/colors.dart';
import 'package:chitchat/utils/custom_messanger.dart';
import 'package:chitchat/widgets/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../../../widgets/text_input.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  bool checkPassword = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Change Password"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("To Change your password please fill in the form below and click save changes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryWhite.withOpacity(0.7),
                          fontSize: 16,
                        )),
                    SizedBox(height: 20),
                    CustomPasswordTextInput(
                      controller: _oldPassController,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Enter Old Password";
                        } else {
                          return null;
                        }
                      },
                      hintText: "Enter your old password",
                      errorText: checkPassword != true ? "Not Valid Password" : null,
                    ),
                    CustomPasswordTextInput(
                      controller: _newPassController,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "New Password Must Be Filled";
                        } else {
                          return null;
                        }
                      },
                      hintText: "Enter new password",
                    ),
                    CustomPasswordTextInput(
                      controller: TextEditingController(),
                      validator: (v) {
                        if (v != _newPassController.text) {
                          return "Password Not Matching";
                        } else if (v!.isEmpty) {
                          return "Re-Enter New Password";
                        } else {
                          return null;
                        }
                      },
                      hintText: "Re-Enter new password",
                    ),
                  ],
                ),
                SizedBox(height: 10),
                FlutterPwValidator(
                  controller: _newPassController,
                  minLength: 8,
                  uppercaseCharCount: 1,
                  numericCharCount: 1,
                  specialCharCount: 1,
                  width: 400,
                  height: 150,
                  onSuccess: () {},
                  onFail: () {},
                ),
                SizedBox(height: 60),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : PrimaryButton(
                        btnColor: AppColors.primaryColor,
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            if (_key.currentState!.validate()) {
                              checkPassword = await AuthServices.checkOldPassword(
                                FirebaseAuth.instance.currentUser!.email,
                                _oldPassController.text,
                              );

                              checkPassword == true
                                  ? await AuthServices.changeUserPassword(_newPassController.text).whenComplete(() {
                                      _key.currentState!.reset();
                                      _newPassController.clear();
                                      _oldPassController.clear();

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text("Your Password Is Updated Successfully"),
                                      ));
                                      Navigator.of(context).pop();
                                    })
                                  : showMessage(context, "Invalid password");
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            showMessage(context, e.toString());
                          }
                        },
                        title: "Save Changes",
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
