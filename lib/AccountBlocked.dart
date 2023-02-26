import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/UI/Auth/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Helpers/helper.dart';

buildAccountBlockedWidget(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return SafeArea(
    child: Scaffold(
      body: InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(10),
          width: screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Container(
                  width: screenWidth,
                  child: Icon(
                    Icons.block,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Account has been blocked by admin. Please contact support at fliqcard@fliqcard.com",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: Color(COLOR_PRIMARY),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('id');
                    pop(context);
                    push(context, WelcomeScreen());
                  },
                  leading: Icon(Icons.power_settings_new_outlined),
                  title: commonTitleSmallBold(context, 'LogOut'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
