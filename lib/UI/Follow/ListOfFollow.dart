import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ViewProfileFollowup.dart';

class ListOfFollow extends StatefulWidget {
  @override
  _ListOfFollowState createState() => _ListOfFollowState();
}

class _ListOfFollowState extends State<ListOfFollow> {
  TextEditingController searchController = new TextEditingController();

  var created = "";
  bool _isloaded = false;
  bool _isSearchBarOpen = false;
  TextEditingController searchTextController = new TextEditingController();
  TextEditingController notesController = TextEditingController();

  FocusNode focusSearch = FocusNode();
  int _selectedTab = 0;

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future getFollowup() async {
    setState(() {
      _isloaded = false;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .getFollowup(_selectedTab == 0 ? "pending" : "complete")
        .then((value) {
      setState(() {
        if (value == "success") {
          setState(() {
            _isloaded = true;
          });
        } else {
          //commonToast(context, value);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getFollowup();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(115),
          child: Container(
            color: Color(COLOR_PRIMARY),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        commonTitleSmallBoldWhite(context, " Follow Up"),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedTab = 0;
                              getFollowup();
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              commonTitleSmallBoldWhite(context, "Pending"),
                              _selectedTab != 0
                                  ? Container(
                                      height: 19,
                                      width: SizeConfig.screenWidth / 3 + 16,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        height: 3,
                                        width: SizeConfig.screenWidth / 3,
                                        color: Colors.white,
                                      ),
                                    )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedTab = 1;
                              getFollowup();
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              commonTitleSmallBoldWhite(context, "Completed"),
                              _selectedTab != 1
                                  ? Container(
                                      height: 19,
                                      width: SizeConfig.screenWidth / 3 + 16,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        height: 3,
                                        width: SizeConfig.screenWidth / 3,
                                        color: Colors.white,
                                      ),
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: _isloaded == false
                ? Container(
                    height: SizeConfig.screenHeight / 2,
                    child: Center(
                      child: new CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Color(COLOR_PRIMARY),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(COLOR_BACKGROUND)),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: SizeConfig.screenWidth / 1.08,
                        height: 35,
                        child: Center(
                          child: TextFormField(
                            onEditingComplete: () {
                              setState(() {
                                FocusManager.instance.primaryFocus?.unfocus();
                              });
                            },
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
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      providerListener.followupList.length > 0
                          ? ListView.builder(
                              itemCount: providerListener.followupList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return (searchController.text.isNotEmpty &&
                                        !(providerListener.followupList[index].name ?? "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toLowerCase()) &&
                                        !(providerListener.followupList[index].email ?? "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toLowerCase()) &&
                                        !(providerListener.followupList[index].phone ?? "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toLowerCase()) &&
                                        !(providerListener.followupList[index].about ?? "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toLowerCase()) &&
                                        !(providerListener.followupList[index]
                                                    .about ??
                                                "")
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text.toLowerCase()))
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          push(
                                              context,
                                              ViewProfileFollowup(
                                                  index,
                                                  (_selectedTab == 0
                                                      ? "pending"
                                                      : "complete")));
                                        },
                                        child: Card(
                                          elevation: 0,
                                          color: Color(COLOR_BACKGROUND),
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
                                                        const EdgeInsets.only(
                                                            left: 16,
                                                            right: 10,
                                                            bottom: 10),
                                                    child: Container(
                                                      width: 55.0,
                                                      height: 55.0,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: (providerListener
                                                                              .followupList[
                                                                                  index]
                                                                              .profileImagePath ??
                                                                          "")
                                                                      .toString() ==
                                                                  ""
                                                              ? AssetImage(
                                                                  "assets/profile.png")
                                                              : (providerListener.followupList[index].profileImagePath ??
                                                                              "")
                                                                          .toString() ==
                                                                      ""
                                                                  ? AssetImage(
                                                                      "assets/profile.png")
                                                                  : NetworkImage(apiUrl +
                                                                          "../../" +
                                                                          providerListener
                                                                              .followupList[index]
                                                                              .profileImagePath ??
                                                                      ""),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                        border: Border.all(
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
                                                                        .followupList[
                                                                            index]
                                                                        .profileImagePath ??
                                                                    "")
                                                                .toString() ==
                                                            ""
                                                        ? Container()
                                                        : InkWell(
                                                            onTap: () {
                                                              commonLaunchURL((apiUrl +
                                                                  "/../visitcard.php?id=" +
                                                                  providerListener
                                                                      .followupList[
                                                                          index]
                                                                      .vcardId));
                                                            },
                                                            child: Card(
                                                                shape:
                                                                    CircleBorder(),
                                                                color: Colors
                                                                    .white,
                                                                elevation: 7,
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            2.0),
                                                                    child: Image.asset(
                                                                        'assets/logo.png',
                                                                        width:
                                                                            22),
                                                                  ),
                                                                )),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: SizeConfig.screenWidth -
                                                    120,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: SizeConfig
                                                              .screenWidth -
                                                          200,
                                                      child: Text(
                                                          providerListener
                                                                  .followupList[
                                                                      index]
                                                                  .name ??
                                                              "",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      COLOR_TITLE))),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    (providerListener
                                                                    .followupList[
                                                                        index]
                                                                    .email ??
                                                                "") ==
                                                            ""
                                                        ? Container()
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                providerListener
                                                                        .followupList[
                                                                            index]
                                                                        .email ??
                                                                    "",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                      COLOR_PRIMARY),
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade800,
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                    (providerListener
                                                                    .followupList[
                                                                        index]
                                                                    .email ??
                                                                "") ==
                                                            ""
                                                        ? Container()
                                                        : SizedBox(
                                                            height: 7,
                                                          ),
                                                    (providerListener
                                                                    .followupList[
                                                                        index]
                                                                    .createdAt ??
                                                                "") ==
                                                            ""
                                                        ? Container()
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Follow up on " +
                                                                    (providerListener.followupList[index].createdAt ??
                                                                            "")
                                                                        .toString()
                                                                        .replaceAll(
                                                                            "T",
                                                                            ", "),
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                    (providerListener
                                                                    .followupList[
                                                                        index]
                                                                    .createdAt ??
                                                                "") ==
                                                            ""
                                                        ? Container()
                                                        : SizedBox(
                                                            height: 3,
                                                          ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    _selectedTab == 1
                                                        ? SizedBox()
                                                        : Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  created = (providerListener
                                                                              .followupList[
                                                                                  index]
                                                                              .createdAt ??
                                                                          "")
                                                                      .replaceAll(
                                                                          ":",
                                                                          "");
                                                                  created = created
                                                                      .replaceAll(
                                                                          "T",
                                                                          "+");
                                                                  created = created
                                                                      .replaceAll(
                                                                          "-",
                                                                          "");

                                                                  created =
                                                                      created +
                                                                          "00";

                                                                  EasyLoading
                                                                      .dismiss();

                                                                  commonLaunchURL("https://calendar.google.com/calendar/u/0/r/eventedit?action=TEMPLATE&text=" +
                                                                      (providerListener
                                                                              .followupList[
                                                                                  index]
                                                                              .name ??
                                                                          "") +
                                                                      "&details=" +
                                                                      (providerListener
                                                                              .followupList[index]
                                                                              .about ??
                                                                          "") +
                                                                      "&dates=" +
                                                                      created +
                                                                      "/" +
                                                                      created);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        COLOR_PURPLE_PRIMARY),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                              5),
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .date_range,
                                                                            color:
                                                                                Colors.white,
                                                                            size: 18),
                                                                        SizedBox(
                                                                          width:
                                                                              7,
                                                                        ),
                                                                        Text(
                                                                          "Add To Google Calendar",
                                                                          style:
                                                                              GoogleFonts.montserrat(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                    Divider(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              })
                          : Container(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 10.0,
      width: 10.0,
      decoration: new BoxDecoration(
        color: Color(COLOR_PRIMARY),
        shape: BoxShape.circle,
      ),
    );
  }
}
