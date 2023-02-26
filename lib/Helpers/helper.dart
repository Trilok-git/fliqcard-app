import 'package:fliqcard/Helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

var fcmtoken = "fcm";

double universalVolume = 0.0;

final GlobalKey scanQrGlobal = GlobalKey();
final GlobalKey viewCardGlobal = GlobalKey();
final GlobalKey notificationsGlobal = GlobalKey();
final GlobalKey editCardGlobal = GlobalKey();
final GlobalKey changeThemeGlobal = GlobalKey();
final GlobalKey changeFliqColorsGlobal = GlobalKey();

final GlobalKey uploadBannerGlobal = GlobalKey();
final GlobalKey uploadLogoGlobal = GlobalKey();
final GlobalKey bottombarGlobal = GlobalKey();
final GlobalKey goPremiumGlobal = GlobalKey();
final GlobalKey addAttendanceGlobal = GlobalKey();

var listOfGlobalKeys = [
  scanQrGlobal,
  viewCardGlobal,
  notificationsGlobal,
  editCardGlobal,
  changeFliqColorsGlobal,
  uploadBannerGlobal,
  uploadLogoGlobal,
  changeThemeGlobal,
  bottombarGlobal,
  goPremiumGlobal,
  addAttendanceGlobal
];

Widget buildImage(String assetName, [double width = 120]) {
  return Image.asset('$assetName', width: width);
}

void commonLaunchURL(_url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

int getColorCode(String color) {
  return int.parse(color.replaceAll("#", "0xff"));
}

String getOffset() {
  return (DateTime.now().timeZoneOffset.inMinutes.toString());
}

String localToUtc(time) {
  if ((time ?? "").toString().isNotEmpty) {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    String temp = (DateTime.parse(formattedDate + " " + time)
        .toUtc()
        .toString()
        .substring(11, 19));
    return temp;
  } else {
    return "";
  }
}

String UtcToLocal(time) {
  if ((time ?? "").toString().isNotEmpty) {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    String temp = (DateTime.parse(formattedDate + "T" + time + "Z")
        .toLocal()
        .toString()
        .substring(11, 19));

    return temp;
  } else {
    return "";
  }
}

bool isEmailValid(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return regex.hasMatch(email);
}

pushReplacement(BuildContext context, Widget destination) {
  Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => destination,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      ));
}

push(BuildContext context, Widget destination) {
  Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => destination,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      ));
}

pop(BuildContext context) {
  Navigator.pop(context);
}

void commonToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      msg: msg,
      backgroundColor: Colors.black,
      textColor: Colors.white);
}

Widget redText(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.red)));
}

Widget commonTitle(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: Color(COLOR_TITLE))));
}

Widget commonTitleBig(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
              color: Color(COLOR_PURPLE_PRIMARY))));
}

Widget commonTitleBigBold(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
              color: Color(COLOR_TITLE))));
}

Widget commonTitleSmall(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(fontSize: 14.0, color: Color(COLOR_TITLE))));
}

Widget commonTitleBigBoldWhite(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.white)));
}

Widget commonTitleSmallWhite(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(fontSize: 14.0, color: Colors.white)));
}

Widget commonTitleSmallBoldWhite(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.white)));
}

Widget commonTitleSmallBold(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(COLOR_TITLE))));
}

Widget commonTitleSmallBoldBlue(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.blue)));
}

Widget commonTitleSmallBoldRed(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.red)));
}

Widget commonSubTitle(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(fontSize: 15.0, color: Color(COLOR_SUBTITLE))));
}

Widget commonSubTitleSmall(BuildContext context, String text) {
  return Text(text,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(fontSize: 12.0, color: Color(COLOR_SUBTITLE))));
}

void logLongString(String s) {
  if (s == null || s.length <= 0) return;
  const int n = 1000;
  int startIndex = 0;
  int endIndex = n;
  while (startIndex < s.length) {
    if (endIndex > s.length) endIndex = s.length;
    print(s.substring(startIndex, endIndex));
    startIndex += n;
    endIndex = startIndex + n;
  }
}
