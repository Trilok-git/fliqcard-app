import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Contacts/UpdateContactScreen.dart';
import 'package:fliqcard/UI/Pricing/PricingScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:overlay_dialog/overlay_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../MainScreen.dart';
import 'buildSocialIcons.dart';

BuildContext parentContext;

class firstThemeScreen extends StatefulWidget {
  BuildContext ShowCaseContext;

  firstThemeScreen(this.ShowCaseContext);

  @override
  _firstThemeScreenState createState() => _firstThemeScreenState();
}

class _firstThemeScreenState extends State<firstThemeScreen> {
  final picker = ImagePicker();

  File _logo;

  Future _pickLogoImage() async {
    /* try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          EasyLoading.show(status: 'Uploading...');
          _logo = File(pickedFile.path);
          Provider.of<CustomViewModel>(context, listen: false)
              .UploadLogo(_logo)
              .then((value) {
            EasyLoading.dismiss();
            pushReplacement(context, MainScreen());
          });
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }*/

    try {
      List<Media> _listImagePaths = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          selectCount: 1,
          showGif: false,
          showCamera: false,
          compressSize: 500,
          uiConfig: UIConfig(uiThemeColor: Color(COLOR_PURPLE_PRIMARY)),
          cropConfig: CropConfig(enableCrop: true));

      _listImagePaths.forEach((media) {
        EasyLoading.show(status: 'Uploading...');
        _logo = File(media.path);
        if (_logo != null) {
          Provider.of<CustomViewModel>(context, listen: false)
              .UploadLogo(_logo)
              .then((value) {
            EasyLoading.dismiss();
            pushReplacement(context, MainScreen());
          });
        }
      });
    } on PlatformException {}
  }

  Future _pickBannerImage() async {
    try {
      List<Media> _listLogoPaths = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          selectCount: 1,
          showGif: false,
          showCamera: false,
          compressSize: 500,
          uiConfig: UIConfig(uiThemeColor: Color(COLOR_PURPLE_PRIMARY)),
          cropConfig: CropConfig(enableCrop: true));

      _listLogoPaths.forEach((media) {
        EasyLoading.show(status: 'Uploading...');
        _logo = File(media.path);
        if (_logo != null) {
          Provider.of<CustomViewModel>(context, listen: false)
              .UploadBanner(_logo)
              .then((value) {
            EasyLoading.dismiss();
            pushReplacement(context, MainScreen());
          });
        }
      });
    } on PlatformException {}
  }

  @override
  void initState() {
    super.initState();
  }

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    setState(() {
      parentContext = context;
    });

    return Container(
        margin: EdgeInsets.all(5),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Color(int.parse(providerListener.vcardData.bgcolor
                      .replaceAll("#", "0xff"))),
                  child: Container(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: providerListener.vcardData
                                                    .bannerImagePath !=
                                                null &&
                                            providerListener.vcardData
                                                    .bannerImagePath !=
                                                "" &&
                                            !providerListener
                                                .vcardData.bannerImagePath
                                                .contains("mp4")
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              (apiUrl +
                                                      "/../" +
                                                      providerListener.vcardData
                                                          .bannerImagePath) ??
                                                  "",
                                            ),
                                            fit: BoxFit.fill,
                                          )
                                        : null,
                                    color: Color(int.parse(providerListener
                                        .vcardData.cardcolor
                                        .replaceAll("#", "0xff"))),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0)),
                                  ),
                                  width: double.infinity,
                                  child: Column(

                                      children: [

                                    SizedBox(
                                      height: 20.0,
                                    ),

                                    Stack(
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: providerListener.vcardData
                                                          .logoImagePath !=
                                                      "" &&
                                                  providerListener.vcardData
                                                          .logoImagePath !=
                                                      null
                                              ? Container(
                                                  width: 70.0,
                                                  height: 70.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(apiUrl +
                                                          "../../" +
                                                          providerListener
                                                              .vcardData
                                                              .logoImagePath),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: 70.0,
                                                  height: 70.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/placeholder.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                        ),

                                        providerListener.vcardData
                                                    .centralized_center_on ==
                                                "1"
                                            ? Positioned(
                                                bottom: 1,
                                                right: 1,
                                                child: Container())
                                            : Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            //this right here
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(10),
                                                                            topRight: Radius.circular(10)),
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Color(COLOR_PRIMARY),
                                                                            Color(COLOR_PRIMARY),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(15.0),
                                                                            child: Text("Edit Logo",
                                                                                textScaleFactor: 1,
                                                                                style: GoogleFonts.montserrat(textStyle: TextStyle(letterSpacing: 1, fontSize: 20, fontWeight: FontWeight.w400, color: Color(COLOR_SECONDARY)))),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.only(right: 12),
                                                                              child: Icon(
                                                                                Icons.clear,
                                                                                color:
                                                                                Color(COLOR_SECONDARY)
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        pop(context);
                                                                        _pickLogoImage();
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(15),
                                                                            child: Text("Upload Logo",
                                                                                textScaleFactor: 1,
                                                                                style: GoogleFonts.montserrat(textStyle: TextStyle(letterSpacing: 1, fontSize: 17, fontWeight: FontWeight.w400, color: Color(COLOR_PRIMARY)))),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Provider.of<CustomViewModel>(parentContext,
                                                                                listen: false)
                                                                            .deleteLogo()
                                                                            .then((value) {
                                                                          setState(
                                                                              () {
                                                                            providerListener.vcardData.logoImagePath =
                                                                                "";
                                                                          });
                                                                        });
                                                                        pop(context);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(15),
                                                                            child: Text("Delete",
                                                                                textScaleFactor: 1,
                                                                                style: GoogleFonts.montserrat(textStyle: TextStyle(letterSpacing: 1, fontSize: 17, fontWeight: FontWeight.w400, color: Color(COLOR_PRIMARY)))),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Showcase(
                                                    key: uploadLogoGlobal,
                                                    description:
                                                        'Upload/Delete Logo\n\nNEXT>>',
                                                    onToolTipClick: () {
                                                      setState(() {
                                                        ShowCaseWidget.of(widget
                                                                .ShowCaseContext)
                                                            .next();
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.9),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7.0)),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                            size: 13,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(
                                                              "Logo",
                                                              style: TextStyle(
                                                                  fontSize: 8,
                                                                  letterSpacing:
                                                                      0.3,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(providerListener.vcardData.title ?? "",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        )),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                        providerListener.vcardData.subtitle ??
                                            "",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        )),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ]),
                                ),
                                providerListener
                                            .vcardData.centralized_center_on ==
                                        "1"
                                    ? Container()
                                    : Positioned(
                                        top: 15,
                                        left: 12,
                                        child: Showcase(
                                          key: uploadBannerGlobal,
                                          description:
                                              'Upload/Delete Banners\n\nNEXT>>',
                                          onToolTipClick: () {
                                            setState(() {
                                              ShowCaseWidget.of(
                                                      widget.ShowCaseContext)
                                                  .next();
                                            });
                                          },
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      //this right here
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10)),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          COLOR_PRIMARY),
                                                                      Color(
                                                                          COLOR_PRIMARY),
                                                                    ],
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          15.0),
                                                                      child: Text(
                                                                          "Edit Banner",
                                                                          textScaleFactor:
                                                                              1,
                                                                          style:
                                                                              GoogleFonts.montserrat(textStyle: TextStyle(letterSpacing: 1, fontSize: 20, fontWeight: FontWeight.w400, color: Color(COLOR_SECONDARY)))),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        pop(context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.only(right: 12),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .clear,
                                                                          color:

                                                                          Color(
                                                                              COLOR_SECONDARY)
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  pop(context);
                                                                  _pickBannerImage();
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              15),
                                                                      child: Text(
                                                                          "Upload Image",
                                                                          textScaleFactor:
                                                                              1,
                                                                          style:
                                                                              GoogleFonts.montserrat(textStyle: TextStyle(letterSpacing: 1, fontSize: 17, fontWeight: FontWeight.w400, color: Color(COLOR_PRIMARY)))),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Provider.of<CustomViewModel>(
                                                                          parentContext,
                                                                          listen:
                                                                              false)
                                                                      .deleteBanner()
                                                                      .then(
                                                                          (value) {
                                                                    setState(
                                                                        () {
                                                                      providerListener
                                                                          .vcardData
                                                                          .bannerImagePath = "";
                                                                    });
                                                                  });
                                                                  pop(context);
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              15),
                                                                      child: Text(
                                                                          "Delete",
                                                                          textScaleFactor:
                                                                              1,
                                                                          style:
                                                                              GoogleFonts.montserrat(textStyle: TextStyle(letterSpacing: 1, fontSize: 17, fontWeight: FontWeight.w400, color: Color(COLOR_PRIMARY)))),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              height: 27,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.7),
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.0)),
                                              ),
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 13,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Text(
                                                      "Background",
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          letterSpacing: 0.3,
                                                          fontWeight: FontWeight.w800,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            Container(
                                /* decoration: providerListener
                                        .vcardData.bannerImagePath.isNotEmpty
                                    ? BoxDecoration(
                                        image: DecorationImage(
                                            image: providerListener.vcardData
                                                    .bannerImagePath.isNotEmpty
                                                ? NetworkImage(apiUrl +
                                                    "../../" +
                                                    providerListener.vcardData
                                                        .bannerImagePath)
                                                : null,
                                            fit: BoxFit.fill),
                                      )
                                    : null,*/
                                child: Column(
                              children: [
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      providerListener.vcardData.company != ""
                                          ? InkWell(
                                              onTap: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (providerListener.vcardData
                                                            .company ??
                                                        ""),
                                                    style: GoogleFonts.montserrat(
                                                        color: Color(int.parse(
                                                            providerListener
                                                                .vcardData
                                                                .fontcolor
                                                                .replaceAll("#",
                                                                    "0xff"))),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(
                                              height: 1.0,
                                            ),
                                      (providerListener.vcardData.company ??
                                                  "") !=
                                              ""
                                          ? Divider(
                                              thickness: 1,
                                              color: Color(int.parse(
                                                  providerListener
                                                      .vcardData.fontcolor
                                                      .replaceAll(
                                                          "#", "0xff"))),
                                            )
                                          : SizedBox(
                                              height: 1.0,
                                            ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _launchURL("tel:" +
                                                  providerListener
                                                      .vcardData.phone ??
                                              "");
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              (providerListener
                                                      .vcardData.phone ??
                                                  ""),
                                              style: GoogleFonts.montserrat(
                                                  color: Color(int.parse(
                                                      providerListener
                                                          .vcardData.fontcolor
                                                          .replaceAll(
                                                              "#", "0xff"))),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(int.parse(providerListener
                                            .vcardData.fontcolor
                                            .replaceAll("#", "0xff"))),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _launchURL("mailto:" +
                                                  providerListener
                                                      .vcardData.email ??
                                              "");
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              (providerListener
                                                      .vcardData.email ??
                                                  ""),
                                              style: GoogleFonts.montserrat(
                                                  color: Color(int.parse(
                                                      providerListener
                                                          .vcardData.fontcolor
                                                          .replaceAll(
                                                              "#", "0xff"))),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      providerListener.vcardData.description !=
                                              ""
                                          ? Divider(
                                              thickness: 1,
                                              color: Color(int.parse(
                                                  providerListener
                                                      .vcardData.fontcolor
                                                      .replaceAll(
                                                          "#", "0xff"))),
                                            )
                                          : SizedBox(
                                              height: 1.0,
                                            ),
                                      providerListener.vcardData.description !=
                                              ""
                                          ? InkWell(
                                              onTap: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        SizeConfig.screenWidth -
                                                            70,
                                                    child: Text(
                                                      (providerListener
                                                              .vcardData
                                                              .description ??
                                                          ""),
                                                      style: GoogleFonts.montserrat(
                                                          color: Color(int.parse(
                                                              providerListener
                                                                  .vcardData
                                                                  .fontcolor
                                                                  .replaceAll(
                                                                      "#",
                                                                      "0xff"))),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(
                                              height: 1.0,
                                            ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                                buildSocialIcons(context),
                              ],
                            )),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
