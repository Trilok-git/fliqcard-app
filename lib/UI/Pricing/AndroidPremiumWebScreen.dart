import 'dart:io';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Auth/WelcomeScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

SharedPreferences prefs;

class AndroidPremiumWebScreen extends StatefulWidget {
  int temp;
  String selectedPlan;

  AndroidPremiumWebScreen(this.temp, [this.selectedPlan]);

  @override
  _AndroidPremiumWebScreenState createState() =>
      _AndroidPremiumWebScreenState();
}

class _AndroidPremiumWebScreenState extends State<AndroidPremiumWebScreen> {
  Future launchPricing() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: commonTitle(context, "Premium"),
          elevation: 0,
          leading: InkWell(
            onTap: () {
              pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: Container(
          child:
          Platform.isIOS?
            WebView(
              initialUrl:
              ("https://fliqcard.com/digitalcard/pricing2.php?ios=yes&id=" +
                  (providerListener.userData.id ?? "") +
                  "&refcode=" +
                  (providerListener.userData.refcode ?? "")),
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (String url) {
                print('Page started loading: $url');
                if ((url ?? "") == "https://fliqcard.com/digitalcard/" ||
                    (url ?? "") == "https://fliqcard.com/digitalcard/index.php") {
                  if (widget.temp == 2) {
                    pop(context);
                    pop(context);
                    pop(context);
                  } else {
                    pop(context);
                    pop(context);
                  }

                  pushReplacement(context, WelcomeScreen());
                }
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            )

            :
          WebView(
              initialUrl:
                  ("https://fliqcard.com/digitalcard/pricing2.php?ios=no&id=" +
                      (providerListener.userData.id ?? "") +
                      "&refcode=" +
                      (providerListener.userData.refcode ?? "")),
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (String url) {
                print('Page started loading: $url');
                if ((url ?? "") == "https://fliqcard.com/digitalcard/" ||
                    (url ?? "") == "https://fliqcard.com/digitalcard/index.php") {
                  if (widget.temp == 2) {
                    pop(context);
                    pop(context);
                    pop(context);
                  } else {
                    pop(context);
                    pop(context);
                  }

                  pushReplacement(context, WelcomeScreen());
                }
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            ),
        ),
      ),
    );
  }
}
