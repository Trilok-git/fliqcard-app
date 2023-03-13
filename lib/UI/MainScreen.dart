import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fliqcard/AccountBlocked.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/Models/AppVersionParser.dart';
import 'package:fliqcard/Models/VcardParser.dart';
import 'package:fliqcard/UI/Auth/WelcomeScreen.dart';
import 'package:fliqcard/UI/CardListing.dart';
import 'package:fliqcard/UI/Contacts/ContactsScreenNew.dart';
import 'package:fliqcard/UI/PreviewCardScreen.dart';
import 'package:fliqcard/UI/Pricing/PricingScreen.dart';
import 'package:fliqcard/UI/Profile/Profile.dart';
import 'package:fliqcard/UI/Staff/StaffListScreen.dart';
import 'package:fliqcard/UI/Themes/fourthThemeScreen.dart';
import 'package:fliqcard/UI/VirtualBackgrounds.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Appointment/ListOfAppointment.dart';
import 'Appointment/MyCalendarScreen.dart';
import 'Auth/VerifiedEmailScreen.dart';
import 'Dashboard/bar_chart_graph.dart';
import 'Dashboard/donut_chart_graph.dart';
import 'Events/InvitesList.dart';
import 'Events/ListOfEvents.dart';
import 'Follow/ListOfFollow.dart';
import 'NetworkMapView.dart';
import 'NetworkMapViewFullScreen.dart';
import 'NoFliqcrad.dart';
import 'Notifications/NotificationsInit.dart';
import 'Notifications/showAwesomeNotifications.dart';
import 'Radar/ShareScreen.dart';
import 'ScanQR/PaperScan.dart';
import 'ScanQR/ScanQRCode.dart';
import 'Staff/TeamListScreen.dart';
import 'Themes/AddEditCard.dart';
import 'Themes/Ecom/Products/AllOrdersListScreen.dart';
import 'Themes/Ecom/Service/AllInterestSListScreen.dart';
import 'Themes/ThemeSelector.dart';
import 'Themes/fifthThemeScreen.dart';
import 'Themes/firstThemeScreen.dart';
import 'Themes/secondThemeScreen.dart';
import 'Themes/thirdThemeScreen.dart';

enum Availability { loading, available, unavailable }

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  showAwesomeNotifications(message);
}

BuildContext parentContext;

var bytes;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Color tempColor = Color(0xff443a49);
  Color bgColor = Color(0xff443a49);
  Color cardColor = Color(0xff443a49);
  Color fontColor = Color(0xff443a49);

  TextEditingController commentController = TextEditingController();

  bool _isloaded = false;
  PackageInfo packageInfo;
  String app_build = "";
  String app_version = "";

  GlobalKey key1;
  GlobalKey key2;
  Uint8List bytes1;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _setTargetPlatformForDesktop() {
    TargetPlatform targetPlatform;
    if (Platform.isMacOS) {
      targetPlatform = TargetPlatform.iOS;
    } else if (Platform.isLinux || Platform.isWindows) {
      targetPlatform = TargetPlatform.android;
    }
    if (targetPlatform != null) {
      debugDefaultTargetPlatformOverride = targetPlatform;
    }
  }

  Future initTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _setTargetPlatformForDesktop();

    return Provider.of<CustomViewModel>(context, listen: false)
        .getLatestContacts()
        .then((value) {});
  }

  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        commonToast(context, "To add Attendance location is required!");
      } else {}
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        _showDiaog(context);
        //updateLocation();
      } else {
        commonToast(context, "To add Attendance location is required!");
      }
    } else if (_permissionGranted == PermissionStatus.granted) {
      _showDiaog(context);
      // updateLocation();
    }
  }

  Future updateLocation() async {
    _locationData = await location.getLocation();
    print(_locationData);
    EasyLoading.show(status: 'loading...');

    Provider.of<CustomViewModel>(context, listen: false)
        .UpdateAttendance(_locationData.latitude.toString(),
            _locationData.longitude.toString(), commentController.text ?? "")
        .then((value) {
      EasyLoading.dismiss();
      commonToast(context, "Attendance updated!");
    });
  }

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future checkVersion() async {
    packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _isloaded = false;
      app_build = packageInfo.buildNumber;
      app_version = packageInfo.version;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .getAppVersion()
        .then((value) {
      setState(() {
        if (value == "success") {
          Provider.of<CustomViewModel>(context, listen: false)
              .getappVersionParser()
              .then((value) {
            AppVersionParser appVersionParser = value;
            if (Platform.isAndroid) {
              if (int.parse(app_build) >=
                  int.parse(appVersionParser.androidVersion)) {
                getData();
              } else {
                showForceAlertDialog(context, appVersionParser.playstore ?? "");
              }
            } else {
              if (int.parse(app_build) >=
                  int.parse(appVersionParser.iosVersion)) {
                getData();
              } else {
                showForceAlertDialog(context, appVersionParser.appstore ?? "");
              }
            }
          });
        } else {
          commonToast(context, value);
        }
      });
    });
  }

  NotificatiosnInit() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    awesome_notification_init();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showAwesomeNotifications(message);
    });

    try {
      /*AwesomeNotifications().actionStream.listen((receivedNotification) {
        print("clicked");
      });*/
    } catch (e) {
      print("action stream exception");
    }

    try {
      var fcmtokentemp = await FirebaseMessaging.instance.getToken();
      setState(() {
        fcmtoken = fcmtokentemp;
      });
    } catch (e) {
      print("firebase default issues");
    }

    print("fcmtoken");
    print(fcmtoken);

    Provider.of<CustomViewModel>(context, listen: false)
        .UpdateFcmToken(fcmtoken);
  }

  widgetupdate(vcdata) async {
    print(jsonEncode(vcdata));
    await HomeWidget.saveWidgetData<String>('_vcardata', jsonEncode(vcdata));
    await HomeWidget.saveWidgetData<int>('_isActivated', 1);
    await HomeWidget.updateWidget(
        name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
    // commonToast(context, "Widget Activated");
  }

  Future getData() async {
    setState(() {
      _isloaded = false;
    });
    Provider.of<CustomViewModel>(context, listen: false)
        .getData()
        .then((value) async {
      if (value == "success") {
        if (Provider.of<CustomViewModel>(context, listen: false)
                .userData
                .status ==
            "0") {
          pushReplacement(context, VerifiedEmailScreen());
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Future.delayed(const Duration(milliseconds: 100), () async {
            bool introFinished = prefs.getBool("introFinished") ?? false;
            if (introFinished == false) {
              showDialog(
                  context: context,
                  builder: (BuildContext contextDialog) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      //this right here
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(COLOR_PRIMARY),
                                      Color(COLOR_PRIMARY),
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text("Hi, Welcome!",
                                          textScaleFactor: 1,
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  letterSpacing: 1,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      Color(COLOR_SECONDARY)))),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                        "Let's have a walk through\nof the app.",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                letterSpacing: 1,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_PRIMARY)))),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      pop(contextDialog);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text("No, Thanks",
                                          textScaleFactor: 1,
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  letterSpacing: 1,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      Color(COLOR_PRIMARY)))),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pop(contextDialog);

                                      ShowCaseWidget.of(context)
                                          .startShowCase(listOfGlobalKeys);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text("START",
                                          textScaleFactor: 1,
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  letterSpacing: 1,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      Color(COLOR_PRIMARY)))),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          });
          NotificatiosnInit();

          setState(() {
            _isloaded = true;

            Provider.of<CustomViewModel>(context, listen: false).getInvites();

            //vcard update widget
            var vcdata =
                Provider.of<CustomViewModel>(context, listen: false).vcardData;
            if (Platform.isAndroid) {
              widgetupdate(vcdata);
            }

            // print(jsonEncode(vcdata));

            Provider.of<CustomViewModel>(context, listen: false)
                .getFollowup("pending");
          });
        }
      } else {
        commonToast(context, value);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkVersion();
    initTask();
  }

  void showForceAlertDialog(BuildContext context, String url) {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: new Text("Update Required!"),
              content: new Text(
                  "Upgrade to the new improved version of FliQCard app."),
              actions: [
                CupertinoButton(
                  child: Text('Update'),
                  onPressed: () {
                    _launchURL(url ?? "");
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final providerListener = Provider.of<CustomViewModel>(context);

    setState(() {
      parentContext = context;
    });

    return _isloaded == true
        ? providerListener.userData != null
            ? providerListener.userData.is_block == "0"
                ? (providerListener.userData.isStaff ?? "") != "1"
                    ? asdf()
                    : providerListener.memberShip == null
                        ? buildAccountBlockedWidget(context)
                        : asdf()
                : buildAccountBlockedWidget(context)
            : SizedBox(
                height: 1,
              )
        : Container(
            height: SizeConfig.screenHeight,
            color: Colors.white,
            child: Center(
              child: new CircularProgressIndicator(
                strokeWidth: 1,
                backgroundColor: Color(COLOR_PRIMARY),
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(COLOR_BACKGROUND)),
              ),
            ),
          );
  }

  Widget asdf() {
    final providerListener = Provider.of<CustomViewModel>(context);

    return /* AdvancedDrawer(
      backdropColor: Color(COLOR_SECONDARY),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: */
        Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(COLOR_BACKGROUND),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: Container(
          padding: EdgeInsets.only(top: 35),
          color: Color(COLOR_PRIMARY),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  providerListener.memberShip != null
                      ? SizedBox()
                  :GestureDetector(
                    onTap: (){
                      providerListener.ActivatePlan("Trial Month","EXECUTIVE","11111","USD").then((value) {
                        Provider.of<CustomViewModel>(context, listen: false)
                            .getData()
                            .then((value) async {
                          _refreshController.refreshCompleted();
                        });
                      });
                    },
                    child: Container(
                      // height: 30,
                      margin: EdgeInsets.only(left:10),
                      padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xffcebb6e),
                            Color(0xffFCDC5A),
                            Color(0xffFCDC5A),
                            Color(0xffcebb6e),
                          ],
                          stops: [0,0.4,0.8,1]
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/active_plan.png",height: 17),
                          SizedBox(width: 7),
                          Text("Try Now",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      )
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Showcase(
                    key: scanQrGlobal,
                    description: 'Scan QR & Paper Card\n\nNEXT>>',
                    onToolTipClick: () {
                      setState(() {
                        ShowCaseWidget.of(context).next();
                      });
                    },
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(COLOR_PRIMARY),
                                                Color(COLOR_PRIMARY)
                                              ],
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text("Select an option!",
                                                    textScaleFactor: 1,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: TextStyle(
                                                            letterSpacing: 1,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                                    color:
                                                        Color(COLOR_SECONDARY),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            pop(context);
                                            push(parentContext, ScanQRCode());
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Icon(Icons.qr_code),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text("QR Scan",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    COLOR_PRIMARY)))),
                                                    Text("Scan any QR Code",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Color(
                                                                    COLOR_PRIMARY)))),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        InkWell(
                                          onTap: () {
                                            pop(context);
                                            push(parentContext, PaperScan());
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child:
                                                    Icon(Icons.library_books),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text("Paper Scan",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    COLOR_PRIMARY)))),
                                                    Text("Scan any paper card",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                letterSpacing:
                                                                    1,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Color(
                                                                    COLOR_PRIMARY)))),
                                                  ],
                                                ),
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
                          padding: const EdgeInsets.only(right: 20, left: 80),
                          child: Image.asset(
                            "assets/scanner.png",
                            width: 20,
                          )),
                    ),
                  ),
                  Showcase(
                    key: viewCardGlobal,
                    description: 'View Your FliQCard  NEXT>>',
                    onToolTipClick: () {
                      setState(() {
                        ShowCaseWidget.of(context).next();
                      });
                    },
                    child: InkWell(
                      onTap: () {
                        /* _launchURL(
                            "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                (providerListener.userData.id ?? "") +
                                "&preview=1");
*/

                        /* return  showDialog(
                            context: context,
                            builder: (BuildContext contextDialog) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),

                                child: SingleChildScrollView(
                                  child: Container(
                                    height: SizeConfig.screenHeight/1.2,
                                    width: SizeConfig.screenWidth/1.2,
                                    child: WebView(
                                      initialUrl:
                                      "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                          (providerListener.userData.id ?? "") +
                                          "&preview=1",
                                      javascriptMode: JavascriptMode.unrestricted,
                                      onPageStarted: (String url) {
                                          EasyLoading.show();

                                      },
                                      onPageFinished: (String url) {
                                        EasyLoading.dismiss();
                                      },
                                      gestureNavigationEnabled: true,
                                    ),
                                  ),
                                ),

                              );
                            });*/

                        push(context, PreviewCardScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Showcase(
                    key: notificationsGlobal,
                    description: 'Upcoming Events\n\nNEXT>>',
                    onToolTipClick: () {
                      setState(() {
                        ShowCaseWidget.of(context).next();
                      });
                    },
                    child: Stack(
                      children: [
                        providerListener.hide == "yes"
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: IconButton(
                                  onPressed: () {
                                    push(context, InvitesList());
                                  },
                                  icon: Icon(
                                    Icons.notifications_outlined,
                                    size: 25,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                        providerListener.invitesList.length > 0
                            ? Positioned(
                                top: 5,
                                right: 10,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    color: Colors.red,
                                  ),
                                  child: Text(
                                    providerListener.invitesList.length
                                        .toString(),
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 1,
                              ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: () {
            Provider.of<CustomViewModel>(context, listen: false)
                .getData()
                .then((value) async {
              _refreshController.refreshCompleted();
            });
          },
          onLoading: () {},
          child: _getBody(providerListener.bottomIndex, context),
        ),
      ),
      bottomNavigationBar: Showcase(
        key: bottombarGlobal,
        description: 'Dashboard, FliQCard, Contacts, Sharing\n\nNEXT>>',
        onToolTipClick: () {
          setState(() {
            ShowCaseWidget.of(context).next();
          });
        },
        child: Container(
          color: Colors.white,
          height: 65,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        providerListener.bottomIndex = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.dashboard,
                                color: providerListener.bottomIndex == 0
                                    ? Colors.yellow.shade800
                                    : Colors.grey.shade800),
                          ),
                          Text("Dashboard",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: 12.0,
                                      color: providerListener.bottomIndex == 0
                                          ? Colors.yellow.shade800
                                          : Colors.grey.shade800,
                                      fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        providerListener.bottomIndex = 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.contacts_sharp,
                                color: providerListener.bottomIndex == 1
                                    ? Colors.yellow.shade800
                                    : Colors.grey.shade800),
                          ),
                          Text("FliQCard",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: 12.0,
                                      color: providerListener.bottomIndex == 1
                                          ? Colors.yellow.shade800
                                          : Colors.grey.shade800,
                                      fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        providerListener.bottomIndex = 2;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.people,
                                color: providerListener.bottomIndex == 2
                                    ? Colors.yellow.shade800
                                    : Colors.grey.shade800),
                          ),
                          Text("Network",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: 12.0,
                                      color: providerListener.bottomIndex == 2
                                          ? Colors.yellow.shade800
                                          : Colors.grey.shade800,
                                      fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        providerListener.bottomIndex = 3;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.screen_share,
                                color: providerListener.bottomIndex == 3
                                    ? Colors.yellow.shade800
                                    : Colors.grey.shade800),
                          ),
                          Text("Share",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: 12.0,
                                      color: providerListener.bottomIndex == 3
                                          ? Colors.yellow.shade800
                                          : Colors.grey.shade800,
                                      fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        providerListener.bottomIndex = 4;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.more_horiz_sharp,
                                color: providerListener.bottomIndex == 4
                                    ? Colors.yellow.shade800
                                    : Colors.grey.shade800),
                          ),
                          Text("More",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: 12.0,
                                      color: providerListener.bottomIndex == 4
                                          ? Colors.yellow.shade800
                                          : Colors.grey.shade800,
                                      fontWeight: FontWeight.w400))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Container(
            width: SizeConfig.screenWidth * 0.7,
            color: Color(COLOR_PRIMARY),
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Color(0xffE3E8FF),
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    pop(context);
                                    push(context, Profile());
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: providerListener.vcardData !=
                                                null
                                            ? providerListener.vcardData
                                                            .profileImagePath !=
                                                        null &&
                                                    providerListener.vcardData
                                                            .profileImagePath !=
                                                        ""
                                                ? Container(
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
                                                                .profileImagePath),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100.0)),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 70.0,
                                                    height: 70.0,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/profile.png"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100.0)),
                                                    ),
                                                  )
                                            : Container(
                                                width: 70.0,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/profile.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              100.0)),
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
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.edit,
                                              size: 17,
                                              color: Color(COLOR_PRIMARY),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                      (providerListener.userData.fullname ??
                                          ""),
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color(COLOR_TITLE)))),
                                ),
                                providerListener.vcardData == null
                                    ? Container()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                            (providerListener
                                                    .vcardData.subtitle ??
                                                ""),
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Color(COLOR_TITLE)))),
                                      ),
                                providerListener.userData != null
                                    ? (providerListener.userData.is_rep ?? "0")
                                                .toString() ==
                                            "0"
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 1),
                                            child: commonTitleBigBold(
                                                context,
                                                (providerListener
                                                        .userData.rep_code ??
                                                    "")),
                                          )
                                    : Container(),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 12,
                            child: InkWell(
                              onTap: () {
                                pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.clear,
                                  size: 25,
                                  color: Color(COLOR_PRIMARY),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (providerListener.userData != null &&
                            providerListener.memberShip != null) {
                          pop(context);
                          push(context, CardListing());
                        } else {
                          // if (Platform.isAndroid) {
                            push(context, PricingScreen(1));
                          // } else {
                          //   commonToast(context, "Visit fliqcard.com");
                          // }
                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 12),
                          Image.asset(
                            "assets/Fliq_listing_sec1.png",
                            width: 22,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          commonTitleSmallBoldWhite(context, 'FliQ-Listing'),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        pop(context);

                        push(context, VirtualBackgrounds());
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 12),
                          Image.asset(
                            "assets/Fliq_board_sec1.png",
                            width: 22,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          commonTitleSmallBoldWhite(context, 'FliQ-board'),
                        ],
                      ),
                    ),
                    providerListener.hide == "yes"
                        ? Container()
                        : SizedBox(height: 5),
                    Divider(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    providerListener.hide == "yes"
                        ? Container()
                        : providerListener.memberShip == null
                            ? Container()
                            : providerListener.memberShip.plan == "ECOMMERCE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE PLUS"
                                ? InkWell(
                                    onTap: () {
                                      if (providerListener.userData != null &&
                                          providerListener.memberShip != null) {
                                        pop(context);
                                        push(context, AllInterestSListScreen());
                                      } else {
                                        // if (Platform.isAndroid) {
                                          push(context, PricingScreen(1));
                                        // } else {
                                        //   commonToast(
                                        //       context, "Visit fliqcard.com");
                                        // }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: 12),
                                        Image.asset(
                                          "assets/received_interests_sec1.png",
                                          width: 22,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        commonTitleSmallBoldWhite(
                                            context, 'Received Interests'),
                                      ],
                                    ),
                                  )
                                : Container(),
                    providerListener.hide == "yes"
                        ? Container()
                        : SizedBox(height: 5),
                    providerListener.hide == "yes"
                        ? Container()
                        : providerListener.memberShip == null
                            ? Container()
                            : providerListener.memberShip.plan == "ECOMMERCE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE PLUS"
                                ? Divider(
                                    color: Colors.white.withOpacity(0.7),
                                  )
                                : Container(),
                    providerListener.hide == "yes"
                        ? Container()
                        : providerListener.memberShip == null
                            ? Container()
                            : providerListener.memberShip.plan == "ECOMMERCE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE PLUS"
                                ? SizedBox(height: 5)
                                : Container(),
                    providerListener.hide == "yes"
                        ? Container()
                        : providerListener.memberShip == null
                            ? Container()
                            : providerListener.memberShip.plan == "ECOMMERCE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE PLUS"
                                ? InkWell(
                                    onTap: () {
                                      if (providerListener.userData != null &&
                                          providerListener.memberShip != null) {
                                        pop(context);
                                        push(context, AllOrdersListScreen());
                                      } else {
                                        // if (Platform.isAndroid) {
                                          push(context, PricingScreen(1));
                                        // } else {
                                        //   commonToast(
                                        //       context, "Visit fliqcard.com");
                                        // }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: 12),
                                        Image.asset(
                                          "assets/received_orders_sec1.png",
                                          width: 22,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        commonTitleSmallBoldWhite(
                                            context, 'Received Orders'),
                                      ],
                                    ),
                                  )
                                : Container(),
                    providerListener.hide == "yes"
                        ? Container()
                        : SizedBox(height: 5),
                    providerListener.hide == "yes"
                        ? Container()
                        : providerListener.memberShip == null
                            ? Container()
                            : providerListener.memberShip.plan == "ECOMMERCE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE" ||
                                    providerListener.memberShip.plan ==
                                        "CORPORATE PLUS"
                                ? Divider(
                                    color: Colors.white.withOpacity(0.7),
                                  )
                                : Container(),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        if (providerListener.userData != null &&
                            providerListener.memberShip != null) {
                          pop(context);
                          push(context, StaffListScreen());
                        } else {
                          // if (Platform.isAndroid) {
                            push(context, PricingScreen(1));
                          // } else {
                          //   commonToast(context, "Visit fliqcard.com");
                          // }
                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Image.asset(
                            "assets/staff_list_sec1.png",
                            width: 22,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          commonTitleSmallBoldWhite(context, 'Staff List'),
                        ],
                      ),
                    ),
                    providerListener.teamList.isNotEmpty
                        ? Divider(
                            color: Colors.white.withOpacity(0.7),
                          )
                        : SizedBox(
                            height: 1,
                          ),
                    providerListener.teamList.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              if (providerListener.userData != null &&
                                  providerListener.memberShip != null) {
                                pop(context);
                                push(context, TeamListScreen());
                              } else {
                                // if (Platform.isAndroid) {
                                  push(context, PricingScreen(1));
                                // } else {
                                //   commonToast(context, "Visit fliqcard.com");
                                // }
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 15),
                                Image.asset(
                                  "assets/staff_list_sec1.png",
                                  width: 22,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                commonTitleSmallBoldWhite(context, 'Team List'),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 1,
                          ),
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        pop(context);
                        push(context, Profile());
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Image.asset(
                            "assets/settings_icon_sec1.png",
                            width: 22,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          commonTitleSmallBoldWhite(
                              context, 'Account Settings'),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    InkWell(
                      onTap: () {
                        commonLaunchURL(Platform.isIOS
                            ? (providerListener.appVersionParser.appstore ?? "")
                                .toString()
                            : (providerListener.appVersionParser.playstore ??
                                    "")
                                .toString());
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Image.asset(
                            "assets/settings_icon_sec1.png",
                            width: 22,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          commonTitleSmallBoldWhite(context, 'Rate Us'),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('id');
                        pop(context);
                        pop(context);
                        push(context, WelcomeScreen());
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Image.asset(
                            "assets/logout_icon_sec1.png",
                            width: 22,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          commonTitleSmallBoldWhite(context, 'LogOut'),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () {},
                      child: commonTitleSmallBoldWhite(
                          context, "Version: " + (app_version ?? "")),
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    //);
  }

  _getBody(int selectedIndex, ShowCaseContext) {
    final providerListener = Provider.of<CustomViewModel>(context);

    switch (selectedIndex) {
      case 0:
        return providerListener.vcardData != null
            ? providerListener.vcardData.title != null
                ? Container(
                    child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        providerListener.hide == "yes"
                            ? Container()
                            : providerListener.userData.isStaff == "1"
                                ? Container()
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: Showcase(
                                      key: goPremiumGlobal,
                                      description:
                                          'Go Premium To Access Premium themes & features.\n\nNEXT>>',
                                      onToolTipClick: () {
                                        setState(() {
                                          ShowCaseWidget.of(ShowCaseContext)
                                              .next();
                                        });
                                      },
                                      child: InkWell(
                                          onTap: () {
                                            providerListener.userData.isStaff !=
                                                    "1"
                                                ? providerListener.memberShip !=
                                                        null
                                                    ? print("already member")
                                                    :
                                                        // Platform.isAndroid ?
                                                          push(context,
                                                            PricingScreen(1))
                                                        // : commonToast(context,
                                                        //     "Visit fliqcard.com")
                                                : print("staff");
                                          },
                                          child: Card(
                                            color:
                                                providerListener.memberShip !=
                                                        null
                                                    ? Color(COLOR_PRIMARY)
                                                    : Color(COLOR_BACKGROUND),
                                            child: Container(
                                              decoration: providerListener
                                                          .memberShip !=
                                                      null
                                                  ? BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(
                                                              COLOR_PURPLE_PRIMARY),
                                                          Color(COLOR_PRIMARY)
                                                        ],
                                                      ),
                                                    )
                                                  : BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    providerListener
                                                                .memberShip !=
                                                            null
                                                        ? 8.0
                                                        : 1.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    providerListener
                                                                .memberShip !=
                                                            null
                                                        ? providerListener
                                                                        .memberShip
                                                                        .plan ==
                                                                    "EXECUTIVE" ||
                                                                providerListener
                                                                        .memberShip
                                                                        .plan ==
                                                                    "ECOMMERCE" ||
                                                                providerListener
                                                                        .memberShip
                                                                        .plan ==
                                                                    "CORPORATE"
                                                            ? InkWell(
                                                                onTap: () {
                                                                  // if (Platform
                                                                  //     .isAndroid) {
                                                                    push(
                                                                        context,
                                                                        PricingScreen(
                                                                            1));
                                                                  // } else {
                                                                  //
                                                                  //   commonToast(
                                                                  //       context,
                                                                  //       "Visit fliqcard.com");
                                                                  // }
                                                                },
                                                                child: ListTile(
                                                                  leading:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            1.0),
                                                                    child: Image.asset(
                                                                        "assets/active_plan.png",
                                                                        width:
                                                                            80),
                                                                  ),
                                                                  title: Text(
                                                                    "You have " +
                                                                        providerListener
                                                                            .memberShip
                                                                            .plan +
                                                                        " plan, Valid till",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: GoogleFonts.montserrat(
                                                                        letterSpacing:
                                                                            0.7,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  subtitle: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        (providerListener.memberShip.endDate ??
                                                                            ""),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: GoogleFonts.montserrat(
                                                                            letterSpacing:
                                                                                0.7,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 12),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5.0),
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/upgrade_plan.png",
                                                                          height:
                                                                              22,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : ListTile(
                                                                leading:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          1.0),
                                                                  child: Image.asset(
                                                                      "assets/active_plan.png",
                                                                      width:
                                                                          80),
                                                                ),
                                                                title: Text(
                                                                    providerListener
                                                                            .memberShip
                                                                            .plan +
                                                                        " plan",
                                                                    style: GoogleFonts.montserrat(
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            1,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Colors
                                                                            .white)),
                                                                subtitle: Text(
                                                                  "Valid till " +
                                                                      providerListener
                                                                          .memberShip
                                                                          .endDate,
                                                                  style: GoogleFonts.montserrat(
                                                                      letterSpacing:
                                                                          0.5,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Image.asset(
                                                                Platform.isAndroid
                                                                    ? "assets/premium_android.png"
                                                                    : "assets/premium_ios.png",
                                                                width: SizeConfig
                                                                    .screenWidth),
                                                          ), /*ListTile(
                                                            leading: Icon(
                                                                FlutterIcons
                                                                    .crown_faw5s,
                                                                color:
                                                                    Colors.black),
                                                            title: Text(
                                                                "Go premium",
                                                               style: GoogleFonts.montserrat(
                                                                    fontSize: 19.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black)),
                                                            subtitle: Text(
                                                              "Go for free trial",
                                                             style: GoogleFonts.montserrat(
                                                                  color:
                                                                      Colors.black,
                                                                  fontSize: 14),
                                                            ),
                                                            trailing: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                color:
                                                                    Colors.black),
                                                          ),*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                if (providerListener.userData != null &&
                                    providerListener.memberShip != null) {
                                  push(
                                      context,
                                      MyCalendarScreen(apiUrl +
                                          "/../invites/mycalendar/?user_id=" +
                                          (providerListener.userData.id.toString())+
                                          "&current_usr_email="+ providerListener.userData.email));
                                  /*_launchURL(apiUrl +
                                        "/../invites/mycalendar/?user_id=" +
                                        (providerListener.userData.id
                                            .toString()));*/
                                } else {
                                  // if (Platform.isAndroid) {
                                    push(context, PricingScreen(1));
                                  // } else {
                                  //   push(context, PricingScreen(1));
                                  //   print("iosssssss");
                                  //   commonToast(context, "Visit fliqcard.com");
                                  // }
                                }
                              },
                              child: Card(
                                elevation: 3,
                                child: Container(
                                  width: SizeConfig.screenWidth / 2 - 20,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xff764D00).withOpacity(0.7),
                                          Color(0xffB67700).withOpacity(0.5),
                                          Color(0xffEC9A00).withOpacity(0.4),
                                          Color(0xffEC9A00).withOpacity(0.3),
                                          Color(0xffEC9A00).withOpacity(0.2),
                                          Color(0xffEC9A00).withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Color(0xffEC9A00),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Center(
                                            child: Image.asset(
                                              "assets/my_calendar_icon.png",
                                              width: 22,
                                              color: Colors.white,
                                            ),
                                            //
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      commonTitleSmallBold(
                                          context, "My Calendar"),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(
                                          children: [
                                            Text(
                                                "Check your scheduled meetings,\n upcoming events here.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        fontSize: 10.0,
                                                        color: Color(
                                                            COLOR_PRIMARY)))),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (providerListener.userData != null &&
                                    providerListener.memberShip != null) {
                                  push(context, ListOfAppointment());
                                } else {
                                  // if (Platform.isAndroid) {
                                    push(context, PricingScreen(1));
                                  // } else {
                                  //   commonToast(context, "Visit fliqcard.com");
                                  // }
                                }
                              },
                              child: Card(
                                elevation: 3,
                                child: Container(
                                  width: SizeConfig.screenWidth / 2 - 20,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xff764D00).withOpacity(0.7),
                                          Color(0xffB67700).withOpacity(0.5),
                                          Color(0xffEC9A00).withOpacity(0.4),
                                          Color(0xffEC9A00).withOpacity(0.3),
                                          Color(0xffEC9A00).withOpacity(0.2),
                                          Color(0xffEC9A00).withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Color(0xffEC9A00),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: Center(
                                            child: Image.asset(
                                              "assets/calendar.png",
                                              width: 27,
                                              color: Colors.white,
                                            ),
                                            //
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      commonTitleSmallBold(
                                          context, "Add Appointment"),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(
                                          children: [
                                            Text(
                                                "scheduling meetings \nprofessionally and efficiently.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        fontSize: 10.0,
                                                        color: Color(
                                                            COLOR_PRIMARY)))),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                if (providerListener.userData != null &&
                                    providerListener.memberShip != null) {
                                  push(context, ListOfEvents());
                                } else {
                                  // if (Platform.isAndroid) {
                                    push(context, PricingScreen(1));
                                  // } else {
                                  //   commonToast(context, "Visit fliqcard.com");
                                  // }
                                }
                              },
                              child: Card(
                                elevation: 3,
                                child: Container(
                                  width: SizeConfig.screenWidth / 2 - 20,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xff764D00).withOpacity(0.7),
                                          Color(0xffB67700).withOpacity(0.5),
                                          Color(0xffEC9A00).withOpacity(0.4),
                                          Color(0xffEC9A00).withOpacity(0.3),
                                          Color(0xffEC9A00).withOpacity(0.2),
                                          Color(0xffEC9A00).withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Color(0xffEC9A00),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Center(
                                            child: Image.asset(
                                              "assets/events_icon_sec1.png",
                                              width: 27,
                                              color: Colors.white,
                                            ),
                                            //
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      commonTitleSmallBold(context, "Events"),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(
                                          children: [
                                            Text(
                                                "Efficiently host event and share venue, link and more",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        fontSize: 10.0,
                                                        color: Color(
                                                            COLOR_PRIMARY)))),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Showcase(
                              key: addAttendanceGlobal,
                              description:
                                  'Add and View Attendance Of staffs.\n\nNEXT>>',
                              onToolTipClick: () {
                                setState(() {
                                  ShowCaseWidget.of(ShowCaseContext).next();
                                });
                              },
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    commentController.clear();
                                  });
                                  getLocation();
                                },
                                child: Card(
                                  elevation: 3,
                                  child: Container(
                                    width: SizeConfig.screenWidth / 2 - 20,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xff764D00).withOpacity(0.7),
                                            Color(0xffB67700).withOpacity(0.5),
                                            Color(0xffEC9A00).withOpacity(0.4),
                                            Color(0xffEC9A00).withOpacity(0.3),
                                            Color(0xffEC9A00).withOpacity(0.2),
                                            Color(0xffEC9A00).withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Color(0xffEC9A00),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Center(
                                              child: Image.asset(
                                                "assets/attendance_icon.png",
                                                width: 20,
                                              ),
                                              //
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        commonTitleSmallBold(
                                            context, "Add Attendance"),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                  "Check your attendance status,\n"
                                                  "add and modify your attendance.",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: TextStyle(
                                                          fontSize: 10.0,
                                                          color: Color(
                                                              COLOR_PRIMARY)))),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            var now = new DateTime.now();
                                            var formatter =
                                                new DateFormat('yyyy-MM-dd');
                                            String formattedDate =
                                                formatter.format(now);

                                            _launchURL((apiUrl +
                                                "/../attendance.php?start_at=" +
                                                formattedDate +
                                                "&end_at=" +
                                                formattedDate +
                                                "&user_id=" +
                                                providerListener.userData.id +
                                                "&staff_name=" +
                                                (providerListener
                                                        .userData.fullname ??
                                                    "") +
                                                "&isfromapp=yes"));
                                          },
                                          child: Text("View Attendance ->",
                                              style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.blueAccent))),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Image.asset(
                                    "assets/analytics_icon.png",
                                    width: 22,
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: (Text("Analytics",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      Color(COLOR_PRIMARY)))))),
                                ]),
                                providerListener.memberShip == null
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          push(context,
                                              NetworkMapViewFullScreen());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "View Fullscreen",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              height: 35,
                                              width: 35,
                                              color: Color(COLOR_PRIMARY),
                                              child: Icon(
                                                Icons.fullscreen_outlined,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ]),
                        ),
                        providerListener.memberShip == null
                            ? Container()
                            : SizedBox(height: 7),
                        providerListener.memberShip == null
                            ? Container()
                            : NetworkMapView(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 20),
                            child: (Text("Circle of Network",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(COLOR_PRIMARY)))))),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: DonutPieChart(),
                        ),

                        /* Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: LineChartSample()),*/


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButton(
                                value: providerListener.selectedYear,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                iconSize: 20,
                                style: const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (value) {
                                  providerListener.selectedYear = value;
                                  Provider.of<CustomViewModel>(context, listen: false)
                                      .getData(value);
                                },
                                items: providerListener.ListOfYears.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),


                              ),
                            ],
                          ),
                        ),


                        Column(
                          children: [
                            providerListener.dataList.length > 0
                                ? BarChartGraph(
                                    data: providerListener.dataList,
                                  )
                                : Container(),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Card(
                                  elevation: 3,
                                  child: Container(
                                    width: SizeConfig.screenWidth / 2 - 20,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xff764D00).withOpacity(0.7),
                                            Color(0xffB67700).withOpacity(0.5),
                                            Color(0xffEC9A00).withOpacity(0.4),
                                            Color(0xffEC9A00).withOpacity(0.3),
                                            Color(0xffEC9A00).withOpacity(0.2),
                                            Color(0xffEC9A00).withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Color(0xffEC9A00),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Center(
                                              child: Text(
                                                providerListener.TotalVisits
                                                    .toString(),
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        commonTitleSmall(
                                            context, "Total Visits"),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                  "No. of people viewed your FliQCard",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Color(
                                                              COLOR_SUBTITLE)))),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 3,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        providerListener.bottomIndex = 2;
                                      });
                                    },
                                    child: Container(
                                      width: SizeConfig.screenWidth / 2 - 20,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xff764D00)
                                                  .withOpacity(0.7),
                                              Color(0xffB67700)
                                                  .withOpacity(0.5),
                                              Color(0xffEC9A00)
                                                  .withOpacity(0.4),
                                              Color(0xffEC9A00)
                                                  .withOpacity(0.3),
                                              Color(0xffEC9A00)
                                                  .withOpacity(0.2),
                                              Color(0xffEC9A00)
                                                  .withOpacity(0.1),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Color(0xffEC9A00),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Center(
                                                child: Text(
                                                  providerListener.TotalSaved
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          commonTitleSmall(
                                              context, "Total Saved"),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                    "No. of people saved your FliQCard in address book",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Color(
                                                                COLOR_SUBTITLE)))),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 45),
                            providerListener.userData.isStaff != "1"
                                ? providerListener.memberShip != null
                                    ? providerListener.memberShip.plan ==
                                            "CORPORATE PLUS"
                                        ? Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: [
                                                commonTitleSmall(context,
                                                    "Centralized Content"),
                                                SizedBox(height: 20),
                                                Text(
                                                    "(This feature allows you to force staffs to use logo, banner, theme, address, website, company, social links set by you.)",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Color(
                                                                COLOR_SUBTITLE)))),
                                                SizedBox(height: 20),
                                                Column(
                                                  children: [
                                                    AnimatedRadioButtons(
                                                      value: int.parse(
                                                          providerListener
                                                                  .vcardData
                                                                  .centralized_on ??
                                                              "0"),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      layoutAxis:
                                                          Axis.horizontal,
                                                      buttonRadius: 25.0,
                                                      items: [
                                                        AnimatedRadioButtonItem(
                                                            label: "Unlock",
                                                            color: Color(
                                                                COLOR_PRIMARY),
                                                            fillInColor: Color(
                                                                COLOR_SECONDARY)),
                                                        AnimatedRadioButtonItem(
                                                            label: "Lock",
                                                            color: Color(
                                                                COLOR_PRIMARY),
                                                            fillInColor:
                                                                Colors.white70),
                                                      ],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          providerListener
                                                                  .vcardData
                                                                  .centralized_on =
                                                              value.toString();
                                                          Provider.of<CustomViewModel>(
                                                                  context,
                                                                  listen: false)
                                                              .centralizedToggle(
                                                                  value
                                                                      .toString());
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container()
                                    : Container()
                                : Container(),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(height: 20),
                        providerListener.todaysfollowupList.length > 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Today's Follow Up",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(COLOR_PRIMARY))),
                              )
                            : Container(),
                        SizedBox(height: 7),
                        providerListener.todaysfollowupList.length > 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: providerListener
                                          .todaysfollowupList.length *
                                      80.0,
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: providerListener
                                          .todaysfollowupList.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return InkWell(
                                          onTap: () {
                                            // push(context,  BarChartDemo());
                                            push(context, ListOfFollow());
                                          },
                                          child: Card(
                                            elevation: 1,
                                            color: Color(COLOR_PURPLE_PRIMARY),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person_pin,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                          width: SizeConfig
                                                                  .screenWidth /
                                                              1.5,
                                                          child: commonTitleSmallWhite(
                                                              context,
                                                              providerListener
                                                                      .todaysfollowupList[
                                                                          i]
                                                                      .name ??
                                                                  "")),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : SizedBox(
                                height: 1,
                              ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ))
                : buildNoFliqcradWidget(context)
            : buildNoFliqcradWidget(context);
        break;
      case 1:
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    providerListener.vcardData != null
                        ? providerListener.vcardData.title != null
                            ? providerListener
                                        .vcardData.centralized_center_on ==
                                    "0"
                                ? Showcase(
                                    key: changeThemeGlobal,
                                    description:
                                        'Change Theme Of FliQCard\n\nNEXT>>',
                                    onToolTipClick: () {
                                      setState(() {
                                        ShowCaseWidget.of(ShowCaseContext)
                                            .next();
                                      });
                                    },
                                    child: InkWell(
                                      onTap: () {
                                        push(context, ThemeSelector());
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth / 2.2,
                                        decoration: BoxDecoration(
                                          color: Color(COLOR_PURPLE_PRIMARY),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              buildImage(
                                                  "assets/theme_icon.png", 18),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Set theme",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  letterSpacing: 0.7,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Showcase(
                                    key: changeThemeGlobal,
                                    description:
                                        'Change Theme Of FliQCard\n\nNEXT>>',
                                    onToolTipClick: () {
                                      setState(() {
                                        ShowCaseWidget.of(ShowCaseContext)
                                            .next();
                                      });
                                    },
                                    child: InkWell(
                                      onTap: () {
                                        commonToast(
                                            context, "Centralized by admin");
                                      },
                                      child: Container(
                                        width: SizeConfig.screenWidth / 2.2,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(7),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              buildImage(
                                                  "assets/theme_icon.png", 18),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Set theme",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  letterSpacing: 0.7,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            : SizedBox(
                                height: 1,
                              )
                        : SizedBox(
                            height: 1,
                          ),
                    Showcase(
                      key: editCardGlobal,
                      description: 'Edit Information Of FliQCard\n\nNEXT>>',
                      onToolTipClick: () {
                        setState(() {
                          ShowCaseWidget.of(ShowCaseContext).next();
                        });
                      },
                      child: InkWell(
                        onTap: () {
                          providerListener.vcardData != null
                              ? push(
                                  context,
                                  AddEditCard(
                                      providerListener.vcardData.slug ?? "",
                                      providerListener.vcardData.title ?? "",
                                      providerListener.vcardData.subtitle ?? "",
                                      providerListener.vcardData.description ??
                                          "",
                                      providerListener.userData.email ?? "",
                                      providerListener.vcardData.company ?? "",
                                      providerListener.vcardData.phone ?? "",
                                      providerListener.vcardData.phone2 ?? "",
                                      providerListener.vcardData.telephone ??
                                          "",
                                      providerListener.vcardData.wtPhone ?? "",
                                      providerListener.vcardData.website ?? "",
                                      providerListener.vcardData.address ?? "",
                                      providerListener.vcardData.addressLink ??
                                          "",
                                      providerListener.vcardData.twitterLink,
                                      providerListener.vcardData.facebookLink ??
                                          "",
                                      providerListener.vcardData.linkedinLink ??
                                          "",
                                      providerListener.vcardData.ytbLink ?? "",
                                      providerListener.vcardData.pinLink ?? "",
                                      providerListener.vcardData.snapchat_link ??
                                          "",
                                      providerListener
                                              .vcardData.telegram_link ??
                                          "",
                                      providerListener.vcardData.skype_link ??
                                          "",
                                      providerListener.vcardData.wechat_link ??
                                          "",
                                      providerListener.vcardData.tiktok_link ??
                                          "",
                                      providerListener
                                              .vcardData.pinterest_link ??
                                          "",
                                      providerListener.vcardData.bgcolor,
                                      providerListener.vcardData.cardcolor,
                                      providerListener.vcardData.fontcolor,
                                      providerListener.vcardData.material ?? "",
                                      providerListener
                                              .vcardData.themeSelected ??
                                          "",
                                      providerListener.vcardData
                                              .centralized_center_on ??
                                          ""))
                              : push(
                                  context,
                                  AddEditCard(
                                      "",
                                      "",
                                      "",
                                      "",
                                      providerListener.userData.email ?? "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "#ffffff",
                                      "#ffffff",
                                      "#000000",
                                      "",
                                      providerListener
                                              .vcardData.themeSelected ??
                                          "",
                                      providerListener.vcardData
                                              .centralized_center_on ??
                                          ""),
                                );
                        },
                        child: Container(
                          width: SizeConfig.screenWidth / 2.2,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0,
                                  color: Color(COLOR_PURPLE_PRIMARY)),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      5.0) ////              <--- border radius here
                                  ),
                              color:
                                  Color(COLOR_PURPLE_PRIMARY).withOpacity(0.1)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  size: 20,
                                  color: Color(COLOR_PURPLE_PRIMARY),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Edit",
                                  style: GoogleFonts.montserrat(
                                    color: Color(COLOR_PURPLE_PRIMARY),
                                    letterSpacing: 0.7,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Showcase(
                key: changeFliqColorsGlobal,
                description: 'Change FliQCard Color\n\nNEXT>>',
                onToolTipClick: () {
                  setState(() {
                    ShowCaseWidget.of(ShowCaseContext).next();
                  });
                },
                child: providerListener.vcardData != null
                    ? providerListener.vcardData.title != null
                        ? providerListener.vcardData.centralized_center_on ==
                                "0"
                            ? providerListener.memberShip != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _bgcolorPicker(context);
                                          },
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(7),
                                              child: Row(
                                                children: [
                                                  buildImage(
                                                      "assets/bgcolor_icon.png",
                                                      18),
                                                  SizedBox(width: 7),
                                                  Text(
                                                    "Background",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _cardcolorPicker(context);
                                          },
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(7),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.color_lens,
                                                    size: 22,
                                                    color: Color(
                                                        COLOR_PURPLE_PRIMARY),
                                                  ),
                                                  SizedBox(width: 7),
                                                  Text(
                                                    "Card Color",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _fontcolorPicker(context);
                                          },
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(7),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/font_icon.png",
                                                    width: 20,
                                                    color: Color(
                                                        COLOR_PURPLE_PRIMARY),
                                                  ),
                                                  SizedBox(width: 7),
                                                  Text(
                                                    "Font Color",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            commonToast(context,
                                                "Go Premium to use custom colors");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.color_lens,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                Text(
                                                  "BackGround",
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            commonToast(context,
                                                "Go Premium to use custom colors");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.color_lens,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                Text(
                                                  "Card",
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            commonToast(context,
                                                "Go Premium to use custom colors");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.color_lens,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                Text(
                                                  "Font",
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        commonToast(
                                            context, "Centralized by admin");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.color_lens,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                "BackGround",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        commonToast(
                                            context, "Centralized by admin");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.color_lens,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                "Card",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        commonToast(
                                            context, "Centralized by admin");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.color_lens,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                "Font",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
              ),
              providerListener.vcardData != null
                  ? providerListener.vcardData.title != null
                      ? _getTheme(
                          providerListener.vcardData != null
                              ? (providerListener.vcardData.themeSelected ??
                                      "0")
                                  .toString()
                              : "0",
                          ShowCaseContext)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  "You can manage FliQCard details using above edit menu.",
                                  style: GoogleFonts.montserrat(
                                      color: Color(COLOR_PRIMARY),
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "You can manage FliQCard details using above edit menu.",
                              style: GoogleFonts.montserrat(
                                  color: Color(COLOR_PRIMARY),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
        break;
      case 2:
        return Container(
          child: ContactsScreenNew(),
        );
        break;
      case 3:
        return Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShareScreen(),
              ],
            ),
          ),
        );
        break;
      case 4:
        return Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        commonLaunchURL(
                            "https://fliqcard.com/digitalcard/Email_Signature.php");
                      },
                      child: Container(
                        width: SizeConfig.screenWidth / 2 - 10,
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          "assets/tab1.png",
                          width: 22,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        commonLaunchURL(
                            "https://fliqcard.com/digitalcard/Fliq_board.php");
                      },
                      child: Container(
                        width: SizeConfig.screenWidth / 2 - 10,
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          "assets/tab2.png",
                          width: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        commonLaunchURL(
                            "https://fliqcard.com/digitalcard/singleblog.php?title=How%20to%20add%20FliQCard%20widget%20on%20Android");
                      },
                      child: Container(
                        width: SizeConfig.screenWidth / 2 - 10,
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          "assets/tab3.png",
                          width: 22,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        commonLaunchURL(
                            "https://fliqcard.com/digitalcard/faq.php");
                      },
                      child: Container(
                        width: SizeConfig.screenWidth / 2 - 10,
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          "assets/tab4.png",
                          width: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        commonLaunchURL(
                            "https://fliqcard.com/digitalcard/Address_book.php");
                      },
                      child: Container(
                        width: SizeConfig.screenWidth / 2 - 10,
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          "assets/tab5.png",
                          width: 22,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        commonLaunchURL(
                            "https://fliqcard.com/digitalcard/Sharing_your_card.php");
                      },
                      child: Container(
                        width: SizeConfig.screenWidth / 2 - 10,
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          "assets/tab6.png",
                          width: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        break;
    }
  }

  _getTheme(String index, ShowCaseContext) {
    final providerListener = Provider.of<CustomViewModel>(context);
    switch (index) {
      case "1":
        return firstThemeScreen(ShowCaseContext);
        break;
      case "2":
        return secondThemeScreen(providerListener.vcardData != null
            ? providerListener.vcardData.title != null
                ? _getBannerLink(providerListener.vcardData)
                : ""
            : "");
        break;
      case "3":
        return thirdThemeScreen();
        break;
      case "4":
        return fourthThemeScreen(providerListener.vcardData != null
            ? providerListener.vcardData.title != null
                ? _getBannerLink(providerListener.vcardData)
                : ""
            : "");
        break;
      case "5":
        return fifthThemeScreen();
        break;
      default:
        return firstThemeScreen(ShowCaseContext);
    }
  }

  String _getBannerLink(VcardParser vcardParser) {
    return vcardParser.bannerImagePath != null
        ? vcardParser.bannerImagePath != "" &&
                vcardParser.bannerImagePath.contains("mp4")
            ? vcardParser.bannerImagePath
            : ""
        : "";
  }

  _showDiaog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)), //this right here
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        gradient: LinearGradient(
                          colors: [
                            Color(COLOR_PRIMARY),
                            Color(COLOR_SECONDARY)
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("Comment",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70))),
                          ),
                          InkWell(
                            onTap: () {
                              pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.clear,
                                color: Color(COLOR_PRIMARY),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Short description about attendance",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: commentController,
                            maxLines: 2,
                            maxLength: 50,
                            decoration: InputDecoration(
                                hintText: 'Comment',
                                hintStyle: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    letterSpacing: 1,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InkWell(
                        onTap: () {
                          updateLocation();
                          pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 45,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(COLOR_PRIMARY),
                                    Color(COLOR_SECONDARY)
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void changeColor(Color color) {
    print(color);
    setState(() => tempColor = color);
  }

  _bgcolorPicker(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Background color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: tempColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(COLOR_SECONDARY),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    textStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                child: Text(
                  'UPDATE',
                  style: GoogleFonts.montserrat(color: Color(COLOR_PRIMARY)),
                ),
                onPressed: () {
                  setState(() {
                    bgColor = tempColor;
                    Provider.of<CustomViewModel>(parentContext, listen: false)
                            .vcardData
                            .bgcolor =
                        bgColor
                            .toString()
                            .replaceAll("Color(0xff", "#")
                            .replaceAll(")", "");
                  });

                  Provider.of<CustomViewModel>(parentContext, listen: false)
                      .UpdateBgcolor(bgColor
                          .toString()
                          .replaceAll("Color(0xff", "#")
                          .replaceAll(")", ""));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _cardcolorPicker(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Card color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: tempColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(COLOR_SECONDARY),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    textStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                child: Text(
                  'UPDATE',
                  style: GoogleFonts.montserrat(color: Color(COLOR_PRIMARY)),
                ),
                onPressed: () {
                  setState(() {
                    cardColor = tempColor;
                    Provider.of<CustomViewModel>(parentContext, listen: false)
                            .vcardData
                            .cardcolor =
                        cardColor
                            .toString()
                            .replaceAll("Color(0xff", "#")
                            .replaceAll(")", "");
                  });

                  Provider.of<CustomViewModel>(parentContext, listen: false)
                      .UpdateCardcolor(cardColor
                          .toString()
                          .replaceAll("Color(0xff", "#")
                          .replaceAll(")", ""));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _fontcolorPicker(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Font color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: tempColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(COLOR_SECONDARY),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    textStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                child: Text(
                  'UPDATE',
                  style: GoogleFonts.montserrat(color: Color(COLOR_PRIMARY)),
                ),
                onPressed: () {
                  setState(() {
                    fontColor = tempColor;
                    Provider.of<CustomViewModel>(parentContext, listen: false)
                            .vcardData
                            .fontcolor =
                        fontColor
                            .toString()
                            .replaceAll("Color(0xff", "#")
                            .replaceAll(")", "");
                  });

                  Provider.of<CustomViewModel>(parentContext, listen: false)
                      .UpdateFontcolor(fontColor
                          .toString()
                          .replaceAll("Color(0xff", "#")
                          .replaceAll(")", ""));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
