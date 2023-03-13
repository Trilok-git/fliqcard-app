import 'dart:io';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AndroidPremiumWebScreen.dart';
import 'paymentSuccessWebScreen.dart';

SharedPreferences prefs;

class PricingScreen extends StatefulWidget {
  int temp;

  PricingScreen(this.temp);

  @override
  _PricingScreenState createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  String selectedPlan = "";
  String selectedPrice = "";


  List<PaymentItem> _paymentItems = [];



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        body:
        // body: Platform.isIOS
        //     ? Container(
        //         height: SizeConfig.screenHeight,
        //         width: SizeConfig.screenWidth,
        //         decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //             begin: Alignment.topLeft,
        //             end: Alignment.bottomRight,
        //             colors: [
        //               Color(COLOR_PRIMARY),
        //               Color(COLOR_PRIMARY),
        //               Color(COLOR_PURPLE_PRIMARY),
        //             ],
        //           ),
        //         ),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             SizedBox(height: 15),
        //             Padding(
        //               padding: const EdgeInsets.all(30.0),
        //               child: Text(
        //                 "You can't upgrade to premium in the app. We know, it's not ideal.",
        //                 textAlign: TextAlign.start,
        //                 style: GoogleFonts.montserrat(
        //                   letterSpacing: 1,
        //                   textStyle: TextStyle(
        //                     fontSize: 14.0,
        //                     fontWeight: FontWeight.w600,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 30, vertical: 10),
        //               child: Text(
        //                 "Become a member and Enjoy unlimited exclusive deals and more!",
        //                 textAlign: TextAlign.start,
        //                 style: GoogleFonts.montserrat(
        //                   letterSpacing: 1,
        //                   textStyle: TextStyle(
        //                     fontSize: 18.0,
        //                     fontWeight: FontWeight.w600,
        //                     color: Colors.yellow.shade200,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             SizedBox(height: 20),
        //             Padding(
        //               padding: const EdgeInsets.all(30.0),
        //               child: Text(
        //                 "Please Visit FliQCard.com",
        //                 textAlign: TextAlign.start,
        //                 style: GoogleFonts.montserrat(
        //                   letterSpacing: 1,
        //                   textStyle: TextStyle(
        //                     fontSize: 16.0,
        //                     fontWeight: FontWeight.w600,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       )
        //     :
        Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(COLOR_PRIMARY),
                      Color(COLOR_PURPLE_PRIMARY),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 60),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Image.asset("assets/active_plan.png",
                                width: 80),
                          ),
                          InkWell(
                            onTap: () {
                              pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth / 6,
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          Text("Choose your plan",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  letterSpacing: 1,
                                  textStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white))),
                          Container(
                            width: SizeConfig.screenWidth / 6,
                            height: 1,
                            color: Colors.grey.shade300,
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          if(Platform.isIOS) {
                            setState(() {
                              selectedPlan = "EXECUTIVE";
                              selectedPrice = '30.00';
                              _paymentItems = [
                                PaymentItem(
                                  label: selectedPlan,
                                  amount: selectedPrice,
                                  status: PaymentItemStatus.final_price,
                                )
                              ];
                            });
                            print(selectedPrice);
                            print(_paymentItems[0].label);
                            print(_paymentItems[0].amount);
                          }else {
                            push(context, AndroidPremiumWebScreen(widget.temp));
                          }
                        },
                        child: Center(
                          child: Container(
                            height: 45,
                            width: SizeConfig.screenWidth / 1.1,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                border: Border.all(
                                    width: 1.5, color: Colors.white)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 10),
                                      child: Icon(
                                        Icons.circle,
                                        color: Color(COLOR_PURPLE_PRIMARY)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    Text(
                                      "EXECUTIVE",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(COLOR_PRIMARY),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 5),
                                      child: Text(
                                        currencySymbl + "2.5 / Month",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(COLOR_PRIMARY),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Icon(
                                        Icons.info,
                                        color: Colors.yellow.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          if(Platform.isIOS) {
                            setState(() {
                              selectedPlan = "E - COMM";
                              selectedPrice = "42.00";
                              _paymentItems = [
                                PaymentItem(
                                  label: selectedPlan,
                                  amount: selectedPrice,
                                  status: PaymentItemStatus.final_price
                                )
                              ];
                            });
                            print(selectedPrice);
                            print(_paymentItems[0].label);
                            print(_paymentItems[0].amount);
                          }else {
                            push(context, AndroidPremiumWebScreen(widget.temp));
                          }
                        },
                        child: Center(
                          child: Container(
                            height: 45,
                            width: SizeConfig.screenWidth / 1.1,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                border: Border.all(
                                    width: 1.5, color: Colors.white)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 10),
                                      child: Icon(
                                        Icons.circle,
                                        color: Color(COLOR_PURPLE_PRIMARY)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    Text(
                                      "E - COMM",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(COLOR_PRIMARY),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 5),
                                      child: Text(
                                        currencySymbl + "3.5 / Month",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(COLOR_PRIMARY),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Icon(
                                        Icons.info,
                                        color: Colors.yellow.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          if(Platform.isIOS) {
                            setState(() {
                              selectedPlan = "CORPORATE";
                              selectedPrice = "126.00";
                              _paymentItems = [
                                PaymentItem(
                                  label: selectedPlan,
                                  amount: selectedPrice,
                                  status: PaymentItemStatus.final_price,
                                )
                              ];
                            });
                          }else {
                            push(context, AndroidPremiumWebScreen(widget.temp));
                          }
                        },
                        child: Center(
                          child: Container(
                            height: 45,
                            width: SizeConfig.screenWidth / 1.1,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                border: Border.all(
                                    width: 1.5, color: Colors.white)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 10),
                                      child: Icon(
                                        Icons.circle,
                                        color: Color(COLOR_PURPLE_PRIMARY)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    Text(
                                      "CORPORATE",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(COLOR_PRIMARY),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 5),
                                      child: Text(
                                        currencySymbl + "10 / Month",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(COLOR_PRIMARY),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Icon(
                                        Icons.info,
                                        color: Colors.yellow.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedPlan = "CORPORATE PLUS+";
                          });
                        },
                        child: Center(
                          child: Container(
                            height: 45,
                            width: SizeConfig.screenWidth / 1.1,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                border: Border.all(
                                    width: 1.5, color: Colors.white)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 10),
                                      child: Icon(
                                        Icons.circle,
                                        color: Color(COLOR_PURPLE_PRIMARY)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    Text(
                                      "CORPORATE PLUS+",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(COLOR_PRIMARY),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 5),
                                      child: Text(
                                        "Contact Us",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(COLOR_PRIMARY),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Icon(
                                        Icons.info,
                                        color: Colors.yellow.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      selectedPlan == ""
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(left: 20, top: 40),
                              child: Text(
                                "Features in " +
                                    (selectedPlan.toString()) +
                                    " Plan",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                  letterSpacing: 1,
                                  textStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      selectedPlan != "EXECUTIVE"
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 10,
                              ),
                              child: Text(
                                "\n- Create a digital business card for yourself\n\n- Create & assign 3 FliQCard for your business\n\n- Share your card via  QRcode, email, text\n\n- Address book with unlimited contacts\n\n- Paper business card scanner\n\n- Virtual backgrounds\n\n- Email signatures\n\n- Add marketing material\n\n- Include a profile video\n\n- Social media share\n\n- Custom colors Design\n\n- Personalized link\n\n- Card Listing\n\n- Radar sharing\n\n- Add tag & note to Your Contact\n\n- Access to all premium themes",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                  letterSpacing: 0.7,
                                  textStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      selectedPlan != "E - COMM"
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 10,
                              ),
                              child: Text(
                                "\n- Create a digital business card for yourself\n\n- Create & assign 3 FliQCard for your business\n\n- Ecommerce Products and Services Theme\n\n- Share your card via  QRcode, email, text\n\n- Address book with unlimited contacts\n\n- Paper business card scanner\n\n- Virtual backgrounds\n\n- Email signatures\n\n- Include a profile video\n\n- Add marketing material\n\n- Include a profile video\n\n- Social media share\n\n- Custom colors Design\n\n- Personalized link\n\n- Card Listing\n\n- Radar sharing\n\n- Add tag & note to Your Contact\n\n- Access to all premium themes\n\n- Business-level support\n\n- Staff management",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                  letterSpacing: 0.7,
                                  textStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      selectedPlan != "CORPORATE"
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 10,
                              ),
                              child: Text(
                                "\n- Create a digital business card for yourself\n\n- Create & assign 25 FliQCard for your business\n\n- Ecommerce Products and Services Theme\n\n- Share your card via  QRcode, email, text\n\n- Address book with unlimited contacts\n\n- Paper business card scanner\n\n- Virtual backgrounds\n\n- Email signatures\n\n- Include a profile video\n\n- Add marketing material\n\n- Include a profile video\n\n- Social media share\n\n- Custom colors Design\n\n- Personalized link\n\n- Card Listing\n\n- Radar sharing\n\n- Add tag & note to Your Contact\n\n- Access to all premium themes\n\n- Business-level support\n\n- Staff management",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                  letterSpacing: 0.7,
                                  textStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      selectedPlan != "CORPORATE PLUS+"
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 10,
                              ),
                              child: Text(
                                "\n- Includes everything from the corporate plan\n\n- Ecommerce products and services theme\n\n- Digital business cards for the entire team\n   volume pricing\n\n- Multiple administrators\n\n- Address book with unlimited contacts\n\n- Paper business card scanner\n\n- Organization view and card control\n\n- Add/remove employees and edit their\n  permissions\n\n- Business-level support",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                  letterSpacing: 0.7,
                                  textStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 45),
                      selectedPlan == ""
                          ? Container()
                          : Platform.isIOS && selectedPlan != "CORPORATE PLUS+"?

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ApplePayButton(
                                  paymentConfigurationAsset: 'apple pay/applepay.json',
                                  paymentItems: _paymentItems,
                                  style: ApplePayButtonStyle.black,
                                  type: ApplePayButtonType.checkout,
                                  width: 200,
                                  height: 50,
                                  margin: const EdgeInsets.only(top: 15.0),
                                  onPaymentResult: (value) {
                                    print(value);
                                    push(context, PaymentSuccessWebScreen(selectedPlan,selectedPrice,widget.temp));
                                  },
                                  onError: (error) {
                                    pop(context);
                                    commonToast(context, "something went wrong");
                                    print(error);
                                  },
                                  loadingIndicator: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ],
                            )
                          :InkWell(
                            onTap: () {
                              push(context, AndroidPremiumWebScreen(widget.temp));
                            },
                            child: Center(
                              child: Container(
                                height: 45,
                                width: SizeConfig.screenWidth / 1.5,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    border:
                                        Border.all(width: 2, color: Colors.white)),
                                child: Center(
                                  child: Text(
                                    "Upgrade Plan",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      selectedPlan == ""
                          ? Container()
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  commonLaunchURL(
                                      "https://fliqcard.com/digitalcard/terms.php");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 10, top: 20),
                                  child: Text(
                                    "T&C apply",
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.montserrat(
                                      letterSpacing: 0.7,
                                      textStyle: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      SizedBox(height: 45),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
