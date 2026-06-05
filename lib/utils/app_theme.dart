import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class AppTheme {
  // Nepal_inspired color palette
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color primaryBlue = Color(0xFF003893);
  static const Color accentGold = Color(0xFFFFB300);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color success = Color(0xFF22C55E);
  static const Color dividerColor = Color(0xFFE5E7EB);

static ThemeData get lightThemev{
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryRed,
      primary: primaryRed,
        secondary: primaryBlue,
        background: backgroundLight,
        surface: cardWhite,
        ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: cardWhite,
        elevation: 0,
         centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
      ),
       iconTheme: IconThemeData(color: textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:primaryRed,
          foregroundColor:Colors.White,
          elevation:0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding:const EdgeInsets.symmetric(Vertical: 16),
          textStyle: const TextStyle(
            fontFamily: 'poppins',
            fontSize: 16,
            fontWeight:FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled:true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
         borderSide: borderside.none,
        ),
        focousedBorder:OutlineInputBorder(
       borderRadius: BorderRadius.circular(12),
          borderSide: Const BorderSide(color: PrimaryRed,Width: 1.5),
        ),
       contentPadding:const EdgeInsets.symmetric(horizontal: 16,vertical: 14)
       ),
       cardTheme: cardTheme(
        elevation:0,
        shape:ROundedRectangleBorder(borderRadius:BorderRadius.circular(16)),
        Color: cardWhite,
       ),
       bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:cardWhite,
        selectedItemColor: primaryRed,
        unselectedItemColor:textGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
       ),
        );
}
}


       
         


  