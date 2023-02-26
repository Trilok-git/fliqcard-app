import 'dart:io';
import 'dart:typed_data';

import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:flutter/material.dart';

import 'Pricing/PricingScreen.dart';

GoPremiumWidget(BuildContext context, int temp) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  final providerListener = Provider.of<CustomViewModel>(context);

  return InkWell(
    onTap: () {},
    child: Container(
      margin: EdgeInsets.all(5),
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 1, right: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*  Container(
              width: screenWidth / 3,
              child: Image.asset(
                "assets/crown.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: commonTitleSmallBold(context,
                        "Go premium to access \n1. Contacts \n2. Themes\n3. personlized link\n4.Radar sharing\n5. Card listing\n6. Customized QR Code\n and many more features")),
              ],
            ),*/
            providerListener.userData != null
                ? providerListener.userData.isStaff != "1"
                    ? InkWell(
                        onTap: () {
                          if (Platform.isAndroid) {
                            push(context, PricingScreen(temp));
                          } else {
                            commonToast(context, "Visit fliqcard.com");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.asset(
                              Platform.isAndroid
                                  ? "assets/premium_android.png"
                                  : "assets/premium_ios.png",
                              width: screenWidth),
                        ),
                      )
                    : SizedBox(
                        height: 1,
                      )
                : SizedBox(
                    height: 1,
                  ),
          ],
        ),
      ),
    ),
  );
}
