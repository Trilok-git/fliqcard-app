import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/Models/AppVersionParser.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainScreen.dart';
import '../NoInternet.dart';
import 'CreateFliqCard.dart';
import 'LoginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PackageInfo packageInfo;
  String app_build = "";
  String app_version = "";
  bool _isloaded = false;

  Future checkVersion() async {
    setState(() {
      _isloaded = false;
    });
    packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      app_build = packageInfo.buildNumber;
      app_version = packageInfo.version;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .getAppVersion()
        .then((value) {
      setState(() {
        if (value == "success") {
          Provider.of<CustomViewModel>(context, listen: false)
              .getappVersionParser()
              .then((value) {
            AppVersionParser appVersionParser = value;
            if (Platform.isAndroid) {
              if (int.parse(app_build) >=
                  int.parse(appVersionParser.androidVersion)) {
                initTask();
              } else {
                showForceAlertDialog(context, appVersionParser.playstore ?? "");
              }
            } else {
              if (int.parse(app_build) >=
                  int.parse(appVersionParser.iosVersion)) {
                initTask();
              } else {
                showForceAlertDialog(context, appVersionParser.appstore ?? "");
              }
            }
          });
        } else {
          commonToast(context, value);
        }
      });
    });
  }

  Future initTask() async {
    await Firebase.initializeApp();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id") ?? "null";

    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isloaded = true;
    });
    if (connectivityResult == ConnectivityResult.mobile) {
      if (id != null && id != "null") {
        pushReplacement(context, MainScreen());
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (id != null && id != "null") {
        pushReplacement(context, MainScreen());
      }
    } else {
      if (id != null && id != "null") {
        pushReplacement(context, NoInternet(id));
      } else {
        pushReplacement(context, NoInternet("0"));
      }
    }
  }

  void showForceAlertDialog(BuildContext context, String url) {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: new Text("Update Required!"),
              content: new Text(
                  "Upgrade to the new improved version of FliQCard app."),
              actions: [
                CupertinoButton(
                  child: Text('Update'),
                  onPressed: () {
                    commonLaunchURL(url ?? "");
                  },
                )
              ],
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const bodyStyle = TextStyle(fontSize: 19.0, color: Color(COLOR_SUBTITLE));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isloaded == false
            ? Container(
                height: SizeConfig.screenHeight / 1.1,
                color: Colors.white,
                child: Center(
                  child: new CircularProgressIndicator(
                    strokeWidth: 1,
                    backgroundColor: Color(COLOR_PRIMARY),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 50, bottom: 40),
                child: Center(
                    child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: buildImage('assets/logo.png'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Welcome to FliQCard",
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1,
                                  textStyle: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(COLOR_TITLE)))),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                              "Let's get your new FliQCard\nbusiness card set up",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1,
                                  textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: Color(COLOR_TITLE)))),
                          SizedBox(height: 30),
                          InkWell(
                            onTap: () {
                              push(context, CreateFliqCard());
                              //push(context, SignUp());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          20.0) //                 <--- border radius here
                                      ),
                                  color: Color(COLOR_PURPLE_PRIMARY)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 50),
                                child: Text("CREATE A CARD",
                                    style: GoogleFonts.montserrat(
                                        letterSpacing: 1,
                                        textStyle: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white))),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          InkWell(
                            onTap: () {
                              pushReplacement(context, LoginScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 15),
                              child: Text("LOGIN WITH EXISTING ACCOUNT",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      letterSpacing: 1,
                                      textStyle: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(COLOR_TITLE)))),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("By continuing, I agree to the ",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        letterSpacing: 1,
                                        textStyle: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(COLOR_TITLE)))),
                                InkWell(
                                  onTap: () {
                                    commonLaunchURL(
                                        "https://fliqcard.com/digitalcard/privacypolicy.php");
                                  },
                                  child: Text("Privacy Policy",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          decoration: TextDecoration.underline,
                                          letterSpacing: 1,
                                          textStyle: TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blue.shade800))),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(" & ",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        letterSpacing: 1,
                                        textStyle: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(COLOR_TITLE)))),
                                InkWell(
                                  onTap: () {
                                    commonLaunchURL(
                                        "https://fliqcard.com/digitalcard/terms.php");
                                  },
                                  child: Text("Terms of service",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          decoration: TextDecoration.underline,
                                          letterSpacing: 1,
                                          textStyle: TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blue.shade800))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ),
      ),
    );
  }
}
