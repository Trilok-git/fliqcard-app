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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../MainScreen.dart';
import 'buildSocialIcons.dart';

BuildContext parentContext;

class thirdThemeScreen extends StatefulWidget {
  @override
  _thirdThemeScreenState createState() => _thirdThemeScreenState();
}

class _thirdThemeScreenState extends State<thirdThemeScreen> {
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

  Future _pickProfileImage() async {
    Provider.of<CustomViewModel>(context, listen: false).userData.isStaff != "1"
        ? Provider.of<CustomViewModel>(context, listen: false).memberShip !=
                null
            ? _pickProfileImageInsight()
            : Platform.isAndroid
                ? push(context, PricingScreen(1))
                : commonToast(context, "Visit fliqcard.com")
        : _pickProfileImageInsight();
  }

  Future _pickProfileImageInsight() async {
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
              .UploadProfile(_logo)
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
      decoration: BoxDecoration(
        color: Color(int.parse(
            providerListener.vcardData.bgcolor.replaceAll("#", "0xff"))),
        borderRadius: BorderRadius.circular(15),
        image: (providerListener.vcardData.bannerImagePath ?? "") != ""
            ? DecorationImage(
                image:
                    NetworkImage(apiUrl + "../../../assets/images/bgtheme.png"),
                fit: BoxFit.fill)
            : null,
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 100, top: 10, bottom: 10),
                      child: Container(
                        margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        width: SizeConfig.screenWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              providerListener.vcardData.title ?? "",
                              style: TextStyle(
                                  color: Color(int.parse(providerListener
                                      .vcardData.fontcolor
                                      .replaceAll("#", "0xff"))),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              (providerListener.vcardData.subtitle ?? ""),
                              style: TextStyle(
                                  color: Color(int.parse(providerListener
                                      .vcardData.fontcolor
                                      .replaceAll("#", "0xff"))),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (providerListener.vcardData.company ?? "") != ""
                              ? InkWell(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Color(int.parse(providerListener
                                            .vcardData.fontcolor
                                            .replaceAll("#", "0xff"))),
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Text(
                                        (providerListener.vcardData.company ??
                                            ""),
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                providerListener
                                                    .vcardData.fontcolor
                                                    .replaceAll("#", "0xff"))),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
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
                          InkWell(
                            onTap: () {
                              _launchURL(
                                  "tel:" + providerListener.vcardData.phone ??
                                      "");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Color(int.parse(providerListener
                                      .vcardData.fontcolor
                                      .replaceAll("#", "0xff"))),
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  (providerListener.vcardData.phone ?? ""),
                                  style: TextStyle(
                                      color: Color(int.parse(providerListener
                                          .vcardData.fontcolor
                                          .replaceAll("#", "0xff"))),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          (providerListener.vcardData.email ?? "") == ""
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    _launchURL("mailto:" +
                                            providerListener.vcardData.email ??
                                        "");
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Color(int.parse(providerListener
                                            .vcardData.fontcolor
                                            .replaceAll("#", "0xff"))),
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Text(
                                        (providerListener.vcardData.email ??
                                            ""),
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                providerListener
                                                    .vcardData.fontcolor
                                                    .replaceAll("#", "0xff"))),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                          (providerListener.vcardData.website ?? "") == ""
                              ? Container()
                              : SizedBox(
                                  height: 10.0,
                                ),
                          (providerListener.vcardData.website ?? "") == ""
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Color(int.parse(providerListener
                                          .vcardData.fontcolor
                                          .replaceAll("#", "0xff"))),
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Text(
                                      (providerListener.vcardData.website ??
                                          ""),
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              providerListener
                                                  .vcardData.fontcolor
                                                  .replaceAll("#", "0xff"))),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                          (providerListener.vcardData.description ?? "") == ""
                              ? Container()
                              : SizedBox(
                                  height: 10.0,
                                ),
                          (providerListener.vcardData.description ?? "") == ""
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Color(int.parse(providerListener
                                          .vcardData.fontcolor
                                          .replaceAll("#", "0xff"))),
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Container(
                                      width: SizeConfig.screenWidth - 100,
                                      child: Text(
                                        (providerListener
                                                .vcardData.description ??
                                            ""),
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                providerListener
                                                    .vcardData.fontcolor
                                                    .replaceAll("#", "0xff"))),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Stack(
                      children: [
                        providerListener.vcardData.profileImagePath != null &&
                                providerListener.vcardData.profileImagePath !=
                                    ""
                            ? Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image: NetworkImage(apiUrl +
                                        "../../" +
                                        providerListener
                                            .vcardData.profileImagePath),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  border: Border.all(
                                    color: Color(int.parse(providerListener
                                        .vcardData.fontcolor
                                        .replaceAll("#", "0xff"))),
                                    width: 2.0,
                                  ),
                                ),
                              )
                            : Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image: AssetImage("assets/profile.png"),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  border: Border.all(
                                    color: Color(int.parse(providerListener
                                        .vcardData.fontcolor
                                        .replaceAll("#", "0xff"))),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 1,
                          left: SizeConfig.screenWidth / 6,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      //this right here
                                      child: SingleChildScrollView(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(COLOR_PRIMARY),
                                                      Color(COLOR_PRIMARY),
                                                    ],
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Text(
                                                          "Edit Profile",
                                                          textScaleFactor: 1,
                                                          style: GoogleFonts.openSans(
                                                              textStyle: TextStyle(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                      COLOR_SECONDARY)))),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        pop(context);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 12),
                                                        child: Icon(Icons.clear,
                                                            color: Color(
                                                                COLOR_SECONDARY)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  pop(context);
                                                  _pickProfileImage();
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
                                                          "Upload Profile",
                                                          textScaleFactor: 1,
                                                          style: GoogleFonts.openSans(
                                                              textStyle: TextStyle(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                      COLOR_PRIMARY)))),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Provider.of<CustomViewModel>(
                                                          parentContext,
                                                          listen: false)
                                                      .deleteProfile()
                                                      .then((value) {
                                                    setState(() {
                                                      providerListener.vcardData
                                                          .profileImagePath = "";
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
                                                      child: Text("Delete",
                                                          textScaleFactor: 1,
                                                          style: GoogleFonts.openSans(
                                                              textStyle: TextStyle(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                      COLOR_PRIMARY)))),
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
                              decoration: BoxDecoration(
                                color: Color(COLOR_PRIMARY),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    buildSocialIcons(context),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
                providerListener.vcardData.logoImagePath != "" &&
                        providerListener.vcardData.logoImagePath != null
                    ? Positioned(
                        top: 15,
                        right: 15,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: NetworkImage(apiUrl +
                                    "../../" +
                                    providerListener.vcardData.logoImagePath),
                                fit: BoxFit.fill,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        top: 15,
                        right: 15,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/placeholder.png"),
                                fit: BoxFit.fill,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                        ),
                      ),
                providerListener.vcardData.centralized_center_on == "1"
                    ? Container()
                    : Positioned(
                        top: 60,
                        right: 5,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    //this right here
                                    child: SingleChildScrollView(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(COLOR_PRIMARY),
                                                    Color(COLOR_PRIMARY),
                                                  ],
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Text("Edit Logo",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    COLOR_SECONDARY)))),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      pop(context);
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          right: 12),
                                                      child: Icon(Icons.clear,
                                                          color: Color(
                                                              COLOR_SECONDARY)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                pop(context);
                                                _pickLogoImage();
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
                                                    child: Text("Upload Logo",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    COLOR_PRIMARY)))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Provider.of<CustomViewModel>(
                                                        parentContext,
                                                        listen: false)
                                                    .deleteLogo()
                                                    .then((value) {
                                                  setState(() {
                                                    providerListener.vcardData
                                                        .logoImagePath = "";
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
                                                    child: Text("Delete",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    COLOR_PRIMARY)))),
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
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                            ),
                            padding: EdgeInsets.all(5),
                            child: Column(
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
                                    "Logo",
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
              ],
            ),
          )),
    );
  }
}
