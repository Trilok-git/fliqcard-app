import 'dart:io';

import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Pricing/PricingScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEditCard extends StatefulWidget {
  String slug,
      fullname,
      jobTitle,
      description,
      email,
      company,
      phone,
      phone2,
      telephone,
      whatsapp,
      website,
      address,
      mapLink,
      twitter,
      facebook,
      linkedIn,
      ytb,
      instagram,
      snapchat,
      telegram,
      skype,
      wechat,
      tiktok,
      pinterest,
      bgColor,
      cardColor,
      fontColor,
      material,
      themeSelected,
      centralized_center_on;

  AddEditCard(
      this.slug,
      this.fullname,
      this.jobTitle,
      this.description,
      this.email,
      this.company,
      this.phone,
      this.phone2,
      this.telephone,
      this.whatsapp,
      this.website,
      this.address,
      this.mapLink,
      this.twitter,
      this.facebook,
      this.linkedIn,
      this.ytb,
      this.instagram,
      this.snapchat,
      this.telegram,
      this.skype,
      this.wechat,
      this.tiktok,
      this.pinterest,
      this.bgColor,
      this.cardColor,
      this.fontColor,
      this.material,
      this.themeSelected,
      this.centralized_center_on);

  @override
  _AddEditCardState createState() => _AddEditCardState();
}

class _AddEditCardState extends State<AddEditCard> {
  bool isMapLink = false;
  bool isWebsiteLink = false;
  bool isMaterialLink = false;

  bool isTwitterLink = false;
  bool isInstagramLink = false;
  bool isLinkedInLink = false;

  bool isFacebookLink = false;
  bool isYouTubeLink = false;

  bool isSnapchatLink = false;
  bool isTelegramLink = false;

  bool isSkypeLink = false;

  bool isWeChatLink = false;
  bool isTikTokLink = false;
  bool isPinterestLink = false;

  bool isWhatsAppLink = false;

  FocusNode focusNodeMap;
  FocusNode focusNodeWebsite;
  FocusNode focusNodeMaterial;

  FocusNode focusNodeTwitter;
  FocusNode focusNodeInstagram;
  FocusNode focusNodeLinkedIn;

  FocusNode focusNodeFacebook;
  FocusNode focusNodeYouTube;

  FocusNode focusNodeSnapchat;
  FocusNode focusNodeTelegram;

  FocusNode focusNodeSkype;

  FocusNode focusNodeWeChat;
  FocusNode focusNodeTikTok;
  FocusNode focusNodePinterest;

  FocusNode focusNodeWhatsApp;

  final _formKey = GlobalKey<FormState>();
  TextEditingController fullnameCotroller = TextEditingController();
  TextEditingController slugController = TextEditingController();
  TextEditingController jobTitleCotroller = TextEditingController();
  TextEditingController descriptionCotroller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController phone2Controller = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mapLinkController = TextEditingController();
  TextEditingController twitterController = TextEditingController();

  TextEditingController snapChatController = TextEditingController();
  TextEditingController telegramController = TextEditingController();

  TextEditingController skypeController = TextEditingController();
  TextEditingController wechatController = TextEditingController();
  TextEditingController tiktokController = TextEditingController();
  TextEditingController pinterestController = TextEditingController();

  TextEditingController facebookController = TextEditingController();
  TextEditingController linkedInController = TextEditingController();
  TextEditingController ytbController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController marketingMaterialsController = TextEditingController();

  String bgColor = "#ffffff";
  String cardColor = "#ffffff";
  String fontColor = "#000000";
  int pageIndex = 0;
  var errorMessage = "";
  var slug_error = "";
  String country1 = "+91";
  String country2 = "+91";
  String countryTel = "+91";

  final bgcolorController = CircleColorPickerController(
    initialColor: Color(COLOR_PRIMARY),
  );

  final cardcolorController = CircleColorPickerController(
    initialColor: Color(COLOR_PRIMARY),
  );

  final fontcolorController = CircleColorPickerController(
    initialColor: Color(COLOR_PRIMARY),
  );

  int myVar = 0;

  File _banner;
  File _logo;
  File _profile;

  final picker = ImagePicker();

  Future _pickBannerImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _banner = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future _pickLogoImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _logo = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future _pickProfileImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _profile = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future _pickVideo() async {
    try {
      final pickedFile = await picker.getVideo(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _banner = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future saveCard(String operation) {
    Provider.of<CustomViewModel>(context, listen: false)
        .updateVcard(
            operation,
            slugController.text ?? "",
            fullnameCotroller.text ?? "",
            jobTitleCotroller.text ?? "",
            descriptionCotroller.text ?? "",
            emailController.text ?? "",
            companyController.text ?? "",
            whatsappController.text ?? "",
            websiteController.text ?? "",
            addressController.text ?? "",
            mapLinkController.text ?? "",
            twitterController.text ?? "",
            facebookController.text ?? "",
            linkedInController.text ?? "",
            ytbController.text ?? "",
            instagramController.text ?? "",
            snapChatController.text ?? "",
            telegramController.text ?? "",
            skypeController.text ?? "",
            wechatController.text ?? "",
            tiktokController.text ?? "",
            pinterestController.text ?? "",
            (country1) + " " + phoneController.text ?? "",
            phone2Controller.text.isEmpty
                ? ""
                : ((country2) + " " + phone2Controller.text ?? ""),
            telephoneController.text.isEmpty
                ? ""
                : ((countryTel) + " " + telephoneController.text ?? ""),
            marketingMaterialsController.text ?? "",
            bgColor.toString(),
            cardColor.toString(),
            fontColor.toString(),
            _banner,
            _logo,
            _profile)
        .then((value) {
      setState(() {
        // commonToast(context, value);
        errorMessage = value;
        Provider.of<CustomViewModel>(context, listen: false)
            .getData()
            .then((value) {
          EasyLoading.dismiss();
          Provider.of<CustomViewModel>(context, listen: false)
              .setBottomIndex(1);
          pop(context);
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      focusNodeMap = new FocusNode();
      focusNodeWebsite = new FocusNode();
      focusNodeMaterial = new FocusNode();

      focusNodeTwitter = new FocusNode();
      focusNodeInstagram = new FocusNode();
      focusNodeLinkedIn = new FocusNode();

      focusNodeFacebook = new FocusNode();
      focusNodeYouTube = new FocusNode();

      focusNodeSnapchat = new FocusNode();
      focusNodeTelegram = new FocusNode();

      focusNodeSkype = new FocusNode();

      focusNodeWeChat = new FocusNode();
      focusNodeTikTok = new FocusNode();
      focusNodePinterest = new FocusNode();

      focusNodeWhatsApp = new FocusNode();

      pageIndex = 0;

      if ((widget.phone ?? "").contains("+")) {
        country1 = widget.phone.split(" ").first ?? "";
      }
      if ((widget.phone2 ?? "").contains("+")) {
        country2 = widget.phone2.split(" ").first ?? "";
      }
      if ((widget.telephone ?? "").contains("+")) {
        countryTel = widget.telephone.split(" ").first ?? "";
      }

      slugController.text = widget.slug;
      fullnameCotroller.text = widget.fullname;
      jobTitleCotroller.text = widget.jobTitle;
      descriptionCotroller.text = widget.description;
      emailController.text = widget.email;
      companyController.text = widget.company;
      phoneController.text = (widget.phone ?? "").isEmpty
          ? ""
          : widget.phone.split(" ").last ?? "";
      phone2Controller.text = (widget.phone2 ?? "").isEmpty
          ? ""
          : widget.phone2.split(" ").last ?? "";
      telephoneController.text = (widget.telephone ?? "").isEmpty
          ? ""
          : widget.telephone.split(" ").last ?? "";
      whatsappController.text = widget.whatsapp;
      websiteController.text = widget.website;
      if ((widget.website ?? "") != "") {
        isWebsiteLink = true;
      }
      addressController.text = widget.address;
      mapLinkController.text = widget.mapLink;
      if ((widget.mapLink ?? "") != "") {
        isMapLink = true;
      }
      marketingMaterialsController.text = widget.material;
      if ((widget.material ?? "") != "") {
        isMaterialLink = true;
      }
      twitterController.text = widget.twitter;
      facebookController.text = widget.facebook;
      linkedInController.text = widget.linkedIn;
      ytbController.text = widget.ytb;
      instagramController.text = widget.instagram;

      snapChatController.text = widget.snapchat;
      telegramController.text = widget.telegram;

      skypeController.text = widget.skype;
      wechatController.text = widget.wechat;
      tiktokController.text = widget.tiktok;
      pinterestController.text = widget.pinterest;

      bgColor = widget.bgColor;
      cardColor = widget.cardColor;
      fontColor = widget.fontColor;

      if ((widget.twitter ?? "") != "") {
        isTwitterLink = true;
      }

      if ((widget.instagram ?? "") != "") {
        isInstagramLink = true;
      }

      if ((widget.linkedIn ?? "") != "") {
        isLinkedInLink = true;
      }

      if ((widget.facebook ?? "") != "") {
        isFacebookLink = true;
      }

      if ((widget.ytb ?? "") != "") {
        isYouTubeLink = true;
      }

      if ((widget.snapchat ?? "") != "") {
        isSnapchatLink = true;
      }
      if ((widget.telegram ?? "") != "") {
        isTelegramLink = true;
      }

      if ((widget.skype ?? "") != "") {
        isSkypeLink = true;
      }

      if ((widget.wechat ?? "") != "") {
        isWeChatLink = true;
      }

      if ((widget.tiktok ?? "") != "") {
        isTikTokLink = true;
      }

      if ((widget.pinterest ?? "") != "") {
        isPinterestLink = true;
      }

      if ((widget.whatsapp ?? "") != "") {
        isWhatsAppLink = true;
      }
    });
  }

  @override
  void dispose() {
    focusNodeMap.dispose();
    focusNodeWebsite.dispose();
    focusNodeMaterial.dispose();

    focusNodeTwitter.dispose();
    focusNodeInstagram.dispose();
    focusNodeLinkedIn.dispose();

    focusNodeFacebook.dispose();
    focusNodeYouTube.dispose();

    focusNodeSnapchat.dispose();
    focusNodeTelegram.dispose();

    focusNodeSkype.dispose();

    focusNodeWeChat.dispose();
    focusNodeTikTok.dispose();
    focusNodePinterest.dispose();

    focusNodeWhatsApp.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: AppBar(
          backgroundColor: Color(COLOR_PRIMARY),
          title: commonTitleSmallWhite(context, "Edit Card"),
          elevation: 0,
          leading: InkWell(
            onTap: () {
              pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                _chooseMode(context);
              },
              child: Container(
                  margin: EdgeInsets.all(5),
                  child: Center(
                      child: commonTitleSmallWhite(context, "+ Add Item"))),
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    errorMessage = "";
                  });
                  if (providerListener.vcardData != null) {
                    if (providerListener.vcardData.title != null) {
                      EasyLoading.show(status: 'loading...');
                      saveCard("save");
                    } else {
                      EasyLoading.show(status: 'loading...');
                      saveCard("add");
                    }
                  } else {
                    EasyLoading.show(status: 'loading...');
                    saveCard("add");
                  }
                } else {
                  //  commonToast(context, "Please fill required data");
                  setState(() {
                    errorMessage = "Please fill required data";
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 80,
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Color(COLOR_PURPLE_PRIMARY),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(COLOR_PURPLE_PRIMARY).withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Save ",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          width: SizeConfig.screenWidth,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (errorMessage ?? "") == ""
                      ? Container()
                      : Container(
                          width: SizeConfig.screenWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              errorMessage ?? "",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  Visibility(
                    visible: pageIndex == 0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: slugController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(' ')
                                ],
                                readOnly: providerListener.memberShip == null
                                    ? true
                                    : false,
                                decoration: InputDecoration(
                                  hintText: 'Personalized link (eg. fullname)',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (providerListener.slug_list
                                        .contains(value)) {
                                      slug_error =
                                          "Please select another personalized link";
                                    } else {
                                      slug_error = "";
                                    }
                                  });
                                },
                              ),
                              slug_error == ""
                                  ? Container()
                                  : Container(
                                      width: SizeConfig.screenWidth,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(slug_error,
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.red))),
                                      ),
                                    ),
                              providerListener.memberShip == null
                                  ? InkWell(
                                      onTap: () {
                                        if (Platform.isAndroid) {
                                          push(context, PricingScreen(1));
                                        } else {
                                          commonToast(
                                              context, "Visit fliqcard.com");
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 5),
                                        child: redText(context,
                                            "Go premium, to use this feature."),
                                      ),
                                    )
                                  : providerListener.memberShip != null
                                      ? slug_error == ""
                                          ? InkWell(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                    text:
                                                        "https://fliqcard.com/id.php?name=" +
                                                            slugController
                                                                .text));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    commonTitleSmall(
                                                        context, "Copy Link"),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.copy,
                                                      color:
                                                          Color(COLOR_PRIMARY),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container()
                                      : SizedBox(
                                          width: 1,
                                        ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: fullnameCotroller,
                                validator: (value) {
                                  if (value != "") {
                                    return null;
                                  } else {
                                    return "Field required!";
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: jobTitleCotroller,
                                decoration: InputDecoration(
                                  hintText: 'Job title (Optional)',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: companyController,
                                readOnly: widget.centralized_center_on == "1"
                                    ? true
                                    : false,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.home_work_rounded,
                                    color: Colors.black87,
                                    size: 20,
                                  ),
                                  hintText: 'Company (Optional)',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: widget.centralized_center_on == "1"
                                      ? Colors.red.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: emailController,
                                validator: (email) {
                                  if (email != "") {
                                    if (isEmailValid(email)) {
                                      return null;
                                    } else
                                      return "Invalid email address";
                                  } else {
                                    return "Invalid email address";
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.black87,
                                    size: 20,
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.4),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  // for below version 2 use this
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    width: 70,
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          showCountryPicker(
                                            context: context,
                                            countryListTheme:
                                                CountryListThemeData(
                                              flagSize: 25,
                                              backgroundColor:
                                                  Color(COLOR_BACKGROUND),
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                              //Optional. Sets the border radius for the bottomsheet.
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                              ),
                                              //Optional. Styles the search field.

                                              inputDecoration: InputDecoration(
                                                labelText: 'Search',
                                                labelStyle: TextStyle(
                                                    color:
                                                        Color(COLOR_PRIMARY)),
                                                hintStyle: TextStyle(
                                                    color:
                                                        Color(COLOR_PRIMARY)),
                                                hintText:
                                                    'Start typing to search',
                                                prefixIcon: const Icon(
                                                  Icons.search,
                                                  color: Color(COLOR_PRIMARY),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Color(COLOR_PRIMARY)),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: const Color(
                                                            COLOR_PRIMARY)
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 1,
                                                        vertical: 1),
                                              ),
                                            ),
                                            onSelect: (Country OBJ) {
                                              setState(() {
                                                country1 = "+" +
                                                    (OBJ.phoneCode ?? 1)
                                                        .toString();
                                              });
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Container(
                                              child: Text(
                                            (country1).toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(COLOR_PRIMARY),
                                                fontWeight: FontWeight.w600),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  hintText: 'Primary Phone Number',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: phone2Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  // for below version 2 use this
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  // for version 2 and greater youcan also use this
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                /*validator: (value) {
                                  if (value != "") {
                                    return null;
                                  } else {
                                    return "Field required!";
                                  }
                                },*/
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    width: 70,
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          showCountryPicker(
                                            context: context,
                                            countryListTheme:
                                                CountryListThemeData(
                                              flagSize: 25,
                                              backgroundColor:
                                                  Color(COLOR_BACKGROUND),
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                              //Optional. Sets the border radius for the bottomsheet.
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                              ),
                                              //Optional. Styles the search field.

                                              inputDecoration: InputDecoration(
                                                labelText: 'Search',
                                                labelStyle: TextStyle(
                                                    color:
                                                        Color(COLOR_PRIMARY)),
                                                hintStyle: TextStyle(
                                                    color:
                                                        Color(COLOR_PRIMARY)),
                                                hintText:
                                                    'Start typing to search',
                                                prefixIcon: const Icon(
                                                  Icons.search,
                                                  color: Color(COLOR_PRIMARY),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Color(COLOR_PRIMARY)),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: const Color(
                                                            COLOR_PRIMARY)
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 1,
                                                        vertical: 1),
                                              ),
                                            ),
                                            onSelect: (Country OBJ) {
                                              setState(() {
                                                country2 = "+" +
                                                    (OBJ.phoneCode ?? 1)
                                                        .toString();
                                              });
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Container(
                                              child: Text(
                                            (country2).toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(COLOR_PRIMARY),
                                                fontWeight: FontWeight.w600),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  hintText: 'Secondary Phone Number (optional)',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                readOnly: widget.centralized_center_on == "1"
                                    ? true
                                    : false,
                                controller: telephoneController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  // for below version 2 use this
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                /*validator: (value) {
                                  if (value != "") {
                                    return null;
                                  } else {
                                    return "Field required!";
                                  }
                                },*/
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                    width: 70,
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          showCountryPicker(
                                            context: context,
                                            countryListTheme:
                                                CountryListThemeData(
                                              flagSize: 25,
                                              backgroundColor:
                                                  Color(COLOR_BACKGROUND),
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                              //Optional. Sets the border radius for the bottomsheet.
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                              ),
                                              //Optional. Styles the search field.

                                              inputDecoration: InputDecoration(
                                                labelText: 'Search',
                                                labelStyle: TextStyle(
                                                    color:
                                                        Color(COLOR_PRIMARY)),
                                                hintStyle: TextStyle(
                                                    color:
                                                        Color(COLOR_PRIMARY)),
                                                hintText:
                                                    'Start typing to search',
                                                prefixIcon: const Icon(
                                                  Icons.search,
                                                  color: Color(COLOR_PRIMARY),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Color(COLOR_PRIMARY)),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: const Color(
                                                            COLOR_PRIMARY)
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 1,
                                                        vertical: 1),
                                              ),
                                            ),
                                            onSelect: (Country OBJ) {
                                              setState(() {
                                                countryTel = "+" +
                                                    (OBJ.phoneCode ?? 1)
                                                        .toString();
                                              });
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Container(
                                              child: Text(
                                            (countryTel).toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(COLOR_PRIMARY),
                                                fontWeight: FontWeight.w600),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  hintText: 'Telephone Number (optional)',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: widget.centralized_center_on == "1"
                                      ? Colors.grey.withOpacity(0.4)
                                      : Colors.grey.withOpacity(0.1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                              Row(
                                children: [
                                  widget.centralized_center_on == "1"
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: commonTitleSmall(
                                              context, "Centralized by admin"),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                readOnly: widget.centralized_center_on == "1"
                                    ? true
                                    : false,
                                controller: addressController,
                                decoration: InputDecoration(
                                  hintText: 'Address (optional)',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: widget.centralized_center_on == "1"
                                      ? Colors.red.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                maxLength: 200,
                                maxLines: 3,
                                controller: descriptionCotroller,
                                decoration: InputDecoration(
                                  hintText:
                                      'Bio (Optional, max 200 characters)',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Color(COLOR_SUBTITLE)),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              children: [
                                isWhatsAppLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: whatsappController,
                                        focusNode: focusNodeWhatsApp,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            FlutterIcons.whatsapp_faw,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          hintText:
                                              'WhatsApp Number (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor:
                                              Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isWhatsAppLink == false
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: commonTitleSmall(context,
                                            "(Country code and number without any characters \neg. 91 1234567890)"),
                                      ),
                                isWhatsAppLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 20,
                                      ),
                                isWebsiteLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: websiteController,
                                        focusNode: focusNodeWebsite,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            FlutterIcons.earth_ant,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          hintText: 'Website',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isWebsiteLink == false
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: commonTitleSmall(context,
                                            "Website (Eg. www.google.com, google.com) without http or https"),
                                      ),
                                isWebsiteLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 20,
                                      ),
                                isMapLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: mapLinkController,
                                        focusNode: focusNodeMap,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.location_on,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          hintText:
                                              'Google Map Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isMapLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isTwitterLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: twitterController,
                                        focusNode: focusNodeTwitter,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            FlutterIcons.logo_twitter_ion,
                                            color: Colors.black,
                                          ),
                                          hintText: 'Twitter Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isTwitterLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isFacebookLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: facebookController,
                                        focusNode: focusNodeFacebook,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              FlutterIcons.logo_facebook_ion,
                                              color: Colors.black),
                                          hintText: 'Facebook Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isFacebookLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isLinkedInLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: linkedInController,
                                        focusNode: focusNodeLinkedIn,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              FlutterIcons.logo_linkedin_ion,
                                              color: Colors.black),
                                          hintText: 'LinkedIn Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isLinkedInLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isYouTubeLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: ytbController,
                                        focusNode: focusNodeYouTube,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                              FlutterIcons.logo_youtube_ion,
                                              color: Colors.black),
                                          hintText: 'YouTube Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isYouTubeLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isInstagramLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: instagramController,
                                        focusNode: focusNodeInstagram,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            FlutterIcons.logo_instagram_ion,
                                            color: Colors.black,
                                            size: 28,
                                          ),
                                          hintText: 'Instagram Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isInstagramLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isSkypeLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: skypeController,
                                        focusNode: focusNodeSkype,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            FlutterIcons.logo_skype_ion,
                                            color: Colors.black,
                                            size: 28,
                                          ),
                                          hintText: 'Skype Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isSkypeLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isSnapchatLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: snapChatController,
                                        focusNode: focusNodeSnapchat,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            FlutterIcons.logo_snapchat_ion,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                          hintText: 'Snapchat (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isSnapchatLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isTelegramLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: telegramController,
                                        focusNode: focusNodeTelegram,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Container(
                                            width: 15,
                                            margin: EdgeInsets.all(7),
                                            child: Image.asset(
                                              "assets/telegram.png",
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: 'Telegram (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isTelegramLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isWeChatLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: wechatController,
                                        focusNode: focusNodeWeChat,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Container(
                                            width: 25,
                                            margin: EdgeInsets.all(10),
                                            child: Image.asset(
                                              "assets/wechat.png",
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: 'Wechat Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isWeChatLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isTikTokLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: tiktokController,
                                        focusNode: focusNodeTikTok,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Container(
                                            width: 15,
                                            margin: EdgeInsets.all(14),
                                            child: Image.asset(
                                              "assets/tiktok.png",
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: 'Tiktok Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isTikTokLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isPinterestLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller: pinterestController,
                                        focusNode: focusNodePinterest,
                                        readOnly:
                                            widget.centralized_center_on == "1"
                                                ? true
                                                : false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            FlutterIcons.logo_pinterest_ion,
                                            color: Colors.black,
                                            size: 22,
                                          ),
                                          hintText: 'Pinterest Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor: widget
                                                      .centralized_center_on ==
                                                  "1"
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isPinterestLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                                isMaterialLink == false
                                    ? Container()
                                    : TextFormField(
                                        controller:
                                            marketingMaterialsController,
                                        focusNode: focusNodeMaterial,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.link,
                                            color: Colors.black,
                                            size: 28,
                                          ),
                                          hintText:
                                              'Marketing Materials Link (optional)',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(COLOR_SUBTITLE)),
                                          filled: true,
                                          fillColor:
                                              Colors.grey.withOpacity(0.1),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                        ),
                                      ),
                                isMaterialLink == false
                                    ? Container()
                                    : SizedBox(
                                        height: 16,
                                      ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: pageIndex == 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 100,
                                child: commonTitleSmall(
                                    context, '1. Background Color (optional)')),
                            CircleColorPicker(
                              controller: bgcolorController,
                              onChanged: (color) {
                                if (providerListener.memberShip == null) {
                                  /* commonToast(context,
                                      "Go premium, to use this feature.");*/
                                  setState(() {
                                    errorMessage =
                                        "Go premium, to use this feature.";
                                  });
                                } else {
                                  setState(() {
                                    return bgColor = color
                                        .toString()
                                        .replaceAll("Color(0xff", "#")
                                        .replaceAll(")", "");
                                  });
                                }
                              },
                              size: const Size(200, 200),
                              strokeWidth: 4,
                              thumbSize: 12,
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 100,
                                child: commonTitleSmall(
                                    context, '2. Card Color (optional)')),
                            CircleColorPicker(
                              controller: cardcolorController,
                              onChanged: (color) {
                                if (providerListener.memberShip == null) {
                                  /* commonToast(context,
                                      "Go premium, to use this feature.");*/
                                  setState(() {
                                    errorMessage =
                                        "Go premium, to use this feature.";
                                  });
                                } else {
                                  setState(() => cardColor = color
                                      .toString()
                                      .replaceAll("Color(0xff", "#")
                                      .replaceAll(")", ""));
                                }
                              },
                              size: const Size(200, 200),
                              strokeWidth: 4,
                              thumbSize: 12,
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 100,
                                child:
                                    commonTitleSmall(context, '3. Font Color')),
                            Column(
                              children: [
                                CircleColorPicker(
                                  controller: fontcolorController,
                                  onChanged: (color) {
                                    if (providerListener.memberShip == null) {
                                      /*   commonToast(context,
                                          "Go premium, to use this feature.");*/
                                      setState(() {
                                        errorMessage =
                                            "Go premium, to use this feature.";
                                      });
                                    } else {
                                      setState(() => fontColor = color
                                          .toString()
                                          .replaceAll("Color(0xff", "#")
                                          .replaceAll(")", ""));
                                    }
                                  },
                                  size: const Size(200, 200),
                                  strokeWidth: 4,
                                  thumbSize: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: pageIndex == 2,
                    child: Column(
                      children: [
                        widget.centralized_center_on == "1"
                            ? SizedBox(
                                height: 30,
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  commonTitleSmall(context,
                                      "Banner Video (mp4 only, recommended size less than 5 MB) \nOR\n Image recommended (600 X 300, 2:1)"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  commonTitleSmallBold(
                                      context, "Select Image OR Video"),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      AnimatedRadioButtons(
                                        value: myVar,
                                        backgroundColor: Colors.transparent,
                                        layoutAxis: Axis.vertical,
                                        buttonRadius: 25.0,
                                        items: [
                                          AnimatedRadioButtonItem(
                                              label: "Image",
                                              color: Color(COLOR_PRIMARY),
                                              fillInColor:
                                                  Color(COLOR_SECONDARY)),
                                          AnimatedRadioButtonItem(
                                              label: "Video",
                                              color: Color(COLOR_PRIMARY),
                                              fillInColor:
                                                  Color(COLOR_SECONDARY)),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == 1 &&
                                                providerListener.memberShip ==
                                                    null) {
                                              /* commonToast(
                                        context, "Go premium, to add video.");*/
                                              setState(() {
                                                errorMessage =
                                                    "Go premium, to add video.";
                                              });
                                            } else {
                                              myVar = value;
                                              print(value);
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      myVar == 0
                                          ? Container(
                                              child: Column(children: <Widget>[
                                              RaisedButton(
                                                onPressed: () {
                                                  _pickBannerImage();
                                                },
                                                child: Text("Choose Image"),
                                              ),
                                            ]))
                                          : Container(
                                              child: Column(children: <Widget>[
                                              RaisedButton(
                                                onPressed: () {
                                                  _pickVideo();
                                                },
                                                child: Text("Choose Video"),
                                              ),
                                            ])),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 200,
                                        child: Column(
                                          children: [
                                            _banner != null
                                                ? commonTitleSmall(
                                                    context,
                                                    _banner.path
                                                            .split("/")
                                                            .last ??
                                                        "")
                                                : SizedBox(
                                                    width: 1,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  providerListener.vcardData != null
                                      ? providerListener.vcardData.title != null
                                          ? providerListener.vcardData
                                                          .bannerImagePath !=
                                                      "" &&
                                                  providerListener.vcardData
                                                          .bannerImagePath !=
                                                      null &&
                                                  !providerListener
                                                      .vcardData.bannerImagePath
                                                      .contains("mp4")
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 70.0,
                                                      height: 70.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff7c94b6),
                                                        image: DecorationImage(
                                                          image: NetworkImage(apiUrl +
                                                              "../../" +
                                                              providerListener
                                                                  .vcardData
                                                                  .bannerImagePath),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                        border: Border.all(
                                                          color: Color(int.parse(
                                                              providerListener
                                                                  .vcardData
                                                                  .fontcolor
                                                                  .replaceAll(
                                                                      "#",
                                                                      "0xff"))),
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 50,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Provider.of<CustomViewModel>(
                                                                context,
                                                                listen: false)
                                                            .deleteBanner()
                                                            .then((value) {
                                                          setState(() {
                                                            providerListener
                                                                .vcardData
                                                                .bannerImagePath = "";
                                                            errorMessage =
                                                                value;
                                                          });
                                                          // commonToast(context, value);
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 80,
                                                        margin: EdgeInsets.only(
                                                            bottom: 20),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(
                                                                      COLOR_SECONDARY)
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset:
                                                                  Offset(0, 3),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Delete",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 1,
                                                )
                                          : SizedBox(
                                              height: 1,
                                            )
                                      : SizedBox(
                                          height: 1,
                                        ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Divider(),
                                  commonTitleSmall(context,
                                      "Logo (Image Only, recommended 512 X 512, 1:1)"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: Column(children: <Widget>[
                                        RaisedButton(
                                          onPressed: () {
                                            _pickLogoImage();
                                          },
                                          child: Text("Choose Image"),
                                        ),
                                      ])),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 200,
                                        child: Column(
                                          children: [
                                            _logo != null
                                                ? commonTitleSmall(
                                                    context,
                                                    _logo.path
                                                            .split("/")
                                                            .last ??
                                                        "")
                                                : SizedBox(
                                                    width: 1,
                                                  ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  providerListener.vcardData != null
                                      ? providerListener.vcardData.title != null
                                          ? providerListener.vcardData
                                                          .logoImagePath !=
                                                      "" &&
                                                  providerListener.vcardData
                                                          .logoImagePath !=
                                                      null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 70.0,
                                                      height: 70.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff7c94b6),
                                                        image: DecorationImage(
                                                          image: NetworkImage(apiUrl +
                                                              "../../" +
                                                              providerListener
                                                                  .vcardData
                                                                  .logoImagePath),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                        border: Border.all(
                                                          color: Color(int.parse(
                                                              providerListener
                                                                  .vcardData
                                                                  .fontcolor
                                                                  .replaceAll(
                                                                      "#",
                                                                      "0xff"))),
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 50,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Provider.of<CustomViewModel>(
                                                                context,
                                                                listen: false)
                                                            .deleteLogo()
                                                            .then((value) {
                                                          setState(() {
                                                            providerListener
                                                                .vcardData
                                                                .logoImagePath = "";
                                                            errorMessage =
                                                                value;
                                                          });
                                                          // commonToast(context, value);
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 80,
                                                        margin: EdgeInsets.only(
                                                            bottom: 20),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(
                                                                      COLOR_SECONDARY)
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset:
                                                                  Offset(0, 3),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Delete",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 1,
                                                )
                                          : SizedBox(
                                              height: 1,
                                            )
                                      : SizedBox(
                                          height: 1,
                                        ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Divider(),
                                ],
                              ),
                        commonTitleSmall(context,
                            "Profile (Image Only, recommended 512 X 512, 1:1)"),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                child: Column(children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  _pickProfileImage();
                                },
                                child: Text("Choose Image"),
                              ),
                            ])),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 200,
                              child: Column(
                                children: [
                                  _profile != null
                                      ? commonTitleSmall(context,
                                          _profile.path.split("/").last ?? "")
                                      : SizedBox(
                                          width: 1,
                                        ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        providerListener.vcardData != null
                            ? providerListener.vcardData.title != null
                                ? providerListener.vcardData.profileImagePath !=
                                            "" &&
                                        providerListener
                                                .vcardData.profileImagePath !=
                                            null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff7c94b6),
                                              image: DecorationImage(
                                                image: NetworkImage(apiUrl +
                                                    "../../" +
                                                    providerListener.vcardData
                                                        .profileImagePath),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                              border: Border.all(
                                                color: Color(int.parse(
                                                    providerListener
                                                        .vcardData.fontcolor
                                                        .replaceAll(
                                                            "#", "0xff"))),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<CustomViewModel>(
                                                      context,
                                                      listen: false)
                                                  .deleteProfile()
                                                  .then((value) {
                                                setState(() {
                                                  providerListener.vcardData
                                                      .profileImagePath = "";
                                                  errorMessage = value;
                                                });
                                                //commonToast(context, value);
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 80,
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        Color(COLOR_SECONDARY)
                                                            .withOpacity(0.2),
                                                    spreadRadius: 3,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Delete",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        height: 1,
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
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _chooseMode(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffE3E8FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 25),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 140,
                              child: Text(
                                "+ Add Item",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Color(COLOR_PRIMARY),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              pop(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Container(
                                  child: Icon(
                                Icons.close,
                                size: 25,
                                color: Color(COLOR_PRIMARY),
                              )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isMapLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeMap);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 27.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/map_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Address Link",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isTwitterLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeTwitter);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 45.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/twitter_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Twitter",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isFacebookLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeFacebook);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 22.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/facebook_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Facebook",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isWeChatLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeWeChat);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 45.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/wechat_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Wechat",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isWhatsAppLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeWhatsApp);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/whatsapp_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("WhatsApp",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isWebsiteLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeWebsite);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/website_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Website",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isInstagramLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeInstagram);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/instagram_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Instagram",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isYouTubeLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeYouTube);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 45.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/youtube_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Youtube",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isTikTokLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeTikTok);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/tiktok_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Tik Tok",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isSnapchatLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeSnapchat);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      FlutterIcons.logo_snapchat_ion,
                                      size: 32,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Snapchat",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isMaterialLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeMaterial);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 30.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/file_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("PDF Link",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isLinkedInLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeLinkedIn);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/linkedin_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("LinkedIn",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isSkypeLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeSkype);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/skype_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Skype",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isPinterestLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodePinterest);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/pinterest_tab.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Pinterest",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isTelegramLink = true;
                                  });

                                  EasyLoading.show();
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    EasyLoading.dismiss();
                                    FocusScope.of(context)
                                        .requestFocus(focusNodeTelegram);
                                    pop(context);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50.0,
                                      height: 33.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/telegram.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Text("Telegram",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE))))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
