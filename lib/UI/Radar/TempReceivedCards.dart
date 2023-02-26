import 'dart:async';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(String _url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

class TempReceivedCards extends StatefulWidget {
  @override
  _TempReceivedCardsState createState() => _TempReceivedCardsState();
}

class _TempReceivedCardsState extends State<TempReceivedCards> {
  bool _enabled = true;

  Timer _timer;
  int _start = 40;

  void startTimer() {
    const oneSec = const Duration(seconds: 10);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        print("startTimer");
        if (_start == 0) {
          setState(() {
            timer.cancel();
            // pop(context);
          });
        } else {
          setState(() {
            _start = _start - 10;
            GetSharedCards();
          });
        }
      },
    );
  }

  Future GetSharedCards() {
    Provider.of<CustomViewModel>(context, listen: false)
        .GetSharedCards()
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
    startTimer();
    GetSharedCards();
  }

  @override
  void dispose() {
    _timer.cancel();
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
          title: commonTitleSmallWhite(context, "Received Cards"),
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
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: _enabled == true
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: _enabled,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          itemCount: 6,
                        ),
                      ),
                    )
                  ],
                )
              : providerListener.tempsharedcardsList.length > 0
                  ? SingleChildScrollView(
                      child: ListView.builder(
                          itemCount:
                              providerListener.tempsharedcardsList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 0,
                              color: Color(COLOR_BACKGROUND),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    minLeadingWidth: 60,
                                    leading: Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: (providerListener
                                                              .tempsharedcardsList[
                                                                  index]
                                                              .userId ??
                                                          "0")
                                                      .toString() ==
                                                  "0"
                                              ? AssetImage("assets/profile.png")
                                              : (providerListener
                                                                  .tempsharedcardsList[
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
                                                              .tempsharedcardsList[
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
                                    title: Row(
                                      children: [
                                        Text(
                                            providerListener
                                                    .tempsharedcardsList[index]
                                                    .name ??
                                                "",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500,
                                                color: Color(COLOR_TITLE))),
                                      ],
                                    ),
                                    subtitle: Text(
                                        providerListener
                                                .tempsharedcardsList[index]
                                                .email ??
                                            "",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(COLOR_PRIMARY))),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Provider.of<CustomViewModel>(context,
                                                  listen: false)
                                              .UpdateStatus(
                                                  2,
                                                  providerListener
                                                      .tempsharedcardsList[
                                                          index]
                                                      .myId)
                                              .then((value) {
                                            setState(() {
                                              Provider.of<CustomViewModel>(
                                                      context,
                                                      listen: false)
                                                  .GetSharedCards()
                                                  .then((value) =>
                                                      _enabled = false);
                                              pop(context);
                                            });
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Color(
                                                          COLOR_PURPLE_PRIMARY)),
                                                  color: Color(
                                                          COLOR_PURPLE_PRIMARY)
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 4),
                                                child: Text("Discard",
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                COLOR_PURPLE_PRIMARY)))))),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _launchURL(apiUrl +
                                              "/../visitcard.php?id=" +
                                              providerListener
                                                  .tempsharedcardsList[index]
                                                  .myId);
                                          Provider.of<CustomViewModel>(context,
                                                  listen: false)
                                              .UpdateStatus(
                                                  1,
                                                  providerListener
                                                      .tempsharedcardsList[
                                                          index]
                                                      .myId)
                                              .then((value) {
                                            setState(() {
                                              Provider.of<CustomViewModel>(
                                                      context,
                                                      listen: false)
                                                  .GetSharedCards()
                                                  .then((value) =>
                                                      _enabled = false);
                                              pop(context);
                                            });
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                      COLOR_PURPLE_PRIMARY),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
                                                child: Text("Accept & View",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white))))),
                                      ),
                                    ],
                                  ),
                                  Divider()
                                ],
                              ),
                            );
                          }),
                    )
                  : Container(
                      margin: EdgeInsets.only(bottom: 0),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: commonTitleSmallBold(context,
                                "Shared FliQCard from Nearby users will be listed here!"),
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            child: Center(
                              child: Image.asset(
                                "assets/animation.gif",
                              ), //Icon(Icons.location_on, size: 70,color: Colors.black, ),
                            ),
                          ),
                          //commonTitle(context, "Receiving..."),
                          SizedBox(
                            height: 1,
                          ),
                          SizedBox(
                            height: 1,
                          )
                        ],
                      ))),
        ),
      ),
    );
  }
}
