import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Staff/AddEditStaff.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(String _url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

class ReceivedCards extends StatefulWidget {
  @override
  _ReceivedCardsState createState() => _ReceivedCardsState();
}

class _ReceivedCardsState extends State<ReceivedCards> {
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              commonTitleSmallWhite(context, "Radar FliQ"),
            ],
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
              : providerListener.sharedcardsList.length > 0
                  ? ListView.builder(
                      itemCount: providerListener.sharedcardsList.length,
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
                              Container(
                                width: 75.0,
                                height: 75.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/profile.png"),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                    color: Color(COLOR_SECONDARY),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              Container(
                                width: SizeConfig.screenWidth - 130,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      .sharedcardsList[index]
                                                      .name ??
                                                  "",
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(COLOR_TITLE))),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.call_received_rounded,
                                                    color: Color(COLOR_PRIMARY),
                                                    size: 14,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Received Fliq",
                                                    style: GoogleFonts.montserrat(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.w400,
                                                      color: Color(COLOR_PRIMARY),
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
                                                                FontWeight.w500,
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
                                                                FontWeight.w800,
                                                            color: Colors
                                                                .yellow.shade800,
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
                      margin: EdgeInsets.only(bottom: 0),
                      child: Center(
                          child: commonTitle(context, "No results Found!"))),
        ),
      ),
    );
  }
}
