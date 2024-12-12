import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData();

const Color greyColor = Color(0xFFEAEAEA);

Color adjustColorBrightness(Color color, {int percent = 10, bool darken = true}) {
  assert(1 <= percent && percent <= 100, 'Percent must be between 1 and 100');
  final factor = darken ? (1 - percent / 100) : (percent / 100);
  return Color.fromARGB(
    color.alpha,
    (color.red * factor + (darken ? 0 : 255 - color.red) * (1 - factor)).round(),
    (color.green * factor + (darken ? 0 : 255 - color.green) * (1 - factor)).round(),
    (color.blue * factor + (darken ? 0 : 255 - color.blue) * (1 - factor)).round(),
  );
}

ThemeData blackTheme(Color primaryColor, Color accentColor) {
  return ThemeData.dark().copyWith(
    snackBarTheme: SnackBarThemeData(
      backgroundColor: accentColor,
      actionTextColor: greyColor,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    ),
    colorScheme: ColorScheme.dark(
      secondary: accentColor,
      primary: primaryColor,
    ),
    cardColor: Colors.black,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    dialogBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionHandleColor: primaryColor,
      selectionColor: adjustColorBrightness(primaryColor, percent: 50),
    ),
    appBarTheme: AppBarTheme(
      color: primaryColor,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.disabled) ? greyColor : primaryColor,
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.disabled) ? greyColor : Colors.white,
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.black),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.disabled) ? greyColor : Colors.white,
        ),
      ),
    ),
  );
}

ThemeData lightTheme(Color primaryColor, Color accentColor) {
  return ThemeData.light().copyWith(
    canvasColor: Colors.white,
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.light(
      secondary: accentColor,
      primary: primaryColor,
    ),
    primaryColor: primaryColor,
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: accentColor,
      actionTextColor: Colors.white,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    ),
    brightness: Brightness.light,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      displayLarge: const TextStyle(color: Colors.black),
      displayMedium: const TextStyle(color: Colors.black),
      bodyLarge: const TextStyle(color: Colors.black),
      bodyMedium: const TextStyle(color: Colors.black),
      bodySmall: const TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.grey[600]),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionHandleColor: primaryColor,
      selectionColor: adjustColorBrightness(primaryColor, percent: 65, darken: false),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.disabled) ? greyColor : primaryColor,
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.disabled) ? Colors.black : Colors.white,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.disabled) ? greyColor : primaryColor,
        ),
      ),
    ), checkboxTheme: CheckboxThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return primaryColor; }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return primaryColor; }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return primaryColor; }
 return null;
 }),
 trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return primaryColor; }
 return null;
 }),
 ),
  );
}
