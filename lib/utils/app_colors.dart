import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class AppTheme {
  final String id;
  final String name;
  final Color background;
  final Color backgroundSoft;
  final Color card;
  final Color cardLight;
  final Color green; // Primary / Success
  final Color cyan;  // Secondary
  final Color purple; // Accent / Category
  final Color yellow; // Accent / Paused
  final Color red;    // Accent / Canceled / Danger
  final Color muted;  // Text Muted
  final Color textPrimary;
  final Color border;

  const AppTheme({
    required this.id,
    required this.name,
    required this.background,
    required this.backgroundSoft,
    required this.card,
    required this.cardLight,
    required this.green,
    required this.cyan,
    required this.purple,
    required this.yellow,
    required this.red,
    required this.muted,
    required this.textPrimary,
    required this.border,
  });

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        primary: green,
        secondary: cyan,
        surface: card,
        error: red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cyan),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          foregroundColor: background,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
    );
  }
}

class AppColors {
  const AppColors._();

  static AppTheme of(BuildContext context, {bool listen = true}) {
    return Provider.of<SettingsProvider>(context, listen: listen).activeTheme;
  }

  // Predefined Themes
  static const AppTheme ninjaDark = AppTheme(
    id: 'ninja_dark',
    name: 'Ninja Dark',
    background: Color(0xFF0B1020),
    backgroundSoft: Color(0xFF10172A),
    card: Color(0xFF151B2D),
    cardLight: Color(0xFF1D263D),
    green: Color(0xFF00E676),
    cyan: Color(0xFF00D4FF),
    purple: Color(0xFF8A5CFF),
    yellow: Color(0xFFFFC857),
    red: Color(0xFFFF5C7A),
    muted: Color(0xFFAAB2C8),
    textPrimary: Color(0xFFFFFFFF),
    border: Color(0x263D4966),
  );

  static const AppTheme cyberpunk = AppTheme(
    id: 'cyberpunk',
    name: 'Cyberpunk',
    background: Color(0xFF12072B),
    backgroundSoft: Color(0xFF1B0B3D),
    card: Color(0xFF1E0E38),
    cardLight: Color(0xFF2C1652),
    green: Color(0xFF00FF85),
    cyan: Color(0xFF00F0FF),
    purple: Color(0xFFFF00FF),
    yellow: Color(0xFFFFF300),
    red: Color(0xFFFF2A6D),
    muted: Color(0xFF9FA5C0),
    textPrimary: Color(0xFFFFFFFF),
    border: Color(0x40FF00FF),
  );

  static const AppTheme forest = AppTheme(
    id: 'forest',
    name: 'Eco Floresta',
    background: Color(0xFF0A1410),
    backgroundSoft: Color(0xFF10211B),
    card: Color(0xFF142921),
    cardLight: Color(0xFF1D3B30),
    green: Color(0xFF00C853),
    cyan: Color(0xFF4CAF50),
    purple: Color(0xFF81C784),
    yellow: Color(0xFFFFD54F),
    red: Color(0xFFE57373),
    muted: Color(0xFF8D9993),
    textPrimary: Color(0xFFFFFFFF),
    border: Color(0x264CAF50),
  );

  static const AppTheme sunset = AppTheme(
    id: 'sunset',
    name: 'Pôr do Sol',
    background: Color(0xFF1A1010),
    backgroundSoft: Color(0xFF2B1B1B),
    card: Color(0xFF332020),
    cardLight: Color(0xFF422B2B),
    green: Color(0xFFFFA726),
    cyan: Color(0xFFFF7043),
    purple: Color(0xFFEC407A),
    yellow: Color(0xFFFFCA28),
    red: Color(0xFFEF5350),
    muted: Color(0xFFC4B2B2),
    textPrimary: Color(0xFFFFFFFF),
    border: Color(0x26FFA726),
  );

  static const AppTheme midnight = AppTheme(
    id: 'midnight',
    name: 'Midnight Blue',
    background: Color(0xFF060913),
    backgroundSoft: Color(0xFF0D1527),
    card: Color(0xFF111C34),
    cardLight: Color(0xFF192A4E),
    green: Color(0xFF2979FF),
    cyan: Color(0xFF00B0FF),
    purple: Color(0xFFD1C4E9),
    yellow: Color(0xFFFFD740),
    red: Color(0xFFFF5252),
    muted: Color(0xFF90A4AE),
    textPrimary: Color(0xFFFFFFFF),
    border: Color(0x262979FF),
  );

  static final List<AppTheme> themes = [
    ninjaDark,
    cyberpunk,
    forest,
    sunset,
    midnight,
  ];

  // Static constant fallbacks for compilation safety during migration
  static const Color background = Color(0xFF0B1020);
  static const Color backgroundSoft = Color(0xFF10172A);
  static const Color card = Color(0xFF151B2D);
  static const Color cardLight = Color(0xFF1D263D);
  static const Color green = Color(0xFF00E676);
  static const Color cyan = Color(0xFF00D4FF);
  static const Color purple = Color(0xFF8A5CFF);
  static const Color yellow = Color(0xFFFFC857);
  static const Color red = Color(0xFFFF5C7A);
  static const Color muted = Color(0xFFAAB2C8);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color border = Color(0x263D4966);
}
