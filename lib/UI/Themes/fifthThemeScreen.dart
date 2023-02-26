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
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../MainScreen.dart';
import 'Ecom/Payments/PaymentOptionsListScreen.dart';
import 'Ecom/Products/ProductsListScreen.dart';
import 'Ecom/Service/ServicesListScreen.dart';
import 'EcomAddEdit.dart';
import 'buildSocialIcons.dart';

BuildContext parentContext;

class fifthThemeScreen extends StatefulWidget {
  @override
  _fifthThemeScreenState createState() => _fifthThemeScreenState();
}

class _fifthThemeScreenState extends State<fifthThemeScreen> {
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


  Future _pickVideo() async {
    Provider.of<CustomViewModel>(context, listen: false).userData.isStaff != "1"
        ? Provider.of<CustomViewModel>(context, listen: false).memberShip !=
        null
        ? _pickVideoInsight()
        : Platform.isAndroid
        ? push(context, PricingScreen(1))
        : commonToast(context, "Visit fliqcard.com")
        : _pickVideoInsight();
  }

  _pickVideoInsight() async {
    try {
      final pickedFile = await picker.getVideo(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          EasyLoading.show(status: 'Uploading...');
          _logo = File(pickedFile.path);
          Provider.of<CustomViewModel>(context, listen: false)
              .UploadBanner(_logo)
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
    }
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
      padding: EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(int.parse(
            providerListener.vcardData.bgcolor.replaceAll("#", "0xff"))),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Color(int.parse(
              providerListener.vcardData.cardcolor.replaceAll("#", "0xff"))),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: SizeConfig.screenHeight / 1.2,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 6,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 8.0,
                    children: List.generate(1000, (index) {
                      return Center(
                        child: Container(
                          height: 3,
                          width: 3,
                          decoration: BoxDecoration(
                              color: Color(int.parse(providerListener
                                  .vcardData.bgcolor
                                  .replaceAll("#", "0xff"))),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  height: SizeConfig.screenWidth / 3,
                  foregroundDecoration: RotatedCornerDecoration(
                    color: Color(int.parse(providerListener.vcardData.bgcolor
                        .replaceAll("#", "0xff"))),
                    geometry: BadgeGeometry(
                        width: SizeConfig.screenWidth / 3,
                        height: SizeConfig.screenWidth / 3,
                        cornerRadius: 0,
                        alignment: BadgeAlignment.topLeft),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10, top: 60, bottom: 10),
                      child: Container(
                        margin: EdgeInsets.only(left: 10, bottom: 10),
                        width: SizeConfig.screenWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              providerListener.vcardData.title ?? "",
                              style: GoogleFonts.montserrat(
                                  color: Color(int.parse(providerListener
                                      .vcardData.fontcolor
                                      .replaceAll("#", "0xff"))),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              (providerListener.vcardData.subtitle ?? ""),
                              style: GoogleFonts.montserrat(
                                  color: Color(int.parse(providerListener
                                      .vcardData.fontcolor
                                      .replaceAll("#", "0xff"))),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        providerListener.vcardData.centralized_center_on == "1"
                            ? Container()
                            : InkWell(
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
                                                    topLeft: Radius
                                                        .circular(10),
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
                                                    const EdgeInsets
                                                        .all(15.0),
                                                    child: Text(
                                                        "Edit Banner",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                1,
                                                                fontSize:
                                                                20,
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
                                              onTap: () {
                                                pop(context);
                                                _pickVideo();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(15),
                                                    child: Text(
                                                        providerListener
                                                            .memberShip !=
                                                            null
                                                            ? "Upload Video"
                                                            : "Upload Video (Premium)",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                1,
                                                                fontSize:
                                                                17,
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
                                                    const EdgeInsets
                                                        .all(15),
                                                    child: Text(
                                                        "Upload Image",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                1,
                                                                fontSize:
                                                                17,
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
                                                    .deleteBanner()
                                                    .then((value) {
                                                  setState(() {
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
                                                    const EdgeInsets
                                                        .all(15),
                                                    child: Text("Delete",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                1,
                                                                fontSize:
                                                                17,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                      ],
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: providerListener.vcardData.logoImagePath !=
                                      "" &&
                                  providerListener.vcardData.logoImagePath !=
                                      null
                              ? InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                        image: NetworkImage(apiUrl +
                                            "../../" +
                                            providerListener
                                                .vcardData.logoImagePath),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/placeholder.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                    ),
                                  ),
                                ),
                        ),
                        providerListener.vcardData.centralized_center_on == "1"
                            ? Container()
                            : Positioned(
                                top: 0,
                                right: 0,
                                child:  InkWell(
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
                                                              child: Icon(
                                                                Icons.clear,
                                                                color: Color(COLOR_SECONDARY),
                                                              ),
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
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50, right: 20),
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (providerListener.vcardData.company ?? "") != ""
                                ? InkWell(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Color(int.parse(
                                              providerListener
                                                  .vcardData.fontcolor
                                                  .replaceAll("#", "0xff"))),
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          width: SizeConfig.screenWidth / 1.8,
                                          child: Text(
                                            (providerListener
                                                    .vcardData.company ??
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    width: SizeConfig.screenWidth / 1.8,
                                    child: Text(
                                      (providerListener.vcardData.phone ?? ""),
                                      style: GoogleFonts.montserrat(
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
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            (providerListener.vcardData.email ?? "") == ""
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      _launchURL("mailto:" +
                                              providerListener
                                                  .vcardData.email ??
                                          "");
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Color(int.parse(
                                              providerListener
                                                  .vcardData.fontcolor
                                                  .replaceAll("#", "0xff"))),
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          width: SizeConfig.screenWidth / 1.8,
                                          child: Text(
                                            (providerListener.vcardData.email ??
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        width: SizeConfig.screenWidth / 1.8,
                                        child: Text(
                                          (providerListener.vcardData.website ??
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        width: SizeConfig.screenWidth / 1.8,
                                        child: Text(
                                          (providerListener
                                                  .vcardData.description ??
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
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    buildSocialIcons(context),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: providerListener.vcardData.profileImagePath !=
                                      null &&
                                  providerListener.vcardData.profileImagePath !=
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
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
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 1,
                          left: 1,
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 12),
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Color(COLOR_SECONDARY),
                                                        ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (providerListener.userData != null &&
                                providerListener.memberShip != null) {
                              push(context, ServicesListScreen());
                            } else {
                              if (Platform.isAndroid) {
                                push(context, PricingScreen(1));
                              } else {
                                commonToast(context, "Visit fliqcard.com");
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.list,
                                          color: Color(int.parse(
                                              providerListener
                                                  .vcardData.fontcolor
                                                  .replaceAll("#", "0xff"))),
                                          size: 35),
                                    ),
                                    Positioned(
                                      top: 3,
                                      right: 2,
                                      child: Icon(Icons.edit_outlined,
                                          color: Color(int.parse(
                                              providerListener
                                                  .vcardData.fontcolor
                                                  .replaceAll("#", "0xff"))),
                                          size: 15),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Services",
                                  style: GoogleFonts.montserrat(
                                      color: Color(int.parse(providerListener
                                          .vcardData.fontcolor
                                          .replaceAll("#", "0xff"))),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (providerListener.userData != null &&
                                providerListener.memberShip != null) {
                              push(context, ProductsListScreen());
                            } else {
                              if (Platform.isAndroid) {
                                push(context, PricingScreen(1));
                              } else {
                                commonToast(context, "Visit fliqcard.com");
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.list,
                                          color: Color(int.parse(
                                              providerListener
                                                  .vcardData.fontcolor
                                                  .replaceAll("#", "0xff"))),
                                          size: 35),
                                    ),
                                    Positioned(
                                      top: 3,
                                      right: 2,
                                      child: Icon(Icons.edit_outlined,
                                          color: Color(int.parse(
                                              providerListener
                                                  .vcardData.fontcolor
                                                  .replaceAll("#", "0xff"))),
                                          size: 15),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Products",
                                  style: GoogleFonts.montserrat(
                                      color: Color(int.parse(providerListener
                                          .vcardData.fontcolor
                                          .replaceAll("#", "0xff"))),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        providerListener.hide == "yes"
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  if (providerListener.userData != null &&
                                      providerListener.memberShip != null) {
                                    push(context, PaymentOptionsListScreen());
                                  } else {
                                    if (Platform.isAndroid) {
                                      push(context, PricingScreen(1));
                                    } else {
                                      commonToast(
                                          context, "Visit fliqcard.com");
                                    }
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 7),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(Icons.payment,
                                                color: Color(int.parse(
                                                    providerListener
                                                        .vcardData.fontcolor
                                                        .replaceAll(
                                                            "#", "0xff"))),
                                                size: 35),
                                          ),
                                          Positioned(
                                            top: 3,
                                            right: 2,
                                            child: Icon(Icons.edit_outlined,
                                                color: Color(int.parse(
                                                    providerListener
                                                        .vcardData.fontcolor
                                                        .replaceAll(
                                                            "#", "0xff"))),
                                                size: 15),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Payments",
                                        style: GoogleFonts.montserrat(
                                            color: Color(int.parse(
                                                providerListener
                                                    .vcardData.fontcolor
                                                    .replaceAll("#", "0xff"))),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        SizedBox(width: 20),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
