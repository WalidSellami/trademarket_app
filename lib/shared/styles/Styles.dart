

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Varela',
  colorScheme: ColorScheme.light(
    primary: firstLightColor,
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      fontSize: 17.0,
      color: Colors.black,
      fontFamily: 'Varela',
      fontWeight: FontWeight.bold,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),

);





ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: firstDarkColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Varela',
  colorScheme: ColorScheme.dark(
    primary: secondDarkColor,
  ),
  appBarTheme: AppBarTheme(
    color:firstDarkColor,
    elevation: 0,
    titleTextStyle: const TextStyle(
      fontSize: 17.0,
      color: Colors.white,
      fontFamily: 'Varela',
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: firstDarkColor,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: firstDarkColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),



);



Color firstLightColor = HexColor('0070CC');

Color redColor = HexColor('f9325f');

Color greenColor = HexColor('009b9b');


Color firstDarkColor = HexColor('161616');

Color secondDarkColor = HexColor('2183D2');