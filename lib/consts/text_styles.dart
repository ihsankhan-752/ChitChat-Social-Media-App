import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTextStyle {
  static TextStyle mainHeading = GoogleFonts.acme(
    fontSize: 28,
    color: AppColors.primaryWhite,
  );
  static TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.primaryWhite,
    fontWeight: FontWeight.w900,
  );
}
