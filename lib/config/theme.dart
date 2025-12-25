import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors from the design templates
  static const Color primary = Color(0xFF13EC5B);
  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color backgroundDark = Color(0xFF102216);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A2E22);
  static const Color textMain = Color(0xFF0D1B12);
  static const Color textSub = Color(0xFF4C9A66);
  static const Color inputBg = Color(0xFFE7F3EB);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundLight,
    
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: primary,
      surface: surfaceLight,
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: textMain,
      onError: Colors.white,
    ),
    
    textTheme: GoogleFonts.epilogueTextTheme().copyWith(
      displayLarge: GoogleFonts.epilogue(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textMain,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.epilogue(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textMain,
      ),
      displaySmall: GoogleFonts.epilogue(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textMain,
      ),
      headlineMedium: GoogleFonts.epilogue(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textMain,
      ),
      titleLarge: GoogleFonts.epilogue(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textMain,
      ),
      bodyLarge: GoogleFonts.epilogue(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textMain,
      ),
      bodyMedium: GoogleFonts.epilogue(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textMain,
      ),
      labelLarge: GoogleFonts.epilogue(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textMain,
      ),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundLight.withOpacity(0.9),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.epilogue(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textMain,
      ),
      iconTheme: const IconThemeData(color: textMain),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        textStyle: GoogleFonts.epilogue(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: GoogleFonts.epilogue(
        color: textSub.withOpacity(0.7),
        fontWeight: FontWeight.w500,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,
    
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: primary,
      surface: surfaceDark,
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    
    textTheme: GoogleFonts.epilogueTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.epilogue(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.epilogue(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      displaySmall: GoogleFonts.epilogue(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.epilogue(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.epilogue(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.epilogue(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.epilogue(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      labelLarge: GoogleFonts.epilogue(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDark.withOpacity(0.9),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.epilogue(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        textStyle: GoogleFonts.epilogue(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: GoogleFonts.epilogue(
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade800),
      ),
    ),
  );
}
