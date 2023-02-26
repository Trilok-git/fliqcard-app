import 'dart:io';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Pricing/PricingScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_balloon_slider/flutter_balloon_slider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../MainScreen.dart';
import 'buildSocialIcons.dart';

BuildContext parentContext;

class secondThemeScreen extends StatefulWidget {
  final banner_video;

  secondThemeScreen(this.banner_video);

  @override
  _secondThemeScreenState createState() => _secondThemeScreenState();
}

class _secondThemeScreenState extends State<secondThemeScreen> {
  VideoPlayerController _controller;
  bool _visible = false;

  final picker = ImagePicker();

  File _logo;

  Future _pickLogoImage() async {
    /*try {
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
        : print("staff");
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

    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
    if (widget.banner_video != null && widget.banner_video != "") {
      _controller =
          VideoPlayerController.network(apiUrl + "/../" + widget.banner_video);
      _controller.initialize().then((_) {
        _controller.setLooping(true);
        setState(() {
          _controller.setVolume(universalVolume);
          _controller.play();
          _visible = true;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
  }

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller),
    );
  }

  _getBackgroundColor() {
    final providerListener = Provider.of<CustomViewModel>(context);
    return Container(
      width: SizeConfig.screenWidth,
      height: 200,
      child: Shimmer.fromColors(
          baseColor: Color(int.parse(
              providerListener.vcardData.fontcolor.replaceAll("#", "0xff"))),
          highlightColor: Color(COLOR_SECONDARY),
          child: Center(
            child: Text(
              'loading Banner video...',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 25.0,
              ),
            ),
          )),
    );
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
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(int.parse(providerListener.vcardData.bgcolor
                      .replaceAll("#", "0xff"))),
                ),
                child: Stack(
                  children: [
                    providerListener.vcardData.bannerImagePath != null &&
                            providerListener.vcardData.bannerImagePath != "" &&
                            providerListener.vcardData.bannerImagePath
                                .contains("mp4")
                        ? _getBackgroundColor()
                        : SizedBox(
                            height: 0,
                          ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Stack(
                          children: [
                            providerListener.vcardData.bannerImagePath != null
                                ? providerListener
                                        .vcardData.bannerImagePath.isNotEmpty
                                    ? providerListener.vcardData
                                                    .bannerImagePath !=
                                                null &&
                                            providerListener.vcardData
                                                    .bannerImagePath !=
                                                "" &&
                                            providerListener
                                                .vcardData.bannerImagePath
                                                .contains("mp4")
                                        ? Container(
                                            height: 200,
                                            child: _getVideoBackground())
                                        : Container(
                                            width: SizeConfig.screenWidth,
                                            height: 200,
                                            child: Image.network(
                                              (apiUrl +
                                                      "/../" +
                                                      providerListener.vcardData
                                                          .bannerImagePath) ??
                                                  "",
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                    : Container(
                                        height: 200,
                                        color: Color(int.parse(providerListener
                                            .vcardData.cardcolor
                                            .replaceAll("#", "0xff"))),
                                      )
                                : Container(),
                            providerListener.vcardData.logoImagePath != "" &&
                                    providerListener.vcardData.logoImagePath !=
                                        null
                                ? Positioned(
                                    top: 15,
                                    right: 15,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          width: 70.0,
                                          height: 70.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
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
                                      ),
                                    ),
                                  )
                                : Positioned(
                                    top: 15,
                                    right: 15,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
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
                                  ),
                            providerListener.vcardData.centralized_center_on ==
                                    "1"
                                ? Positioned(
                                    bottom: 1, right: 1, child: Container())
                                : Positioned(
                                    top: 60,
                                    right: 12,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                //this right here
                                                child: SingleChildScrollView(
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
                                                                topRight: Radius
                                                                    .circular(
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
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                child: Text(
                                                                    "Edit Logo",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_SECONDARY)))),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  pop(context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              12),
                                                                  child: Icon(
                                                                      Icons
                                                                          .clear,
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
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                child: Text(
                                                                    "Upload Logo",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_PRIMARY)))),
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
                                                                .deleteLogo()
                                                                .then((value) {
                                                              setState(() {
                                                                providerListener
                                                                    .vcardData
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
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                child: Text(
                                                                    "Delete",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_PRIMARY)))),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100.0)),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 13,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
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
                            providerListener.vcardData.centralized_center_on ==
                                    "1"
                                ? Container()
                                : Positioned(
                                    top: 15,
                                    left: 12,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                //this right here
                                                child: SingleChildScrollView(
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
                                                                topRight: Radius
                                                                    .circular(
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
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                child: Text(
                                                                    "Edit Banner",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_SECONDARY)))),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  pop(context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              12),
                                                                  child: Icon(
                                                                      Icons
                                                                          .clear,
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
                                                                    providerListener.memberShip !=
                                                                            null
                                                                        ? "Upload Video"
                                                                        : "Upload Video (Premium)",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_PRIMARY)))),
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
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_PRIMARY)))),
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
                                                                child: Text(
                                                                    "Delete",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_PRIMARY)))),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 13,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: SizeConfig.screenWidth / 3,
                                child: BalloonSlider(
                                    value: universalVolume,
                                    ropeLength: 1,
                                    showRope: true,
                                    onChangeStart: (val) {},
                                    onChanged: (val) {},
                                    onChangeEnd: (val) {
                                      setState(() {
                                        print(double.parse(
                                            val.toStringAsFixed(1)));

                                        _controller.setVolume(double.parse(
                                            val.toStringAsFixed(1)));

                                        universalVolume = double.parse(
                                            val.toStringAsFixed(1));
                                      });
                                    },
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      providerListener.vcardData
                                                      .profileImagePath !=
                                                  "" &&
                                              providerListener.vcardData
                                                      .profileImagePath !=
                                                  null
                                          ? InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: 70.0,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  image: DecorationImage(
                                                    image: NetworkImage(apiUrl +
                                                        "../../" +
                                                        providerListener
                                                            .vcardData
                                                            .profileImagePath),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
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
                                                        "assets/profile.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: SizeConfig.screenWidth / 1.6,
                                        child: Text(
                                            (providerListener.vcardData.title ??
                                                ""),
                                            style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 1,
                                    left: SizeConfig.screenWidth / 8,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                //this right here
                                                child: SingleChildScrollView(
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
                                                                topRight: Radius
                                                                    .circular(
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
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                child: Text(
                                                                    "Edit Profile",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_SECONDARY)))),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  pop(context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              12),
                                                                  child: Icon(
                                                                      Icons
                                                                          .clear,
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
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                child: Text(
                                                                    "Upload Profile",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_PRIMARY)))),
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
                                                                .deleteProfile()
                                                                .then((value) {
                                                              setState(() {
                                                                providerListener
                                                                    .vcardData
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
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                child: Text(
                                                                    "Delete",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            letterSpacing:
                                                                                1,
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Color(COLOR_PRIMARY)))),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
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
                                height: 20.0,
                              ),
                              (providerListener.vcardData.subtitle ?? "") != ""
                                  ? InkWell(
                                      onTap: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            FlutterIcons.tag_faw,
                                            color: Color(int.parse(
                                                providerListener
                                                    .vcardData.fontcolor
                                                    .replaceAll("#", "0xff"))),
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Text(
                                            (providerListener
                                                    .vcardData.subtitle ??
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
                                    )
                                  : Container(),
                              (providerListener.vcardData.company ?? "") != ""
                                  ? SizedBox(
                                      height: 20.0,
                                    )
                                  : SizedBox(
                                      height: 1.0,
                                    ),
                              (providerListener.vcardData.company ?? "") != ""
                                  ? InkWell(
                                      onTap: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            FlutterIcons.building_faw,
                                            color: Color(int.parse(
                                                providerListener
                                                    .vcardData.fontcolor
                                                    .replaceAll("#", "0xff"))),
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Text(
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
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 1.0,
                                    ),
                              (providerListener.vcardData.email ?? "") != ""
                                  ? Container()
                                  : SizedBox(
                                      height: 20.0,
                                    ),
                              providerListener.vcardData.email == ""
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
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.email,
                                            color: Color(int.parse(
                                                providerListener
                                                    .vcardData.fontcolor
                                                    .replaceAll("#", "0xff"))),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Text(
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
                                        ],
                                      ),
                                    ),
                              (providerListener.vcardData.phone ?? "") == ""
                                  ? Container()
                                  : SizedBox(
                                      height: 20.0,
                                    ),
                              providerListener.vcardData.phone == ""
                                  ? Container()
                                  : InkWell(
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
                                          Icon(
                                            Icons.phone_android_sharp,
                                            color: Color(int.parse(
                                                providerListener
                                                    .vcardData.fontcolor
                                                    .replaceAll("#", "0xff"))),
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Text(
                                            (providerListener.vcardData.phone ??
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
                              (providerListener.vcardData.description ?? "") ==
                                      ""
                                  ? Container()
                                  : SizedBox(
                                      height: 20.0,
                                    ),
                              (providerListener.vcardData.description ?? "") ==
                                      ""
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Color(int.parse(
                                              providerListener
                                                  .vcardData.fontcolor
                                                  .replaceAll("#", "0xff"))),
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          width: SizeConfig.screenWidth - 120,
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
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                        buildSocialIcons(context),
                        SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }
}
