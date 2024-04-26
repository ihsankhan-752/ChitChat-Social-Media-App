import 'package:chitchat/screens/dashboard/minor_screen/chat_screen/user_list_for_chat_screen.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard/home/home_screen.dart';
import '../screens/dashboard/profile_screen/profile_screen.dart';
import '../screens/dashboard/search_screen/search_screen.dart';

List reportCategoryList = [
  "Hate Speech or Harassment",
  "Violence or Graphic Content",
  "Bullying or Cyberbullying",
  "Spam or Misleading Content",
  "Intellectual Property Infringement",
  "Nudity or Adult Content",
  "False Information or Fake News",
  "Self-Harm or Suicide Promotion",
  "Child Exploitation or Abuse",
  "Privacy Violation",
  "Terrorism or Extremism",
  "Impersonation or Fake Accounts",
  "Animal Abuse",
  "Drug Sales or Illegal Activities",
  "Other",
];
final List<Widget> screens = [
  const HomeScreen(),
  const SearchScreen(),
  const UserListForChatScreen(),
  const ProfileScreen(),
];
