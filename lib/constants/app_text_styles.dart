import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  //Text Sized
  static TextStyle headerTitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    return GoogleFonts.nunito(
      fontSize: 38,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle subTitleTitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    return GoogleFonts.nunito(
      fontSize: 28,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle h0TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    return GoogleFonts.nunito(
      fontSize: 30,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle h1TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.nunito(
      fontSize: 24,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle h2TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
        fontSize: 22, fontWeight: fontWeight, color: color,fontFamily: AppFonts.appFont,);
  }

  static TextStyle h3TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,

  }) {
    return TextStyle(
      fontSize: 18,
      fontWeight: fontWeight,
      fontFamily: AppFonts.appFont,
      color: color,
    );
  }

  static TextStyle h4TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(fontFamily: AppFonts.appFont,
        fontSize: 15, fontWeight: fontWeight, color: color);
  }

  static TextStyle h5TitleTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(fontFamily: AppFonts.appFont,
        fontSize: 13, fontWeight: fontWeight, color: color);
  }

  static TextStyle h6TitleTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w300}) {
    return TextStyle(fontFamily: AppFonts.appFont,
        fontSize: 11, fontWeight: fontWeight, color: color);
  }
}
