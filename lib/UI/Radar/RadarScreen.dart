import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SelectWhomToSentScreen.dart';
import 'TempReceivedCards.dart';

void _launchURL(String _url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

class RadarScreen extends StatefulWidget {
  @override
  _RadarScreenState createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;
  Color _currentColor = Color(COLOR_PRIMARY);

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

  bool _enabled = true;

  Future GetDistinctSharedCards() {
    Provider.of<CustomViewModel>(context, listen: false)
        .GetDistinctSharedCards()
        .then((value) {
      setState(() {
        setState(() {
          _enabled = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetDistinctSharedCards();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: AppBar(
          backgroundColor: Color(COLOR_PRIMARY),
          title: commonTitleSmallWhite(context, "Share"),
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
        ),
        body: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Text(
                        "All receivers should activate Radar by tapping on receive option first.",
                        style: GoogleFonts.montserrat(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Color(COLOR_PRIMARY))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      getLocation(2);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0, color: Color(COLOR_PURPLE_PRIMARY)),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  5.0) ////              <--- border radius here
                              ),
                          color: Color(COLOR_PURPLE_PRIMARY).withOpacity(0.1)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: AssetImage('assets/rec2.png'),
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: 15),
                          commonTitleSmallBold(
                              context, "Receive using the Radar"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  providerListener.memberShip == null
                      ? Container()
                      : InkWell(
                          onTap: () {
                            if (providerListener.vcardData != null) {
                              if (providerListener.vcardData.title != null) {
                                getLocation(1);
                              } else {
                                commonToast(context, "Please create FliQCard");
                              }
                            } else {
                              commonToast(context, "Please create FliQCard");
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: Color(COLOR_PURPLE_PRIMARY),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 17, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.send_sharp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 15),
                                commonTitleSmallBoldWhite(
                                    context, "Send using the Radar"),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 10, bottom: 10),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.2,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5, top: 10, bottom: 20),
                    child: commonTitle(context, "Recently received card"),
                  ),
                  providerListener.sharedcardsList.length > 0
                      ? ListView.builder(
                          itemCount:
                              providerListener.sharedcardsList.length > 10
                                  ? 10
                                  : providerListener.sharedcardsList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 0,
                              color: Color(COLOR_BACKGROUND),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          width: 65.0,
                                          height: 65.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: (providerListener
                                                                  .sharedcardsList[
                                                                      index]
                                                                  .userId ??
                                                              "0")
                                                          .toString() ==
                                                      "0"
                                                  ? AssetImage(
                                                      "assets/profile.png")
                                                  : (providerListener
                                                                      .sharedcardsList[
                                                                          index]
                                                                      .profileImagePath ??
                                                                  "")
                                                              .toString() ==
                                                          ""
                                                      ? AssetImage(
                                                          "assets/profile.png")
                                                      : NetworkImage(apiUrl +
                                                              "../../" +
                                                              providerListener
                                                                  .sharedcardsList[
                                                                      index]
                                                                  .profileImagePath ??
                                                          ""),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            border: Border.all(
                                              color: Color(COLOR_SECONDARY),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: (providerListener
                                                            .sharedcardsList[
                                                                index]
                                                            .userId ??
                                                        "0")
                                                    .toString() ==
                                                "0"
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  _launchURL(apiUrl +
                                                      "/../visitcard.php?id=" +
                                                      providerListener
                                                          .sharedcardsList[
                                                              index]
                                                          .myId);
                                                },
                                                child: Card(
                                                    shape: CircleBorder(),
                                                    color: Colors.white,
                                                    elevation: 7,
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Image.asset(
                                                            'assets/logo.png',
                                                            width: 22),
                                                      ),
                                                    )),
                                              ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: SizeConfig.screenWidth - 120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ListTile(
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  providerListener
                                                          .sharedcardsList[
                                                              index]
                                                          .name ??
                                                      "",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Color(COLOR_TITLE))),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                providerListener
                                                        .sharedcardsList[index]
                                                        .email ??
                                                    "",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(COLOR_PRIMARY),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .call_received_rounded,
                                                        color: Color(
                                                            COLOR_PRIMARY),
                                                        size: 14,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "Received Fliq",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color(
                                                              COLOR_PRIMARY),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        _launchURL(apiUrl +
                                                            "/../visitcard.php?id=" +
                                                            providerListener
                                                                .sharedcardsList[
                                                                    index]
                                                                .myId);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "View ",
                                                            style: GoogleFonts.montserrat(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    COLOR_PRIMARY),
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline),
                                                          ),
                                                          Text(
                                                            "FliQCard",
                                                            style: GoogleFonts.montserrat(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .yellow
                                                                    .shade800,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline),
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                      : Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Center(
                              child: commonTitleSmall(
                                  context, "No results Found!"))),
                ],
              )),
        ),
      ),
    );
  }
}
