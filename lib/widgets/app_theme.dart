import 'package:flutter/material.dart';
import 'package:velvet_projekt/widgets/constants.dart';

final appTheme = ThemeData(
  primaryColor: AppConstants.primaryColor,
  colorScheme: ColorScheme.light(
    primary: AppConstants.primaryColor,
    secondary: AppConstants.secondaryColor,
    error: AppConstants.errorColor,
  ),
  scaffoldBackgroundColor: Colors.grey[50],
  appBarTheme: AppBarTheme(
    backgroundColor: AppConstants.primaryColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
    ),
    margin: EdgeInsets.all(AppConstants.defaultPadding / 2),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppConstants.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppConstants.defaultPadding,
      vertical: AppConstants.defaultPadding / 1.5,
    ),
  ),
);