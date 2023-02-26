import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:expandable/expandable.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Contacts/UpdateContactScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AddEditAppoitmentNew.dart';
import 'package:fliqcard/UI/Appointment/SlotsByDate.dart';

import 'ShareAppintment.dart';

BuildContext parentContext;


class ListOfAppointment extends StatefulWidget {
  @override
  _ListOfAppointmentState createState() => _ListOfAppointmentState();
}

class _ListOfAppointmentState extends State<ListOfAppointment> {
  bool _isloaded = false;
  bool _isSearchBarOpen = false;
  TextEditingController searchTextController = new TextEditingController();

  FocusNode focusSearch = FocusNode();

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future getAllappointment() async {
    setState(() {
      _isloaded = false;
    });
    EasyLoading.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .getAllappointment()
        .then((value) {
      EasyLoading.dismiss();
      setState(() {
        if (value == "success") {
          setState(() {
            _isloaded = true;
          });
        } else {
          // commonToast(context, value);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllappointment();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      parentContext = context;
    });
    final providerListener = Provider.of<CustomViewModel>(context);

    return InkWell(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(COLOR_BACKGROUND),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              color: Color(COLOR_PRIMARY),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 20, top: 5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                      commonTitleSmallBoldWhite(context, "Calendar"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        push(
                            context,
                            AddEditAppoitmentNew(null, "One-to-One", "", "", "",
                                "", "", "", 0, "", ""));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(COLOR_PURPLE_PRIMARY),
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: Center(
                              child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              commonTitleSmallWhite(context, "Add One-to-One"),
                            ],
                          )),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        push(
                            context,
                            AddEditAppoitmentNew(null, "Group", "", "", "", "",
                                "", "", 0, "", ""));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, color: Color(COLOR_PURPLE_PRIMARY)),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      5.0) ////              <--- border radius here
                                  ),
                              color:
                                  Color(COLOR_PURPLE_PRIMARY).withOpacity(0.1)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: Center(
                              child: Row(
                            children: [
                              Icon(
                                Icons.group,
                                color: Color(COLOR_PURPLE_PRIMARY),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              commonTitleSmall(context, "Add Group"),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                providerListener.appointmentList.length > 0
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: providerListener.appointmentList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: Colors.white,
                                child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ExpandableNotifier(
                                        // <-- Provides ExpandableController to its children
                                        child: Expandable(
                                          // <-- Driven by ExpandableController from ExpandableNotifier
                                          collapsed: ExpandableButton(
                                            // <-- Expands when tapped on the cover photo
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 20,
                                                      right: 10,
                                                      top: 10,
                                                      bottom: 10),
                                                  child: Container(
                                                      width:
                                                          SizeConfig.screenWidth -
                                                              120,
                                                      child: Text(
                                                          providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .title ??
                                                              "",
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: TextStyle(
                                                                  fontSize: 15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      COLOR_PRIMARY))))),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        Color(COLOR_SECONDARY),
                                                    child: ExpandableButton(
                                                        // <-- Collapses when tapped on
                                                        child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black,
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          expanded: Column(children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 20,
                                                      right: 10,
                                                      bottom: 10,
                                                      top: 10),
                                                  child: Container(
                                                      width:
                                                          SizeConfig.screenWidth -
                                                              120,
                                                      child: Text(
                                                          providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .title ??
                                                              "",
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: TextStyle(
                                                                  fontSize: 15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      COLOR_PRIMARY))))),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        Color(COLOR_PRIMARY),
                                                    child: ExpandableButton(
                                                        // <-- Collapses when tapped on
                                                        child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color: Colors.white,
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          color: Color(
                                                              COLOR_PRIMARY),
                                                          size: 12,
                                                        ),
                                                        SizedBox(
                                                          width: 20.0,
                                                        ),
                                                        commonTitleSmall(
                                                            context,
                                                            providerListener
                                                                    .appointmentList[
                                                                        index]
                                                                    .appointmentType ??
                                                                ""),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  (providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .meetingPlace ??
                                                              "") ==
                                                          ""
                                                      ? Container()
                                                      : InkWell(
                                                          onTap: () {},
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 3),
                                                                child: Icon(
                                                                  Icons.circle,
                                                                  color: Color(
                                                                      COLOR_PRIMARY),
                                                                  size: 12,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 20.0,
                                                              ),
                                                              commonTitleSmall(
                                                                context,
                                                                (providerListener
                                                                        .appointmentList[
                                                                            index]
                                                                        .meetingPlace ??
                                                                    ""),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  (providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .meetingPlace ??
                                                              "") ==
                                                          ""
                                                      ? Container()
                                                      : SizedBox(
                                                          height: 10.0,
                                                        ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 3),
                                                          child: Icon(
                                                            Icons.circle,
                                                            color: Color(
                                                                COLOR_PRIMARY),
                                                            size: 12,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20.0,
                                                        ),
                                                        Column(
                                                          children: [
                                                            commonTitleSmall(
                                                              context,
                                                              (providerListener
                                                                      .appointmentList[
                                                                          index]
                                                                      .confirmAppointmentDate ??
                                                                  ""),
                                                            ),
                                                            (providerListener
                                                                            .appointmentList[
                                                                                index]
                                                                            .confirmAppointmentDate ??
                                                                        "") ==
                                                                    (providerListener
                                                                            .appointmentList[
                                                                                index]
                                                                            .confirmAppointmentEnddate ??
                                                                        "")
                                                                ? Container()
                                                                : Container(
                                                                    height: 40,
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                            (providerListener
                                                                            .appointmentList[
                                                                                index]
                                                                            .confirmAppointmentDate ??
                                                                        "") ==
                                                                    (providerListener
                                                                            .appointmentList[
                                                                                index]
                                                                            .confirmAppointmentEnddate ??
                                                                        "")
                                                                ? Container()
                                                                : commonTitleSmall(
                                                                    context,
                                                                    (providerListener
                                                                            .appointmentList[
                                                                                index]
                                                                            .confirmAppointmentDate ??
                                                                        ""),
                                                                  ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      push(
                                                          context,
                                                          SlotsByDate(
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .appointmentID,
                                                              index));
                                                    },
                                                    child: Icon(
                                                      Icons.timer,
                                                      color: Color(COLOR_PRIMARY),
                                                      size: 25,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  (providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .meetingLink ??
                                                              "") ==
                                                          ""
                                                      ? Container()
                                                      : InkWell(
                                                          onTap: () {
                                                            _launchURL(
                                                                providerListener
                                                                    .appointmentList[
                                                                        index]
                                                                    .meetingLink
                                                                    .toString());
                                                          },
                                                          child: Icon(
                                                            Icons.videocam,
                                                            color: Color(
                                                                COLOR_PRIMARY),
                                                            size: 25,
                                                          ),
                                                        ),
                                                  (providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .meetingLink ??
                                                              "") ==
                                                          ""
                                                      ? Container()
                                                      : SizedBox(
                                                          width: 15,
                                                        ),
                                                  (providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .mapLink ??
                                                              "") ==
                                                          ""
                                                      ? Container()
                                                      : InkWell(
                                                          onTap: () {
                                                            _launchURL(
                                                                providerListener
                                                                    .appointmentList[
                                                                        index]
                                                                    .mapLink
                                                                    .toString());
                                                          },
                                                          child: Icon(
                                                            Icons.location_on,
                                                            color: Color(
                                                                COLOR_PRIMARY),
                                                            size: 25,
                                                          ),
                                                        ),
                                                  (providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .mapLink ??
                                                              "") ==
                                                          ""
                                                      ? Container()
                                                      : SizedBox(
                                                          width: 15,
                                                        ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (providerListener
                                                              .appointmentList[
                                                                  index]
                                                              .appointmentType ==
                                                          "Group") {
                                                        _launchURL(
                                                            "https://fliqcard.com/group.php/" +
                                                                providerListener
                                                                    .appointmentList[
                                                                        index]
                                                                    .appointmentID
                                                                    .toString());
                                                      } else {
                                                        _launchURL(
                                                            "https://fliqcard.com/1to1.php/" +
                                                                providerListener
                                                                    .appointmentList[
                                                                        index]
                                                                    .appointmentID
                                                                    .toString());
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.remove_red_eye,
                                                      color: Color(COLOR_PRIMARY),
                                                      size: 25,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      push(
                                                          context,
                                                          ShareAppointment(
                                                              (apiUrl +
                                                                  "/../shareAppointment.php?id=" +
                                                                  (providerListener
                                                                          .appointmentList[
                                                                              index]
                                                                          .appointmentID ??
                                                                      "") +
                                                                  "&title=" +
                                                                  (providerListener
                                                                          .appointmentList[
                                                                              index]
                                                                          .title ??
                                                                      "") +
                                                                  "&appointmentType=" +
                                                                  (providerListener
                                                                          .appointmentList[
                                                                              index]
                                                                          .appointmentType ??
                                                                      "") +
                                                                  "&email=" +
                                                                  (providerListener
                                                                          .userData
                                                                          .email ??
                                                                      "") +
                                                                  "&user_id=" +
                                                                  providerListener
                                                                      .userData.id
                                                                      .toString()),
                                                              (providerListener
                                                                      .appointmentList[
                                                                          index]
                                                                      .title ??
                                                                  "")));
                                                    },
                                                    child: Icon(
                                                      Icons.share,
                                                      color: Color(COLOR_PRIMARY),
                                                      size: 27,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      push(
                                                          context,
                                                          AddEditAppoitmentNew(
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .appointmentID,
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .appointmentType,
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .title,
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .meetingLink,
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .meetingPlace,
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .mapLink,
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .description,
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .appointmentDuration,
                                                              index,
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .confirmAppointmentDate,
                                                              providerListener
                                                                  .appointmentList[
                                                                      index]
                                                                  .confirmAppointmentEnddate));
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Color(COLOR_PRIMARY),
                                                      size: 25,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  InkWell(
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
                                                                  onPressed: () {  EasyLoading.show();
                                                                  Provider.of<CustomViewModel>(
                                                                      parentContext,
                                                                      listen: false)
                                                                      .cancelAppointMent(
                                                                      providerListener
                                                                          .appointmentList[
                                                                      index]
                                                                          .appointmentID)
                                                                      .then((value) {
                                                                    setState(() {
                                                                      providerListener
                                                                          .appointmentList
                                                                          .removeAt(index);
                                                                    });
                                                                    commonToast(
                                                                        context, value);
                                                                    EasyLoading.dismiss();
                                                                    Navigator.of(context).pop();
                                                                  });

                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });



                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Color(COLOR_PRIMARY),
                                                      size: 30,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (providerListener
                                                              .appointmentList[
                                                                  index]
                                                              .appointmentType ==
                                                          "Group") {
                                                        Clipboard.setData(ClipboardData(
                                                            text: ("https://fliqcard.com/group.php/" +
                                                                providerListener
                                                                    .appointmentList[
                                                                        index]
                                                                    .appointmentID
                                                                    .toString())));
                                                      } else {
                                                        Clipboard.setData(ClipboardData(
                                                            text: ("https://fliqcard.com/1to1.php/" +
                                                                providerListener
                                                                    .appointmentList[
                                                                        index]
                                                                    .appointmentID
                                                                    .toString())));
                                                      }

                                                      commonToast(context,
                                                          "Copied Invite Link");
                                                    },
                                                    child: Icon(
                                                      Icons.copy,
                                                      color: Color(COLOR_PRIMARY),
                                                      size: 25,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        })
                    : Container(
                        height: 200,
                        margin: EdgeInsets.only(bottom: 0),
                        child: Center(
                            child: commonTitle(context, "No results Found!"))),
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
