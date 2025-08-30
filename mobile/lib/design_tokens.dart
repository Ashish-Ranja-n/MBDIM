/// Design tokens for MBDIM mobile app
/// Colors, typography, spacing, radii, elevation, shadows
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color marketPrimary = Color(0xFF0F9D58);
  static const Color marketGradientStart = Color(0xFF00C853);
  static const Color marketGradientEnd = Color(0xFF66FFA6);
  static const Color marketProgressFill = Color(0xFF1DB954);
  static const Color raiseFundTealStart = Color(0xFF06B6D4);
  static const Color raiseFundTealEnd = Color(0xFF60A5FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF6B7280);
  static const Color primaryText = Color(0xFF082033);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color neutralLight = Color(0xFFF7FAFC);
  static const Color shadow = Color.fromRGBO(8, 32, 51, 0.08);
}

class AppTypography {
  static TextStyle get title => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    height: 1.2,
  );
  static TextStyle get sectionHeading => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.3,
  );
  static TextStyle get cardTitle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    height: 1.3,
  );
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
    height: 1.4,
  );
  static TextStyle get small => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.mutedText,
    height: 1.3,
  );
  static TextStyle get badge => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.cardBackground,
    height: 1.2,
  );
}

class AppSpacing {
  static const double base = 8;
  static const double cardPadding = 16;
  static const double edge = 20;
}

class AppRadii {
  static const double card = 16;
  static const double small = 10;
  static const double button = 12;
}

class AppElevation {
  static const double blur = 16;
  static const double offsetY = 6;
  static const Color color = AppColors.shadow;
}
