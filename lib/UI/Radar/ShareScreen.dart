import 'dart:io';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Pricing/PricingScreen.dart';
import 'package:fliqcard/UI/ScanQR/ScanQRScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../GoPremiumWidget.dart';
import 'RadarScreen.dart';
import 'SelectWhomToSentScreen.dart';
import 'TempReceivedCards.dart';

void _launchURL(String _url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

class ShareScreen extends StatefulWidget {
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;
  Color _currentColor = Color(COLOR_PRIMARY);
  Color tempColor = Color(COLOR_PRIMARY);

  getLocation(int temp) async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        commonToast(context, "TO use Radar sharing location is required!");
      } else {}
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        updateLocation(temp);
      } else {
        commonToast(context, "TO use Radar sharing location is required!");
      }
    } else if (_permissionGranted == PermissionStatus.granted) {
      updateLocation(temp);
    }
  }

  Future updateLocation(int temp) async {
    _locationData = await location.getLocation();
    print(_locationData);
    EasyLoading.show(status: 'loading...');

    Provider.of<CustomViewModel>(context, listen: false)
        .UpdateLocation(
      _locationData.latitude.toString(),
      _locationData.longitude.toString(),
    )
        .then((value) {
      if (temp == 1) {
        Provider.of<CustomViewModel>(context, listen: false)
            .Findnearbyusers(_locationData.latitude.toString(),
                _locationData.longitude.toString())
            .then((value) {
          EasyLoading.dismiss();
          setState(() {
            if (value == "success") {
              push(context, SelectWhomToSentScreen());
              //commonToast(context, "Card send!");
            } else {
              commonToast(context, value);
            }
          });
        });
      } else {
        EasyLoading.dismiss();
        push(context, TempReceivedCards());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return providerListener.vcardData == null
        ? Container()
        : Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: providerListener.memberShip != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 15.0,
                              color:
                                  Color(COLOR_PURPLE_PRIMARY).withOpacity(0.2)),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  5.0) ////              <--- border radius here
                              ),
                        ),
                        child: RepaintBoundary(
                          key: previewContainer,
                          child: (providerListener.vcardData.logoImagePath ??
                                      "") ==
                                  ""
                              ? QrImage(
                                  foregroundColor: _currentColor,
                                  backgroundColor: Colors.white,
                                  data: apiUrl +
                                      "/../visitcard.php?id=" +
                                      providerListener.userData.id,
                                  version: QrVersions.auto,
                                  size: SizeConfig.screenWidth / 1.2,
                                  gapless: true,
                                )
                              : QrImage(
                                  foregroundColor: _currentColor,
                                  backgroundColor: Colors.white,
                                  data: apiUrl +
                                      "/../visitcard.php?id=" +
                                      providerListener.userData.id,
                                  version: QrVersions.auto,
                                  size: SizeConfig.screenWidth / 1.2,
                                  gapless: true,
                                  embeddedImage: NetworkImage(apiUrl +
                                      "../../" +
                                      providerListener.vcardData.logoImagePath),
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: Size(60, 60),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Dark color recommended'),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: tempColor,
                                          onColorChanged: (v) {
                                            setState(() {
                                              tempColor = v;
                                            });
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(COLOR_SECONDARY),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 5),
                                              textStyle: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                          child: Text(
                                            'UPDATE',
                                            style: GoogleFonts.montserrat(
                                                color: Color(COLOR_PRIMARY)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _currentColor = tempColor;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(COLOR_PURPLE_PRIMARY),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  border: Border.all(
                                      color: Color(COLOR_PURPLE_PRIMARY),
                                      width: 1)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/filter_icon.png",
                                    width: 22,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text("Customize QR",
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white))),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ShareFilesAndScreenshotWidgets().shareScreenshot(
                                  previewContainer,
                                  originalSize,
                                  "FliQCard",
                                  "FliQCard.png",
                                  "image/png",
                                  text: "Hi, Checkout My FliQCard!");
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xffE3E8FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  border: Border.all(
                                      color: Color(COLOR_PURPLE_PRIMARY),
                                      width: 1)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/download_icon.png",
                                    width: 22,
                                    color: Color(COLOR_PURPLE_PRIMARY),
                                  ),
                                  SizedBox(width: 10),
                                  Text("Download QR",
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color(
                                                  COLOR_PURPLE_PRIMARY)))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                push(context, RadarScreen());
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xffE3E8FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 17, vertical: 10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundImage:
                                          AssetImage('assets/rec2.png'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    SizedBox(width: 10),
                                    commonTitleSmallBold(context, "Radar"),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (providerListener.vcardData != null) {
                                  if (providerListener.vcardData.slug != null &&
                                      providerListener.vcardData.slug != "") {
                                    Share.share(
                                        "Check out my business card and click add to contact to save that for future\n\n\n" +
                                            ("https://fliqcard.com/id.php?name=" +
                                                providerListener
                                                    .vcardData.slug));
                                  } else {
                                    Share.share(
                                        "Check out my business card and click add to contact to save that for future\n\n\n" +
                                            ("https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                                providerListener.userData.id));
                                  }
                                } else {
                                  Share.share(
                                      "Check out my business card and click add to contact to save that for future\n\n\n" +
                                          ("https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                              providerListener.userData.id));
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xffE3E8FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.share,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 10),
                                    commonTitleSmallBold(context, "Share with"),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (providerListener.vcardData != null) {
                                  if (providerListener.vcardData.slug != null &&
                                      providerListener.vcardData.slug != "") {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "https://fliqcard.com/id.php?name=" +
                                                providerListener
                                                    .vcardData.slug));
                                  } else {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                                providerListener.userData.id));
                                  }
                                } else {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                              providerListener.userData.id));
                                }

                                commonToast(context, "Copied to clipboard");
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xffE3E8FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 10),
                                    commonTitleSmallBold(context, "Copy Link"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  )
                : Column(
                    children: [
                      GoPremiumWidget(context, 1),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 15.0,
                                    color: Color(COLOR_PURPLE_PRIMARY)
                                        .withOpacity(0.2)),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        5.0) ////              <--- border radius here
                                    ),
                              ),
                              child: RepaintBoundary(
                                key: previewContainer,
                                child: QrImage(
                                  foregroundColor: _currentColor,
                                  backgroundColor: Colors.white,
                                  data: apiUrl +
                                      "/../visitcard.php?id=" +
                                      providerListener.userData.id,
                                  version: QrVersions.auto,
                                  size: SizeConfig.screenWidth / 1.2,
                                  gapless: true,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (Platform.isAndroid) {
                                      push(context, PricingScreen(1));
                                    } else {
                                      commonToast(
                                          context, "Visit fliqcard.com");
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Color(COLOR_PURPLE_PRIMARY),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(
                                            color: Color(COLOR_PURPLE_PRIMARY),
                                            width: 1)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/filter_icon.png",
                                          width: 22,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text("Customize QR",
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white))),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    ShareFilesAndScreenshotWidgets()
                                        .shareScreenshot(
                                            previewContainer,
                                            originalSize,
                                            "FliQCard",
                                            "FliQCard.png",
                                            "image/png",
                                            text: "Hi, Checkout My FliQCard!");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Color(0xffE3E8FF),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(
                                            color: Color(COLOR_PURPLE_PRIMARY),
                                            width: 1)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/download_icon.png",
                                          width: 22,
                                          color: Color(COLOR_PURPLE_PRIMARY),
                                        ),
                                        SizedBox(width: 10),
                                        Text("Download QR",
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(
                                                        COLOR_PURPLE_PRIMARY)))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                push(context, RadarScreen());
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xffE3E8FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 17, vertical: 10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundImage:
                                          AssetImage('assets/rec2.png'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    SizedBox(width: 10),
                                    commonTitleSmallBold(context, "Radar"),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (providerListener.vcardData != null) {
                                  if (providerListener.vcardData.slug != null &&
                                      providerListener.vcardData.slug != "") {
                                    Share.share(
                                        "Check out my business card and click add to contact to save that for future\n\n\n" +
                                            ("https://fliqcard.com/id.php?name=" +
                                                providerListener
                                                    .vcardData.slug));
                                  } else {
                                    Share.share(
                                        "Check out my business card and click add to contact to save that for future\n\n\n" +
                                            ("https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                                providerListener.userData.id));
                                  }
                                } else {
                                  Share.share(
                                      "Check out my business card and click add to contact to save that for future\n\n\n" +
                                          ("https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                              providerListener.userData.id));
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xffE3E8FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.share,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 10),
                                    commonTitleSmallBold(context, "Share with"),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (providerListener.vcardData != null) {
                                  if (providerListener.vcardData.slug != null &&
                                      providerListener.vcardData.slug != "") {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "https://fliqcard.com/id.php?name=" +
                                                providerListener
                                                    .vcardData.slug));
                                  } else {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                                providerListener.userData.id));
                                  }
                                } else {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                              providerListener.userData.id));
                                }

                                commonToast(context, "Copied to clipboard");
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xffE3E8FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 10),
                                    commonTitleSmallBold(context, "Copy Link"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
  }
}
