import 'dart:io';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Contacts/ImportFromDeviceScreen.dart';
import 'package:fliqcard/UI/Follow/ListOfFollow.dart';
import 'package:fliqcard/UI/Pricing/PricingScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'ViewProfile.dart';

BuildContext parentContext;

class ContactsScreenNew extends StatefulWidget {
  @override
  _ContactsScreenNewState createState() => _ContactsScreenNewState();
}

class _ContactsScreenNewState extends State<ContactsScreenNew> {
  TextEditingController searchController = new TextEditingController();

  List<String> categoriesList = [
    "New",
    "All",
    "Client",
    "Family",
    "Friend",
    "Business",
    "Vendor",
    "Other"
  ];

  int getCount(category) {
    switch (category) {
      case "New":
        return Provider.of<CustomViewModel>(context, listen: false)
                .contactsNEW_COUNT ??
            0;
        break;
      case "Client":
        return Provider.of<CustomViewModel>(context, listen: false)
                .contactsCLIENT_COUNT ??
            0;
        break;
      case "Family":
        return Provider.of<CustomViewModel>(context, listen: false)
                .contactsFAMILY_COUNT ??
            0;
        break;
      case "Friend":
        return Provider.of<CustomViewModel>(context, listen: false)
                .contactsFRIEND_COUNT ??
            0;
        break;
      case "Business":
        return Provider.of<CustomViewModel>(context, listen: false)
                .contactsBUSINESS_COUNT ??
            0;
        break;
      case "Vendor":
        return Provider.of<CustomViewModel>(context, listen: false)
                .contactsVENDOR_COUNT ??
            0;
        break;
      case "Other":
        return Provider.of<CustomViewModel>(context, listen: false)
                .contactsOTHER_COUNT ??
            0;
        break;
      default:
        return Provider.of<CustomViewModel>(context, listen: false)
            .contactsList
            .length;
        break;
    }
  }

  Future initTask() {
    EasyLoading.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .getLatestContacts()
        .then((value) {
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTask();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    setState(() {
      parentContext = context;
    });

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: SizeConfig.screenWidth / 1.08,
                  height: 35,
                  child: Center(
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: 18,
                          color: Color(COLOR_PRIMARY),
                        ),
                        suffixIcon: searchController.text == ""
                            ? null
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    searchController.text = "";
                                  });
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Color(COLOR_PRIMARY),
                                ),
                              ),
                        hintText: 'Search',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                (providerListener.codeSeected ?? "") == ""
                    ? Container()
                    : Row(
                        children: [
                          SizedBox(width: 15),
                          Center(
                            child: Text(
                              "Country Selected  ",
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Provider.of<CustomViewModel>(context,
                                      listen: false)
                                  .setCountryCodeFilter("", "",
                                      providerListener.selectedCategory);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          12.0) ////              <--- border radius here
                                      ),
                                  color: Color(COLOR_PURPLE_PRIMARY)
                                      .withOpacity(0.8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(
                                        (providerListener.codeSeected ?? ""),
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 7,
                                          child: Icon(
                                            Icons.clear,
                                            size: 10,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                (providerListener.codeSeected ?? "") == ""
                    ? Container()
                    : SizedBox(
                        height: 10,
                      ),
                (providerListener.codeSeected ?? "") == ""
                    ? Row(
                        children: [
                          SizedBox(width: 15),
                          Container(
                            height: 25,
                            width: SizeConfig.screenWidth - 15,
                            child: ListView.builder(
                                itemCount: categoriesList.length + 1,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return index == 0
                                      ? Center(
                                          child: Text(
                                            "Filter options  ",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              providerListener
                                                      .selectedCategory =
                                                  categoriesList[index - 1];
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          12.0) ////              <--- border radius here
                                                      ),
                                                  color: providerListener
                                                              .selectedCategory ==
                                                          categoriesList[
                                                              index - 1]
                                                      ? Color(COLOR_PURPLE_PRIMARY)
                                                          .withOpacity(0.8)
                                                      : Colors.grey
                                                          .withOpacity(0.3)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Text(
                                                      categoriesList[index - 1],
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: providerListener
                                                                    .selectedCategory ==
                                                                categoriesList[
                                                                    index - 1]
                                                            ? Colors.white
                                                            : Colors.black,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      providerListener
                                                                  .contactsList
                                                                  .length ==
                                                              0
                                                          ? ""
                                                          : ("/ " +
                                                              (((getCount(categoriesList[index -
                                                                              1]) /
                                                                          providerListener
                                                                              .contactsList
                                                                              .length) *
                                                                      100.0)
                                                                  .round()
                                                                  .toString()) +
                                                              "%"),
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: providerListener
                                                                    .selectedCategory ==
                                                                categoriesList[
                                                                    index - 1]
                                                            ? Colors.white
                                                            : Colors.black,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    providerListener
                                                                .selectedCategory !=
                                                            categoriesList[
                                                                index - 1]
                                                        ? Container()
                                                        : CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 7,
                                                            child: Icon(
                                                              Icons.clear,
                                                              size: 10,
                                                            ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                }),
                          ),
                        ],
                      )
                    : Container(),
                (providerListener.codeSeected ?? "") == ""
                    ? SizedBox(
                        height: 20,
                      )
                    : SizedBox(
                        height: 1,
                      ),
                //105
                providerListener.contactsList.length == 0
                    ? Container()
                    : getCount(providerListener.selectedCategory) == 0
                        ? Container()
                        : Container(
                            height: 40,
                            color: Color(COLOR_PURPLE_PRIMARY).withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: commonTitle(
                                      context,
                                      (getCount(providerListener
                                                  .selectedCategory)
                                              .toString()) +
                                          " Network"),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      height: 20,
                                      width: 1,
                                      color: Color(COLOR_PRIMARY),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (providerListener.userData != null &&
                                            providerListener.memberShip !=
                                                null) {
                                          push(context, ListOfFollow());
                                        } else {
                                          if (Platform.isAndroid) {
                                            push(context, PricingScreen(1));
                                          } else {
                                            commonToast(
                                                context, "Visit fliqcard.com");
                                          }
                                        }
                                      },
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/followup_icon.png",
                                              width: 20,
                                              color: Color(COLOR_PRIMARY),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "Follow Up",
                                                style: GoogleFonts.montserrat(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Color(COLOR_PRIMARY),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 20,
                                      width: 1,
                                      color: Color(COLOR_PRIMARY),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (Platform.isIOS) {
                                          commonLaunchURL(apiUrl +
                                              "/../csvContacts2.php?category_name=" +
                                              (providerListener
                                                      .selectedCategory ??
                                                  "") +
                                              "&email=" +
                                              (providerListener
                                                      .userData.email ??
                                                  ""));
                                        } else {
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
                                                                      "Import/Export",
                                                                      textScaleFactor:
                                                                          1,
                                                                      style: GoogleFonts.montserrat(
                                                                          textStyle: TextStyle(
                                                                              letterSpacing: 1,
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Color(COLOR_SECONDARY)))),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    pop(context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
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
                                                            onTap: () async {
                                                              pop(context);
                                                              // Get all contacts on device
                                                              push(
                                                                  parentContext,
                                                                  ImportFromDeviceScreen());
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
                                                                      "Import from device",
                                                                      textScaleFactor:
                                                                          1,
                                                                      style: GoogleFonts.montserrat(
                                                                          textStyle: TextStyle(
                                                                              letterSpacing: 1,
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Color(COLOR_PRIMARY)))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              pop(context);
                                                              commonLaunchURL(apiUrl +
                                                                  "/../csvContacts2.php?category_name=" +
                                                                  (providerListener
                                                                          .selectedCategory ??
                                                                      "") +
                                                                  "&email=" +
                                                                  (providerListener
                                                                          .userData
                                                                          .email ??
                                                                      ""));
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
                                                                      "Export csv & import to google",
                                                                      textScaleFactor:
                                                                          1,
                                                                      style: GoogleFonts.montserrat(
                                                                          textStyle: TextStyle(
                                                                              letterSpacing: 1,
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.w400,
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
                                        }
                                      },
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.import_export,
                                              size: 15,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                "Import/Export",
                                                style: GoogleFonts.montserrat(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Color(COLOR_PRIMARY),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
              ],
            ),
            SingleChildScrollView(
              child: providerListener.contactsList.length > 0
                  ? Container(
                      height: SizeConfig.screenHeight - (310),
                      child: ListView.builder(
                          itemCount: providerListener.contactsList.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ((providerListener.contactsList[index].category ?? "") !=
                                        providerListener.selectedCategory &&
                                    providerListener.selectedCategory != "All")
                                ? Container()
                                : (searchController.text.isNotEmpty &&
                                        !(providerListener.contactsList[index].name ?? "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toLowerCase()) &&
                                        !(providerListener.contactsList[index].email ?? "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toLowerCase()) &&
                                        !(providerListener.contactsList[index].phone ?? "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toLowerCase()) &&
                                        !(providerListener.contactsList[index]
                                                    .company ??
                                                "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text.toLowerCase()) &&
                                        !(providerListener.contactsList[index].tags ?? "").toString().toLowerCase().contains(searchController.text.toLowerCase()))
                                    ? Container()
                                    : (!(providerListener.contactsList[index].phone ?? "").contains(providerListener.codeSeected ?? ""))
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              push(context, ViewProfile(index));
                                            },
                                            child: Card(
                                              elevation: 0,
                                              color: Color(COLOR_BACKGROUND),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 16,
                                                                  right: 10,
                                                                  bottom: 10),
                                                          child: Container(
                                                            width: 55.0,
                                                            height: 55.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image: (providerListener.contactsList[index].userId ??
                                                                                "0")
                                                                            .toString() ==
                                                                        "0"
                                                                    ? AssetImage(
                                                                        "assets/profile.png")
                                                                    : (providerListener.contactsList[index].profileImagePath ?? "").toString() ==
                                                                            ""
                                                                        ? AssetImage(
                                                                            "assets/profile.png")
                                                                        : NetworkImage(apiUrl +
                                                                                "../../" +
                                                                                providerListener.contactsList[index].profileImagePath ??
                                                                            ""),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5.0)),
                                                              border:
                                                                  Border.all(
                                                                color: Color(
                                                                    COLOR_SECONDARY),
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child: (providerListener
                                                                              .contactsList[index]
                                                                              .userId ??
                                                                          "0")
                                                                      .toString() ==
                                                                  "0"
                                                              ? Container()
                                                              : InkWell(
                                                                  onTap: () {
                                                                    commonLaunchURL((apiUrl +
                                                                        "/../visitcard.php?id=" +
                                                                        providerListener
                                                                            .contactsList[
                                                                                index]
                                                                            .userId +
                                                                        "&c_id=" +
                                                                        providerListener
                                                                            .contactsList[index]
                                                                            .id));
                                                                  },
                                                                  child: Card(
                                                                      shape:
                                                                          CircleBorder(),
                                                                      color: Colors
                                                                          .white,
                                                                      elevation:
                                                                          7,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(2.0),
                                                                          child: Image.asset(
                                                                              'assets/logo.png',
                                                                              width: 22),
                                                                        ),
                                                                      )),
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: SizeConfig
                                                              .screenWidth -
                                                          120,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: SizeConfig
                                                                        .screenWidth -
                                                                    200,
                                                                child: Text(
                                                                    providerListener
                                                                            .contactsList[
                                                                                index]
                                                                            .name ??
                                                                        "",
                                                                    style: GoogleFonts.montserrat(
                                                                        fontSize:
                                                                            18.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Color(
                                                                            COLOR_TITLE))),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              providerListener.contactsList[index].updated_at !=
                                                                          "" &&
                                                                      providerListener
                                                                              .contactsList[
                                                                                  index]
                                                                              .updated_at !=
                                                                          null
                                                                  ? DateTime.now().difference(DateTime.parse(providerListener.contactsList[index].updated_at)).inDays <
                                                                              6 &&
                                                                          providerListener.contactsList[index].viewed ==
                                                                              "0"
                                                                      ? Icon(
                                                                          Icons
                                                                              .circle,
                                                                          size:
                                                                              12,
                                                                          color: Colors
                                                                              .yellow
                                                                              .shade800,
                                                                        )
                                                                      : SizedBox(
                                                                          height:
                                                                              1,
                                                                        )
                                                                  : SizedBox(
                                                                      height: 1,
                                                                    ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                providerListener
                                                                        .contactsList[
                                                                            index]
                                                                        .category ??
                                                                    "",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontSize:
                                                                      13.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                      COLOR_PRIMARY),
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    width: 20,
                                                                    height: 2,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          2),
                                                                  Container(
                                                                    width: 20,
                                                                    height: 2,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500,
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            providerListener
                                                                    .contactsList[
                                                                        index]
                                                                    .phone ??
                                                                "",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          (providerListener
                                                                          .contactsList[
                                                                              index]
                                                                          .phone ??
                                                                      "")
                                                                  .contains("+")
                                                              ? Container()
                                                              : Text(
                                                                  "Country code missing",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    fontSize:
                                                                        10.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .red
                                                                        .shade800,
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          (providerListener
                                                                          .contactsList[
                                                                              index]
                                                                          .is_paper ??
                                                                      "0") ==
                                                                  "0"
                                                              ? Container()
                                                              : Row(
                                                                  children: [
                                                                    Container(
                                                                      color: Color(
                                                                          COLOR_PRIMARY),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(1.0),
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/scanner.png",
                                                                          width:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Text(
                                                                      "Paper Scanned",
                                                                      style: GoogleFonts
                                                                          .montserrat(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: Color(
                                                                            COLOR_PRIMARY),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                          SizedBox(height: 6),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              providerListener
                                                                          .contactsList[
                                                                              index]
                                                                          .type ==
                                                                      "Sent"
                                                                  ? Row(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/sent_fliq.png",
                                                                          width:
                                                                              12,
                                                                          color: Colors
                                                                              .yellow
                                                                              .shade800,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                          "Sent FliQ",
                                                                          style:
                                                                              GoogleFonts.montserrat(
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Colors.yellow.shade900,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .call_received_rounded,
                                                                          color:
                                                                              Color(COLOR_PRIMARY),
                                                                          size:
                                                                              14,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                          "Received FliQ",
                                                                          style:
                                                                              GoogleFonts.montserrat(
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Color(COLOR_PRIMARY),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                              (providerListener.contactsList[index].userId ??
                                                                              "0")
                                                                          .toString() ==
                                                                      "0"
                                                                  ? Container()
                                                                  : InkWell(
                                                                      onTap:
                                                                          () {
                                                                        commonLaunchURL((apiUrl +
                                                                            "/../visitcard.php?id=" +
                                                                            providerListener.contactsList[index].userId +
                                                                            "&c_id=" +
                                                                            providerListener.contactsList[index].id));
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              "View ",
                                                                              style: GoogleFonts.montserrat(fontSize: 12.0, fontWeight: FontWeight.w500, color: Color(COLOR_PRIMARY), decoration: TextDecoration.underline),
                                                                            ),
                                                                            Text(
                                                                              "FliQCard",
                                                                              style: GoogleFonts.montserrat(fontSize: 12.0, fontWeight: FontWeight.w800, color: Colors.yellow.shade800, decoration: TextDecoration.underline),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
                                                            ],
                                                          ),
                                                          SizedBox(height: 6),
                                                          providerListener
                                                                          .contactsList[
                                                                              index]
                                                                          .updated_at !=
                                                                      "" &&
                                                                  providerListener
                                                                          .contactsList[
                                                                              index]
                                                                          .updated_at !=
                                                                      null
                                                              ? DateTime.now().difference(DateTime.parse(providerListener.contactsList[index].updated_at)).inDays <
                                                                          6 &&
                                                                      providerListener
                                                                              .contactsList[index]
                                                                              .viewed ==
                                                                          "0"
                                                                  ? Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5)),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            "Updated at ",
                                                                            style:
                                                                                GoogleFonts.montserrat(color: Colors.black, fontSize: 12),
                                                                          ),
                                                                          Text(
                                                                            providerListener.contactsList[index].updated_at,
                                                                            style: GoogleFonts.montserrat(
                                                                                color: Colors.green,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 12),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : SizedBox(
                                                                      height: 1,
                                                                    )
                                                              : SizedBox(
                                                                  height: 1,
                                                                ),
                                                          Divider(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                          }),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
