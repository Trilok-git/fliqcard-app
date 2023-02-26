import 'package:date_time_picker/date_time_picker.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'ViewComments.dart';

BuildContext parentContext;

class ViewProfileFollowup extends StatefulWidget {
  int index;
  String status;

  ViewProfileFollowup(this.index, this.status);

  @override
  _ViewProfileFollowupState createState() => _ViewProfileFollowupState();
}

class _ViewProfileFollowupState extends State<ViewProfileFollowup> {
  int counter = 0;
  var created = "";
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {
      parentContext = context;
    });
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: providerListener.followupList.length == 0
          ? Container()
          : Scaffold(
              backgroundColor: Color(COLOR_BACKGROUND),
              appBar: AppBar(
                backgroundColor: Color(COLOR_PRIMARY),
                title: commonTitleSmallWhite(context,
                    (providerListener.followupList[widget.index].name ?? "")),
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
                height: double.infinity,
                width: SizeConfig.screenWidth,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          color: Color(0xffE3E8FF),
                          width: SizeConfig.screenWidth,
                          height: 110,
                        ),
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            (providerListener.followupList[widget.index]
                                            .profileImagePath ??
                                        "") !=
                                    ""
                                ? Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7c94b6),
                                      image: DecorationImage(
                                        image: NetworkImage(apiUrl +
                                            "../../" +
                                            providerListener
                                                .followupList[widget.index]
                                                .profileImagePath),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0)),
                                    ),
                                  )
                                : Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        image: AssetImage("assets/profile.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0)),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                  (providerListener
                                          .followupList[widget.index].name ??
                                      ""),
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(COLOR_TITLE)))),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (providerListener.followupList[widget.index]
                                                .phone ??
                                            "")
                                        .isEmpty
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          commonLaunchURL("tel:" +
                                              (providerListener
                                                  .followupList[widget.index]
                                                  .phone));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Image.asset(
                                            "assets/phone.png",
                                            width: 22,
                                          ),
                                        ),
                                      ),
                                (providerListener.followupList[widget.index]
                                                .phone ??
                                            "")
                                        .isEmpty
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          commonLaunchURL(
                                              "https://api.whatsapp.com/send?phone=" +
                                                  (providerListener
                                                      .followupList[
                                                          widget.index]
                                                      .phone));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Image.asset(
                                            "assets/whatsapp.png",
                                            width: 22,
                                          ),
                                        ),
                                      ),
                                (providerListener.followupList[widget.index]
                                                .email ??
                                            "")
                                        .isEmpty
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          commonLaunchURL("mailto:" +
                                              (providerListener
                                                  .followupList[widget.index]
                                                  .email));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Image.asset(
                                            "assets/email.png",
                                            width: 22,
                                          ),
                                        ),
                                      ),
                                /* (widget.status ?? "") == "complete"
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          EasyLoading.show();

                                          Provider.of<CustomViewModel>(context,
                                                  listen: false)
                                              .CompleteFollowup(providerListener
                                                  .followupList[widget.index]
                                                  .id)
                                              .then((value) {
                                            commonToast(context, value);
                                            EasyLoading.dismiss();
                                            Provider.of<CustomViewModel>(
                                                    context,
                                                    listen: false)
                                                .getFollowup(widget.status);
                                            pop(context);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.black,
                                            size: 24,
                                          ),
                                        )),*/
                                InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Are you sure?'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.white,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical: 2),
                                                          textStyle: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300)),
                                                  child: Text(
                                                    'No',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Color(
                                                                COLOR_PRIMARY)),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.white,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical: 2),
                                                          textStyle: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300)),
                                                  child: Text(
                                                    'Yes',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Color(
                                                                COLOR_PRIMARY)),
                                                  ),
                                                  onPressed: () {
                                                    EasyLoading.show();
                                                    Provider.of<CustomViewModel>(
                                                            parentContext,
                                                            listen: false)
                                                        .CancelFollowup(
                                                            providerListener
                                                                .followupList[
                                                                    widget
                                                                        .index]
                                                                .id)
                                                        .then((value) {
                                                      commonToast(
                                                          parentContext, value);
                                                      EasyLoading.dismiss();
                                                      Provider.of<CustomViewModel>(
                                                              parentContext,
                                                              listen: false)
                                                          .getFollowup(
                                                              widget.status);
                                                      Navigator.of(context)
                                                          .pop();
                                                      pop(parentContext);
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    )),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text("Professional Information",
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color(COLOR_TITLE)))),
                                ),
                              ],
                            ),
                            (providerListener.followupList[widget.index]
                                                .email ??
                                            "")
                                        .toString() ==
                                    ""
                                ? Container()
                                : Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 10),
                                        child: Icon(
                                          Icons.email,
                                          size: 15,
                                        ),
                                      ),
                                      Text(
                                          providerListener
                                                  .followupList[widget.index]
                                                  .email ??
                                              "",
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      Colors.grey.shade800))),
                                    ],
                                  ),
                            SizedBox(
                              height: 5,
                            ),
                            (providerListener.followupList[widget.index]
                                                .phone ??
                                            "")
                                        .toString() ==
                                    ""
                                ? Container()
                                : Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 10),
                                        child: Icon(
                                          Icons.phone,
                                          size: 15,
                                        ),
                                      ),
                                      Text(
                                          providerListener
                                                  .followupList[widget.index]
                                                  .phone ??
                                              "",
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      Colors.grey.shade800))),
                                    ],
                                  ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            (providerListener.followupList[widget.index]
                                                .about ??
                                            "")
                                        .toString() ==
                                    ""
                                ? Container()
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 10, top: 5),
                                        child: Icon(
                                          Icons.comment,
                                          size: 12,
                                        ),
                                      ),
                                      Container(
                                        width: SizeConfig.screenWidth / 1.2,
                                        child: Text(
                                            providerListener
                                                    .followupList[widget.index]
                                                    .about ??
                                                "",
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Colors.grey.shade800))),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            providerListener.memberShip == null
                                ? Container()
                                : Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text("Schedule a follow up",
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Color(COLOR_TITLE)))),
                                      ),
                                    ],
                                  ),
                            providerListener.memberShip == null
                                ? Container()
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    width:
                                                        SizeConfig.screenWidth -
                                                            100,
                                                    child: commonTitleSmall(
                                                        context,
                                                        "To Schedule followup select date, time and submit")),
                                                InkWell(
                                                  onTap: () {
                                                    push(
                                                        context,
                                                        ViewComments(
                                                            providerListener
                                                                .followupList[
                                                                    widget
                                                                        .index]
                                                                .email));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 20, top: 15),
                                        child: TextFormField(
                                          maxLines: 2,
                                          controller: notesController,
                                          decoration: InputDecoration(
                                            hintText: 'Your Comment',
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                color: Color(COLOR_SUBTITLE)),
                                            filled: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 20,
                                            top: 15,
                                            bottom: 12),
                                        child: Container(
                                          width: SizeConfig.screenWidth - 20,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color:
                                                  Color(COLOR_PURPLE_PRIMARY),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            color: Color(COLOR_PURPLE_PRIMARY)
                                                .withOpacity(0.1),
                                          ),
                                          child: DateTimePicker(
                                            type: DateTimePickerType
                                                .dateTimeSeparate,
                                            dateMask: 'd MMM, yyyy',
                                            initialValue:
                                                DateTime.now().toString(),
                                            firstDate: DateTime(2021),
                                            lastDate: DateTime(2500),
                                            icon: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.event,
                                                color:
                                                    Color(COLOR_PURPLE_PRIMARY),
                                              ),
                                            ),
                                            dateLabelText: 'Date',
                                            timeLabelText: "Hour",
                                            selectableDayPredicate: (date) {
                                              return true;
                                            },
                                            onChanged: (val) {
                                              print(val);
                                              print(val.replaceAll(" ", "T"));
                                              created =
                                                  val.replaceAll(" ", "T");
                                            },
                                            validator: (val) {
                                              print(val);

                                              return null;
                                            },
                                            onSaved: (val) => print(val),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: InkWell(
                                          onTap: () {
                                            if (created != "") {
                                              EasyLoading.show();
                                              Provider.of<CustomViewModel>(
                                                      context,
                                                      listen: false)
                                                  .RescheduleFollowup(
                                                      providerListener
                                                          .followupList[
                                                              widget.index]
                                                          .id,
                                                      providerListener
                                                          .followupList[
                                                              widget.index]
                                                          .userId,
                                                      created,
                                                      providerListener
                                                          .followupList[
                                                              widget.index]
                                                          .email,
                                                      notesController.text)
                                                  .then((value) {
                                                created =
                                                    created.replaceAll(":", "");
                                                created = created.replaceAll(
                                                    "T", "+");
                                                created =
                                                    created.replaceAll("-", "");

                                                created = created + "00";

                                                commonToast(context, value);

                                                Provider.of<CustomViewModel>(
                                                        context,
                                                        listen: false)
                                                    .getFollowup("pending")
                                                    .then((value) {
                                                  EasyLoading.dismiss();
                                                  pop(context);
                                                });

                                                /*commonLaunchURL(
                                                    "https://calendar.google.com/calendar/u/0/r/eventedit?action=TEMPLATE&text=" +
                                                        (providerListener
                                                                .followupList[
                                                                    widget
                                                                        .index]
                                                                .name ??
                                                            "") +
                                                        "&details=" +
                                                        (notesController.text ??
                                                            "") +
                                                        "&dates=" +
                                                        created +
                                                        "/" +
                                                        created);
*/
                                                setState(() {
                                                  created = "";
                                                  notesController.clear();
                                                });
                                              });
                                            } else {
                                              commonToast(context,
                                                  "To reschedule followup select date, time and submit");
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7)),
                                              color:
                                                  Color(COLOR_PURPLE_PRIMARY),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30),
                                                child: Text(
                                                  "Reschedule",
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            (widget.status ?? "") == "complete"
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 20,
                                        top: 10,
                                        bottom: 80),
                                    child: InkWell(
                                      onTap: () {
                                        EasyLoading.show();

                                        Provider.of<CustomViewModel>(context,
                                                listen: false)
                                            .CompleteFollowup(providerListener
                                                .followupList[widget.index].id)
                                            .then((value) {
                                          commonToast(context, value);
                                          EasyLoading.dismiss();
                                          Provider.of<CustomViewModel>(context,
                                                  listen: false)
                                              .getFollowup(widget.status);
                                          pop(context);
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)),
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color:
                                                    Color(COLOR_PURPLE_PRIMARY),
                                                width: 1)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: Text(
                                              "Mark Complete",
                                              style: GoogleFonts.montserrat(
                                                  color: Color(
                                                      COLOR_PURPLE_PRIMARY),
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 5,
                        child: Container(
                            child: commonTitleSmallBold(
                                context,
                                ("Follow up on " +
                                    (providerListener.followupList[widget.index]
                                                .createdAt ??
                                            "")
                                        .toString()
                                        .replaceAll("T", ", ")))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
