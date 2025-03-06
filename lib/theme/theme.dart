import 'package:flutter/material.dart';
import 'package:modulo/theme/widget_themes/text_theme.dart';
import 'package:modulo/utils/constants/colors.dart';

class RecipesTheme {
  RecipesTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: MyColors.grey,
    brightness: Brightness.light,
    primaryColor: MyColors.primary,
    textTheme: TTextTheme.lightTextTheme,

    tabBarTheme: const TabBarTheme(
      labelColor: MyColors.primary,
      unselectedLabelColor: null,
      labelStyle: TextStyle(
        fontSize: 14,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
      ), // Make highlighted tab text bolder
      unselectedLabelStyle: TextStyle(fontSize: 14, fontFamily: "Poppins"),
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyColors.primary,
            width: 3.0,
          ), // Make indicator taller
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MyColors.primary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: MyColors.grey,
    brightness: Brightness.dark,
    primaryColor: MyColors.primary,
    textTheme: TTextTheme.darkTextTheme,
    scaffoldBackgroundColor: MyColors.black,

    tabBarTheme: const TabBarTheme(
      labelColor: MyColors.primary,
      unselectedLabelColor: null,
      labelStyle: TextStyle(
        fontSize: 14,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
      ), // Make highlighted tab text bolder
      unselectedLabelStyle: TextStyle(fontSize: 14, fontFamily: "Poppins"),
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyColors.primary,
            width: 3.0,
          ), // Make indicator taller
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MyColors.primary,
    ),
  );
}
