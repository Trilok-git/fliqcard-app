import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Staff/AddEditStaff.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../CardListingStaff.dart';

class StaffListScreen extends StatefulWidget {
  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  bool _enabled = true;

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future initTask() {
    Future.delayed(const Duration(seconds: 1), () async {
      setState(() {
        _enabled = false;
      });
    });
  }

  Future DeletStaff(String id) {
    Provider.of<CustomViewModel>(context, listen: false)
        .DeletStaff(id)
        .then((value) {
      setState(() {
        setState(() {
          _enabled = false;
        });
        if (value == "success") {
          commonToast(context, value);
        } else {
          commonToast(context, value);
        }
      });
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: AppBar(
          backgroundColor: Color(COLOR_PRIMARY),
          title: commonTitleSmallWhite(context, "Staff List"),
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
                push(context, AddEditStaff("0", "", "", "", ""));
              },
              child: providerListener.userData.isStaff != "1"
                  ? Row(
                      children: [
                        SizedBox(width: 15),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        commonTitleSmallBoldWhite(context, 'Add Staff'),
                        SizedBox(width: 10),
                      ],
                    )
                  : Container(),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
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
                            padding: const EdgeInsets.only(bottom: 8.0, top: 5),
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
              : providerListener.staffList.length > 0
                  ? ListView.builder(
                      itemCount: providerListener.staffList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 0,
                            color: Color(COLOR_BACKGROUND),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 75.0,
                                      height: 75.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: (providerListener
                                                              .staffList[index]
                                                              .profileImagePath ??
                                                          "")
                                                      .toString() ==
                                                  ""
                                              ? AssetImage("assets/profile.png")
                                              : (providerListener.staffList[index]
                                                                  .profileImagePath ??
                                                              "")
                                                          .toString() ==
                                                      ""
                                                  ? AssetImage(
                                                      "assets/profile.png")
                                                  : NetworkImage(apiUrl +
                                                          "../../" +
                                                          providerListener
                                                              .staffList[index]
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
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      width: SizeConfig.screenWidth / 2.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            providerListener
                                                    .staffList[index].fullname ??
                                                "",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18.0,
                                              letterSpacing: 0.7,
                                              fontWeight: FontWeight.w500,
                                              color: Color(COLOR_PRIMARY),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                              providerListener.staffList[index]
                                                      .department ??
                                                  "",
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 15.0,
                                                  letterSpacing: 0.7,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(COLOR_PRIMARY))),
                                          SizedBox(height: 4),
                                          Text(
                                              providerListener
                                                      .staffList[index].email ??
                                                  "",
                                              style: GoogleFonts.montserrat(
                                                  letterSpacing: 0.5,
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(COLOR_TITLE))),
                                          SizedBox(height: 12),
                                          providerListener.staffList[index]
                                                          .updatedAt !=
                                                      "" &&
                                                  providerListener
                                                          .staffList[index]
                                                          .updatedAt !=
                                                      null
                                              ? DateTime.now()
                                                          .difference(
                                                              DateTime.parse(
                                                                  providerListener
                                                                      .staffList[
                                                                          index]
                                                                      .updatedAt))
                                                          .inDays >
                                                      7
                                                  ? Row(
                                                      children: [
                                                        Text("Last update: ",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        11.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .green)),
                                                        SizedBox(height: 2),
                                                        Text(
                                                            providerListener
                                                                    .staffList[
                                                                        index]
                                                                    .updatedAt ??
                                                                "",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        11.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color(
                                                                        COLOR_TITLE))),
                                                      ],
                                                    )
                                                  : Container()
                                              : Container(),
                                          SizedBox(
                                            height: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            providerListener.userData.isStaff ==
                                                    "0"
                                                ? InkWell(
                                                    onTap: () {
                                                      push(
                                                          context,
                                                          AddEditStaff(
                                                              providerListener
                                                                  .staffList[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              providerListener
                                                                  .staffList[
                                                                      index]
                                                                  .fullname
                                                                  .toString(),
                                                              providerListener
                                                                      .staffList[
                                                                          index]
                                                                      .department ??
                                                                  "",
                                                              providerListener
                                                                      .staffList[
                                                                          index]
                                                                      .phone ??
                                                                  "",
                                                              providerListener
                                                                      .staffList[
                                                                          index]
                                                                      .email ??
                                                                  ""));
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(7),
                                                      child: Icon(
                                                        Icons.edit_outlined,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 1,
                                                  ),
                                            providerListener.userData.isStaff ==
                                                    "0"
                                                ? InkWell(
                                                    onTap: () {

                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: const Text('Are you sure?'),
                                                              actions: <Widget>[
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      primary: Colors.white,
                                                                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 2),
                                                                      textStyle:
                                                                      TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                                                                  child: Text(
                                                                    'No',
                                                                    style: GoogleFonts.montserrat(color: Color(COLOR_PRIMARY)),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();


                                                                  },
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      primary: Colors.white,
                                                                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 2),
                                                                      textStyle:
                                                                      TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                                                                  child: Text(
                                                                    'Yes',
                                                                    style: GoogleFonts.montserrat(color: Color(COLOR_PRIMARY)),
                                                                  ),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      _enabled = true;
                                                                    });


                                                                    DeletStaff(providerListener
                                                                        .staffList[index].id);

                                                                    Navigator.of(context).pop();



                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });


                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(7),
                                                      child: Icon(
                                                        Icons.delete_outline,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 1,
                                                  ),
                                            InkWell(
                                              onTap: () {
                                                push(
                                                    context,
                                                    CardListingStaff(
                                                        providerListener
                                                            .staffList[index]
                                                            .id));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(7),
                                                child: Icon(
                                                  Icons.credit_card_sharp,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Share.share((providerListener
                                                            .staffList[index]
                                                            .fullname ??
                                                        "") +
                                                    "\n" +
                                                    (providerListener
                                                            .staffList[index]
                                                            .department ??
                                                        "") +
                                                    "\n\n" +
                                                    ("https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                                        providerListener
                                                            .staffList[index]
                                                            .id));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(7),
                                                child: Icon(
                                                  Icons.share,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _launchURL(
                                                    "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                                        (providerListener
                                                                .staffList[index]
                                                                .id ??
                                                            ""));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(7),
                                                child: Icon(
                                                  Icons.remove_red_eye_outlined,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            providerListener.userData.isStaff ==
                                                    "0"
                                                ? InkWell(
                                                    onTap: () {
                                                      var now =
                                                          new DateTime.now();
                                                      var formatter =
                                                          new DateFormat(
                                                              'yyyy-MM-dd');
                                                      String formattedDate =
                                                          formatter.format(now);

                                                      _launchURL((apiUrl +
                                                          "/../attendance.php?start_at=" +
                                                          formattedDate +
                                                          "&end_at=" +
                                                          formattedDate +
                                                          "&user_id=" +
                                                          (providerListener
                                                                  .staffList[
                                                                      index]
                                                                  .id ??
                                                              "") +
                                                          "&staff_name=" +
                                                          (providerListener
                                                                  .staffList[
                                                                      index]
                                                                  .fullname ??
                                                              "") +
                                                          "&isfromapp=yes"));
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(7),
                                                      child: Icon(
                                                        Icons.calendar_today,
                                                        color:
                                                            Color(COLOR_PRIMARY),
                                                        size: 20,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 1,
                                                  ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 90),
                                  child: Divider(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ) /*Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                    providerListener.staffList[index].fullname ??
                                        "",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(COLOR_TITLE))),
                                subtitle: Text(
                                    (providerListener.staffList[index].email ??
                                            "") +
                                        "\n" +
                                        (providerListener
                                                .staffList[index].department ??
                                            "")),
                                trailing: providerListener
                                                .staffList[index].updatedAt !=
                                            "" &&
                                        providerListener
                                                .staffList[index].updatedAt !=
                                            null
                                    ? DateTime.now()
                                                .difference(DateTime.parse(
                                                    providerListener
                                                        .staffList[index]
                                                        .updatedAt))
                                                .inDays <
                                            7
                                        ? Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: Colors.red,
                                            ),
                                            child: Text(
                                              providerListener
                                                  .staffList[index].updatedAt,
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                          )
                                        : Text("")
                                    : Text(""),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  providerListener.userData.isStaff == "0"
                                      ? InkWell(
                                          onTap: () {
                                            push(
                                                context,
                                                AddEditStaff(
                                                    providerListener
                                                        .staffList[index].id
                                                        .toString(),
                                                    providerListener
                                                        .staffList[index].fullname
                                                        .toString(),
                                                    providerListener
                                                            .staffList[index]
                                                            .department ??
                                                        "",
                                                    providerListener
                                                            .staffList[index]
                                                            .phone ??
                                                        "",
                                                    providerListener
                                                            .staffList[index]
                                                            .email ??
                                                        ""));
                                          },
                                          child: Padding(
                                              padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.edit_outlined,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 1,
                                        ),
                                  providerListener.userData.isStaff == "0"
                                      ? InkWell(
                                          onTap: () {
                                            setState(() {
                                              _enabled = true;
                                            });
                                            DeletStaff(providerListener
                                                .staffList[index].id);
                                          },
                                          child: Padding(
                                              padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.delete_outline,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 1,
                                        ),
                                  InkWell(
                                    onTap: () {
                                      _launchURL(
                                          "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                                              (providerListener
                                                      .staffList[index].id ??
                                                  ""));
                                    },
                                    child: Padding(
                                              padding: EdgeInsets.all(7),
                                      child: Icon(
                                        Icons.remove_red_eye_outlined,
                                      ),
                                    ),
                                  ),
                                  providerListener.userData.isStaff == "0"
                                      ? InkWell(
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
                                                (providerListener
                                                    .staffList[index].id ??
                                                    "") +
                                                "&staff_name=" +
                                                (providerListener
                                                    .staffList[index].fullname ??
                                                    "") +
                                                "&isfromapp=yes"));

                                          },
                                          child: Padding(
                                              padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.calendar_today,
                                              color: Color(COLOR_PRIMARY),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 1,
                                        ),

                                  InkWell(
                                    onTap: () {
                                      push(
                                          context,
                                          CardListingStaff(providerListener
                                              .staffList[index].id));
                                    },
                                    child: Padding(
                                              padding: EdgeInsets.all(7),
                                      child: Icon(
                                        Icons.credit_card_sharp,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),*/
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
