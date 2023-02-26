import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/MainScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CreateFliqCard.dart';
import 'LoginScreen.dart';
import 'WelcomeScreen.dart';

class VerifiedEmailScreen extends StatefulWidget {
  @override
  _VerifiedEmailScreenState createState() => _VerifiedEmailScreenState();
}

class _VerifiedEmailScreenState extends State<VerifiedEmailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, color: Color(COLOR_SUBTITLE));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_PURPLE_PRIMARY).withOpacity(0.1),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
                child: Stack(
              children: [
                Image.asset(
                  "assets/bg_curve.png",
                  width: SizeConfig.screenWidth,
                ),
                Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Image.asset(
                            "assets/congratulations.png",
                            width: SizeConfig.screenWidth / 1.7,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Your Business card created successfully.",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              letterSpacing: 0.7,
                              fontWeight: FontWeight.w400,
                              fontSize: 17.0,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          /*Container(
                            width: SizeConfig.screenWidth / 1.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                        7.0) ////              <--- border radius here
                                    ),
                                color:
                                    Color(COLOR_PURPLE_PRIMARY).withOpacity(0.1)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.screen_share,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Share your business card with",
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 0.7,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),*/
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                        "We have sent you an email,\nPlease verify it by clicking on\nthe given link",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 16.0,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w400,
                                color: Color(COLOR_TITLE)))),
                    SizedBox(
                      height: 150,
                    ),
                    InkWell(
                      onTap: () {
                        Provider.of<CustomViewModel>(context, listen: false)
                            .setBottomIndex(1);
                        pushReplacement(context, MainScreen());
                      },
                      child: Container(
                        height: 50,
                        width: SizeConfig.screenWidth / 1.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                    7.0) //                 <--- border radius here
                                ),
                            color: Color(COLOR_PURPLE_PRIMARY)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Text("Proceed",
                                style: GoogleFonts.montserrat(
                                    letterSpacing: 1,
                                    textStyle: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),


                    InkWell(
                      onTap: () {
                        commonLaunchURL("mailto:fliqcard@fliqcard.com");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("If email not received,",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1,
                                  textStyle: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade700))),
                          Text(" Click here ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1,
                                  textStyle: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(COLOR_PURPLE_PRIMARY)))),
                          Text("to drop us",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1,
                                  textStyle: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade700))),
                        ],
                      ),
                    ),
                    Text("message from registered email address.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            letterSpacing: 1,
                            textStyle: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade700))),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        prefs.remove('id');
                        pushReplacement(context, WelcomeScreen());
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("OR\n\n",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1,
                                  textStyle: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade700))),
                          Text("Create New Account",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1,
                                  textStyle: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(COLOR_PURPLE_PRIMARY)))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
