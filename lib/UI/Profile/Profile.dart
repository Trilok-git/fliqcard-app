import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Auth/ForgotScreen.dart';
import 'package:fliqcard/UI/Auth/WelcomeScreen.dart';
import 'package:fliqcard/UI/Profile/ChangePassword.dart';
import 'package:fliqcard/UI/Profile/TransactionHistory.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int counter = 0;



  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_PRIMARY),
        appBar: AppBar(
          backgroundColor: Color(0xffE3E8FF),
          title: commonTitle(context, "Profile"),
          elevation: 0,
          leading: InkWell(
            onTap: () {
              pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.arrow_back_ios,
                color: Color(COLOR_PRIMARY),
              ),
            ),
          ),
        ),
        body: Container(
            color: Color(COLOR_PRIMARY),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Color(0xffE3E8FF),
                    child: Column(children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Column(
                          children: [
                            providerListener.vcardData != null
                                ? providerListener.vcardData.profileImagePath !=
                                            null &&
                                        providerListener
                                                .vcardData.profileImagePath !=
                                            ""
                                    ? Container(
                                        width: 70.0,
                                        height: 70.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff7c94b6),
                                          image: DecorationImage(
                                            image: NetworkImage(apiUrl +
                                                "../../" +
                                                providerListener
                                                    .vcardData.profileImagePath),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100.0)),
                                        ),
                                      )
                                    : Container(
                                        width: 70.0,
                                        height: 70.0,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          image: DecorationImage(
                                            image:
                                                AssetImage("assets/profile.png"),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100.0)),
                                        ),
                                      )
                                : Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        image: AssetImage("assets/profile.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0)),
                                      border: Border.all(
                                        color: Color(int.parse(providerListener
                                            .vcardData.fontcolor
                                            .replaceAll("#", "0xff"))),
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                  (providerListener.userData.fullname ?? ""),
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(COLOR_TITLE)))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                  (providerListener.userData.email ?? "")
                                      .toString(),
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w400,
                                          color: Color(COLOR_TITLE)))),
                            ),
                            providerListener.vcardData == null
                                ? Container()
                                : Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text(
                                        (providerListener.vcardData.subtitle ??
                                            ""),
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE)))),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                child: Column(
                              children: [
                                Text(
                                  'Active Plan',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.grey[700], fontSize: 12.0),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  providerListener.memberShip != null
                                      ? providerListener.memberShip.plan
                                      : "BASIC",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey[700],
                            ),
                            Container(
                                child: Column(
                              children: [
                                Text(
                                  'Plan valid till',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.grey[700], fontSize: 12.0),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  providerListener.memberShip != null
                                      ? providerListener.memberShip.endDate
                                      : "Unlimited",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )),
                          ],
                        ),
                      )
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Center(
                        child: Card(
                            color: Color(COLOR_PURPLE_PRIMARY),
                            margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                            child: Container(
                                margin: EdgeInsets.all(10),
                                width: (SizeConfig.screenWidth) - 70,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      providerListener.userData.isStaff == "0"
                                          ? InkWell(
                                              onTap: () {
                                                push(context,
                                                    TransactionHistory());
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.payment,
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Transactions",
                                                        style: GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0,
                                                            color: Colors.white),
                                                      ),
                                                      Text(
                                                        "Payments History",
                                                        style: GoogleFonts.montserrat(
                                                            fontSize: 12.0,
                                                            color: Colors.white),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          : SizedBox(height: 1),
                                      SizedBox(
                                        height: 7.0,
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          push(context, ForgotScreen());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.vpn_key,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Forgot Password",
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "Reset password if forgotten",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12.0,
                                                      color: Colors.white),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7.0,
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.remove('id');
                                          pushReplacement(
                                              context, WelcomeScreen());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.power_settings_new_sharp,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "LogOut",
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                    ],
                                  ),
                                )))),
                  ),
                  InkWell(
                    onTap: () {
                      commonLaunchURL("mailto:fliqcard@fliqcard.com");
                    },
                    child: Text("Request for account deactivation",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            letterSpacing: 1,
                            textStyle: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white))),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
