import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:expandable/expandable.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Contacts/UpdateContactScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AddEditAppoitmentNew.dart';
import 'ShareAppintment.dart';

class SlotsByDate extends StatefulWidget {
  final appointmentID, appIndex;

  SlotsByDate(this.appointmentID, this.appIndex);

  @override
  _SlotsByDateState createState() => _SlotsByDateState();
}

class _SlotsByDateState extends State<SlotsByDate> {
  bool _isloaded = false;
  bool _isSearchBarOpen = false;
  TextEditingController searchTextController = new TextEditingController();

  FocusNode focusSearch = FocusNode();
  String _starttime = "";
  String _endtime = "";

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future getSlotsByDate() async {
    setState(() {
      _isloaded = false;
    });
    EasyLoading.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .getSlotsByDate(widget.appointmentID)
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
    getSlotsByDate();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return InkWell(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(COLOR_BACKGROUND),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              color: Color(COLOR_PRIMARY),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only( bottom: 5),
                    child: Padding(
                      padding: EdgeInsets.only(left: 12, right: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                pushReplacement(
                                    context,
                                    AddEditAppoitmentNew(
                                        providerListener
                                            .appointmentList[widget.appIndex]
                                            .appointmentID,
                                        providerListener
                                            .appointmentList[widget.appIndex]
                                            .appointmentType,
                                        providerListener
                                            .appointmentList[widget.appIndex].title,
                                        providerListener
                                            .appointmentList[widget.appIndex]
                                            .meetingLink,
                                        providerListener
                                            .appointmentList[widget.appIndex]
                                            .meetingPlace,
                                        providerListener
                                            .appointmentList[widget.appIndex]
                                            .mapLink,
                                        providerListener
                                            .appointmentList[widget.appIndex]
                                            .description,
                                        providerListener
                                            .appointmentList[widget.appIndex]
                                            .appointmentDuration,
                                        widget.appIndex,
                                        providerListener
                                            .appointmentList[widget.appIndex]
                                            .confirmAppointmentDate,
                                        providerListener
                                            .appointmentList[widget.appIndex]
                                            .confirmAppointmentEnddate));
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            commonTitleSmallBoldWhite(
                                context, "Set your weekly days & hours"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 20),
                    child: InkWell(
                      onTap: () {
                        push(
                            context,
                            ShareAppointment(
                                (apiUrl +
                                    "/../shareAppointment.php?id=" +
                                    (providerListener
                                            .appointmentList[widget.appIndex]
                                            .appointmentID ??
                                        "") +
                                    "&title=" +
                                    (providerListener
                                            .appointmentList[widget.appIndex]
                                            .title ??
                                        "") +
                                    "&appointmentType=" +
                                    (providerListener
                                            .appointmentList[widget.appIndex]
                                            .appointmentType ??
                                        "") +
                                    "&email=" +
                                    (providerListener.userData.email ?? "") +
                                    "&user_id=" +
                                    providerListener.userData.id.toString()),
                                (providerListener
                                        .appointmentList[widget.appIndex].title ??
                                    "")));
                      },
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Color(COLOR_PRIMARY).withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                InkWell(
                  onTap: () {
                    pushReplacement(
                        context,
                        AddEditAppoitmentNew(
                            providerListener
                                .appointmentList[widget.appIndex].appointmentID,
                            providerListener
                                .appointmentList[widget.appIndex].appointmentType,
                            providerListener
                                .appointmentList[widget.appIndex].title,
                            providerListener
                                .appointmentList[widget.appIndex].meetingLink,
                            providerListener
                                .appointmentList[widget.appIndex].meetingPlace,
                            providerListener
                                .appointmentList[widget.appIndex].mapLink,
                            providerListener
                                .appointmentList[widget.appIndex].description,
                            providerListener.appointmentList[widget.appIndex]
                                .appointmentDuration,
                            widget.appIndex,
                            providerListener.appointmentList[widget.appIndex]
                                .confirmAppointmentDate,
                            providerListener.appointmentList[widget.appIndex]
                                .confirmAppointmentEnddate));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 45,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Color(COLOR_PURPLE_PRIMARY),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(
                          "< Back",
                          textScaleFactor: 1,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


                InkWell(
                  onTap: () {
                    push(
                        context,
                        ShareAppointment(
                            (apiUrl +
                                "/../shareAppointment.php?id=" +
                                (providerListener.appointmentList[widget.appIndex]
                                        .appointmentID ??
                                    "") +
                                "&title=" +
                                (providerListener
                                        .appointmentList[widget.appIndex].title ??
                                    "") +
                                "&appointmentType=" +
                                (providerListener.appointmentList[widget.appIndex]
                                        .appointmentType ??
                                    "") +
                                "&email=" +
                                (providerListener.userData.email ?? "") +
                                "&user_id=" +
                                providerListener.userData.id.toString()),
                            (providerListener
                                    .appointmentList[widget.appIndex].title ??
                                "")));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 45,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color(COLOR_SECONDARY),
                      ),
                      child: Center(
                        child: Text(
                          "Share",
                          textScaleFactor: 1,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            letterSpacing: 1,
                            color: Color(COLOR_PRIMARY),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
          body: SingleChildScrollView(
            child: providerListener.SlotsByDateDayNAMEList.length > 0
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: providerListener.SlotsByDateDayNAMEList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.white,
                          child: ExpandableNotifier(
                            // <-- Provides ExpandableController to its children
                            child: Expandable(
                              // <-- Driven by ExpandableController from ExpandableNotifier
                              collapsed: ExpandableButton(
                                // <-- Expands when tapped on the cover photo
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: SizeConfig.screenWidth - 90,
                                            padding: EdgeInsets.only(
                                                left: 20, right: 5, top: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                    child: Text(
                                                        providerListener
                                                                .SlotsByDateDayNAMEList[
                                                                    index]
                                                                .dayname ??
                                                            "",
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Color(
                                                                    COLOR_PRIMARY))))),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                CupertinoSwitch(
                                                  trackColor: Colors.grey,
                                                  value: providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .status ==
                                                          "Available"
                                                      ? true
                                                      : false,
                                                  activeColor: Colors.green,
                                                  onChanged: (newValue) async {
                                                    EasyLoading.show();
                                                    if (providerListener
                                                            .SlotsByDateDayNAMEList[
                                                                index]
                                                            .status ==
                                                        "Unavailable") {
                                                      Provider.of<CustomViewModel>(
                                                              context,
                                                              listen: false)
                                                          .toggleAppointmentday(
                                                              "Available",
                                                              providerListener
                                                                  .SlotsByDateDayNAMEList[
                                                                      index]
                                                                  .slotID)
                                                          .then((value) {
                                                        setState(() {
                                                          providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .status = "Available";
                                                        });
                                                        commonToast(
                                                            context, value);
                                                        EasyLoading.dismiss();
                                                      });
                                                    } else {
                                                      Provider.of<CustomViewModel>(
                                                              context,
                                                              listen: false)
                                                          .toggleAppointmentday(
                                                              "Unavailable",
                                                              providerListener
                                                                  .SlotsByDateDayNAMEList[
                                                                      index]
                                                                  .slotID)
                                                          .then((value) {
                                                        setState(() {
                                                          providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .status = "Unavailable";
                                                        });
                                                        commonToast(
                                                            context, value);
                                                        EasyLoading.dismiss();
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    commonTitleSmallBold(
                                                      context,
                                                      UtcToLocal(providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .slotStartTime ??
                                                          ""),
                                                    ),
                                                    Text(" - "),
                                                    commonTitleSmallBold(
                                                      context,
                                                      UtcToLocal(providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .slotEndTime ??
                                                          ""),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Color(COLOR_SECONDARY),
                                        child: ExpandableButton(
                                            // <-- Collapses when tapped on
                                            child: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: Colors.black,
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              expanded: Column(children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: SizeConfig.screenWidth - 90,
                                            padding: EdgeInsets.only(
                                                left: 20, right: 5, top: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                    child: Text(
                                                        providerListener
                                                                .SlotsByDateDayNAMEList[
                                                                    index]
                                                                .dayname ??
                                                            "",

                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Color(
                                                                    COLOR_PRIMARY))))),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                CupertinoSwitch(
                                                  trackColor: Colors.grey,
                                                  value: providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .status ==
                                                          "Available"
                                                      ? true
                                                      : false,
                                                  activeColor: Colors.green,
                                                  onChanged: (newValue) async {
                                                    EasyLoading.show();
                                                    if (providerListener
                                                            .SlotsByDateDayNAMEList[
                                                                index]
                                                            .status ==
                                                        "Unavailable") {
                                                      Provider.of<CustomViewModel>(
                                                              context,
                                                              listen: false)
                                                          .toggleAppointmentday(
                                                              "Available",
                                                              providerListener
                                                                  .SlotsByDateDayNAMEList[
                                                                      index]
                                                                  .slotID)
                                                          .then((value) {
                                                        setState(() {
                                                          providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .status = "Available";
                                                        });
                                                        commonToast(
                                                            context, value);
                                                        EasyLoading.dismiss();
                                                      });
                                                    } else {
                                                      Provider.of<CustomViewModel>(
                                                              context,
                                                              listen: false)
                                                          .toggleAppointmentday(
                                                              "Unavailable",
                                                              providerListener
                                                                  .SlotsByDateDayNAMEList[
                                                                      index]
                                                                  .slotID)
                                                          .then((value) {
                                                        setState(() {
                                                          providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .status = "Unavailable";
                                                        });
                                                        commonToast(
                                                            context, value);
                                                        EasyLoading.dismiss();
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    commonTitleSmallBold(
                                                      context,
                                                      UtcToLocal(providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .slotStartTime ??
                                                          ""),
                                                    ),
                                                    Text(" - "),
                                                    commonTitleSmallBold(
                                                      context,
                                                      UtcToLocal(providerListener
                                                              .SlotsByDateDayNAMEList[
                                                                  index]
                                                              .slotEndTime ??
                                                          ""),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Color(COLOR_PRIMARY),
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
                                      left: 10, right: 10, top: 20, bottom: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                width:
                                                    SizeConfig.screenWidth / 2.5,
                                                child: Text(
                                                  "Start Time",

                                                  style: GoogleFonts.montserrat(
                                                      letterSpacing: 0.5,
                                                      decorationThickness: 1.5,
                                                      color: Colors.grey.shade800,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: SizeConfig.screenWidth /
                                                      2.7,
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    onTap: () async {
                                                      /*TimeOfDay time =
                                                                TimeOfDay.now();*/

                                                      TimeOfDay time =
                                                          TimeOfDay.fromDateTime(
                                                              DateTime.now().add(
                                                                  Duration(
                                                                      minutes:
                                                                          15)));

                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              new FocusNode());

                                                      TimeOfDay picked =
                                                          await showTimePicker(
                                                              context: context,
                                                              initialTime: time,
                                                              builder: (context,
                                                                  child) {
                                                                return MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          alwaysUse24HourFormat:
                                                                              true),
                                                                  child: Theme(
                                                                    data: ThemeData
                                                                            .light()
                                                                        .copyWith(
                                                                      colorScheme:
                                                                          ColorScheme
                                                                              .light(
                                                                        // change the border color

                                                                        primary:
                                                                            Color(
                                                                                COLOR_PRIMARY),
                                                                        // change the text color
                                                                        onSurface:
                                                                            Color(
                                                                                COLOR_PRIMARY),
                                                                      ),
                                                                      // button colors
                                                                      buttonTheme:
                                                                          ButtonThemeData(
                                                                        colorScheme:
                                                                            ColorScheme
                                                                                .light(
                                                                          primary:
                                                                              Color(COLOR_PRIMARY),
                                                                          onSecondary:
                                                                              Color(COLOR_PRIMARY),
                                                                          background:
                                                                              Color(COLOR_PRIMARY),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child: child,
                                                                  ),
                                                                );
                                                              });

                                                      if (picked != null) {
                                                        var dt = DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now().month,
                                                            DateTime.now().day,
                                                            picked.hour,
                                                            picked.minute);

                                                        setState(() {
                                                          time = picked;
                                                          _starttime =
                                                              DateFormat.Hms()
                                                                  .format(dt);
                                                        });
                                                      }
                                                    },
                                                    keyboardType:
                                                        TextInputType.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                    decoration: InputDecoration(
                                                      suffixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal: 15),
                                                          child: Icon(
                                                              Icons
                                                                  .access_time_sharp,
                                                              color: Color(
                                                                      COLOR_PRIMARY)
                                                                  .withOpacity(
                                                                      0.7),
                                                              size: 22)),
                                                      hintText: _starttime,
                                                      hintStyle:
                                                          GoogleFonts.openSans(
                                                              letterSpacing: 0.5,
                                                              decorationThickness:
                                                                  1.5,
                                                              color:
                                                                  Colors.grey
                                                                      .shade800,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade300,
                                                            width: 1.5),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                COLOR_SECONDARY),
                                                            width: 0.5),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Color(COLOR_SECONDARY)
                                                              .withOpacity(0.3),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 15),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                width:
                                                    SizeConfig.screenWidth / 2.5,
                                                child: Text(
                                                  "End Time",
                                                  style: GoogleFonts.montserrat(
                                                      letterSpacing: 0.5,
                                                      decorationThickness: 1.5,
                                                      color: Colors.grey.shade800,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: SizeConfig.screenWidth /
                                                      2.7,
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    onTap: () async {
                                                      /*TimeOfDay time =
                                                                TimeOfDay.now();*/

                                                      TimeOfDay time =
                                                          TimeOfDay.fromDateTime(
                                                              DateTime.now().add(
                                                                  Duration(
                                                                      minutes:
                                                                          15)));

                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              new FocusNode());

                                                      TimeOfDay picked =
                                                          await showTimePicker(
                                                              context: context,
                                                              initialTime: time,
                                                              builder: (context,
                                                                  child) {
                                                                return MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          alwaysUse24HourFormat:
                                                                              true),
                                                                  child: Theme(
                                                                    data: ThemeData
                                                                            .light()
                                                                        .copyWith(
                                                                      colorScheme:
                                                                          ColorScheme
                                                                              .light(
                                                                        // change the border color

                                                                        primary:
                                                                            Color(
                                                                                COLOR_PRIMARY),
                                                                        // change the text color
                                                                        onSurface:
                                                                            Color(
                                                                                COLOR_PRIMARY),
                                                                      ),
                                                                      // button colors
                                                                      buttonTheme:
                                                                          ButtonThemeData(
                                                                        colorScheme:
                                                                            ColorScheme
                                                                                .light(
                                                                          primary:
                                                                              Color(COLOR_PRIMARY),
                                                                          onSecondary:
                                                                              Color(COLOR_PRIMARY),
                                                                          background:
                                                                              Color(COLOR_PRIMARY),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child: child,
                                                                  ),
                                                                );
                                                              });

                                                      if (picked != null) {
                                                        var dt = DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now().month,
                                                            DateTime.now().day,
                                                            picked.hour,
                                                            picked.minute);

                                                        setState(() {
                                                          time = picked;
                                                          _endtime =
                                                              DateFormat.Hms()
                                                                  .format(dt);
                                                        });
                                                      }
                                                    },
                                                    keyboardType:
                                                        TextInputType.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                    decoration: InputDecoration(
                                                      suffixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal: 15),
                                                          child: Icon(
                                                              Icons
                                                                  .access_time_sharp,
                                                              color: Color(
                                                                      COLOR_PRIMARY)
                                                                  .withOpacity(
                                                                      0.7),
                                                              size: 22)),
                                                      hintText: _endtime,
                                                      hintStyle:
                                                          GoogleFonts.openSans(
                                                              letterSpacing: 0.5,
                                                              decorationThickness:
                                                                  1.5,
                                                              color:
                                                                  Colors.grey
                                                                      .shade800,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade300,
                                                            width: 1.5),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                COLOR_SECONDARY),
                                                            width: 0.5),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Color(COLOR_SECONDARY)
                                                              .withOpacity(0.3),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 15),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          EasyLoading.show();
                                          Provider.of<CustomViewModel>(context,
                                                  listen: false)
                                              .updateDayHoursInUTC(
                                                  localToUtc(_starttime),
                                                  localToUtc(_endtime),
                                                  providerListener
                                                      .SlotsByDateDayNAMEList[
                                                          index]
                                                      .slotID)
                                              .then((value) {
                                            setState(() {
                                              providerListener
                                                      .SlotsByDateDayNAMEList[index]
                                                      .slotStartTime =
                                                  localToUtc(_starttime);
                                              providerListener
                                                      .SlotsByDateDayNAMEList[index]
                                                      .slotEndTime =
                                                  localToUtc(_endtime);
                                            });
                                            commonToast(context, value);
                                            EasyLoading.dismiss();
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20, top: 20),
                                          child: Container(
                                            height: 45,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(COLOR_PRIMARY),
                                                  Color(COLOR_PRIMARY),
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Save",
                                                textScaleFactor: 1,

                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  letterSpacing: 1,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      );
                    })
                : Container(
                    height: 200,
                    margin: EdgeInsets.only(bottom: 0),
                    child:
                        Center(child: commonTitle(context, "No results Found!"))),
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
