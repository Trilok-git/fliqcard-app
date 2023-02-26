import 'package:date_time_picker/date_time_picker.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Follow/ListOfFollow.dart';
import 'package:fliqcard/UI/Follow/ViewComments.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'UpdateContactScreen.dart';

BuildContext parentContext;

class ViewProfile extends StatefulWidget {
  int index;

  ViewProfile(this.index);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
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
      child: providerListener.contactsList.length == 0
          ? Container()
          : Scaffold(
              backgroundColor: Color(COLOR_BACKGROUND),
              appBar: AppBar(
                backgroundColor: Color(COLOR_PRIMARY),
                title: commonTitleSmallWhite(context,
                    (providerListener.contactsList[widget.index].name ?? "")),
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
                          height: 90,
                        ),
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            (providerListener.contactsList[widget.index]
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
                                                .contactsList[widget.index]
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
                                          .contactsList[widget.index].name ??
                                      ""),
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(COLOR_TITLE)))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                  (providerListener.contactsList[widget.index]
                                          .category ??
                                      ""),
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w300,
                                          color: Color(COLOR_TITLE)))),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (providerListener.contactsList[widget.index]
                                                .phone ??
                                            "")
                                        .isEmpty
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          commonLaunchURL("tel:" +
                                              (providerListener
                                                  .contactsList[widget.index]
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
                                (providerListener.contactsList[widget.index]
                                                .phone ??
                                            "")
                                        .isEmpty
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          commonLaunchURL(
                                              "https://api.whatsapp.com/send?phone=" +
                                                  (providerListener
                                                              .contactsList[
                                                                  widget.index]
                                                              .phone ??
                                                          "")
                                                      .replaceAll("+", "")
                                                      .replaceAll(" ", ""));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Image.asset(
                                            "assets/whatsapp.png",
                                            width: 22,
                                          ),
                                        ),
                                      ),
                                (providerListener.contactsList[widget.index]
                                                .email ??
                                            "")
                                        .isEmpty
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          commonLaunchURL("mailto:" +
                                              (providerListener
                                                  .contactsList[widget.index]
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
                                InkWell(
                                  onTap: () {
                                    push(
                                        context,
                                        UpdateContactScreen(
                                            widget.index,
                                            providerListener
                                                .contactsList[widget.index].id,
                                            providerListener
                                                .contactsList[widget.index]
                                                .tags,
                                            providerListener
                                                .contactsList[widget.index]
                                                .notes,
                                            providerListener
                                                    .contactsList[widget.index]
                                                    .category ??
                                                "",
                                            providerListener
                                                    .contactsList[widget.index]
                                                    .phone ??
                                                ""));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Color(COLOR_PURPLE_PRIMARY),
                                    ),
                                  ),
                                ),
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
                                                        .deleteContact(
                                                            providerListener
                                                                .contactsList[
                                                                    widget
                                                                        .index]
                                                                .id)
                                                        .then((value) {
                                                      EasyLoading.dismiss();
                                                    });

                                                    Navigator.of(context).pop();
                                                    pop(parentContext);
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
                            (providerListener.contactsList[widget.index]
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
                                                  .contactsList[widget.index]
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
                            (providerListener.contactsList[widget.index]
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
                                                  .contactsList[widget.index]
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
                            (providerListener.contactsList[widget.index]
                                                .company ??
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
                                          Icons.circle,
                                          size: 10,
                                        ),
                                      ),
                                      Text(
                                          providerListener
                                                  .contactsList[widget.index]
                                                  .company ??
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
                            (providerListener.contactsList[widget.index].tags ??
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
                                          Icons.tag,
                                          size: 10,
                                        ),
                                      ),
                                      Text(
                                          providerListener
                                                  .contactsList[widget.index]
                                                  .tags ??
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
                            (providerListener.contactsList[widget.index]
                                                .notes ??
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
                                          Icons.circle,
                                          size: 10,
                                        ),
                                      ),
                                      Text(
                                          providerListener
                                                  .contactsList[widget.index]
                                                  .notes ??
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
                                                                .contactsList[
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
                                            left: 15, top: 10, bottom: 50),
                                        child: Row(
                                          children: [
                                            Container(
                                              width:
                                                  SizeConfig.screenWidth - 140,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Color(
                                                      COLOR_PURPLE_PRIMARY),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                                color:
                                                    Color(COLOR_PURPLE_PRIMARY)
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
                                                    color: Color(
                                                        COLOR_PURPLE_PRIMARY),
                                                  ),
                                                ),
                                                dateLabelText: 'Date',
                                                timeLabelText: "Hour",
                                                selectableDayPredicate: (date) {
                                                  return true;
                                                },
                                                onChanged: (val) {
                                                  print(val);
                                                  print(
                                                      val.replaceAll(" ", "T"));
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  if (created != "") {
                                                    Provider.of<CustomViewModel>(
                                                            context,
                                                            listen: false)
                                                        .AddFollowup(
                                                            providerListener
                                                                .userData.id,
                                                            providerListener
                                                                .contactsList[
                                                                    widget
                                                                        .index]
                                                                .name,
                                                            providerListener
                                                                .contactsList[
                                                                    widget
                                                                        .index]
                                                                .email,
                                                            providerListener
                                                                .contactsList[
                                                                    widget
                                                                        .index]
                                                                .phone,
                                                            created,
                                                            notesController
                                                                .text)
                                                        .then((value) {
                                                      print(created);

                                                      created = created
                                                          .replaceAll(":", "");
                                                      created = created
                                                          .replaceAll("T", "+");
                                                      created = created
                                                          .replaceAll("-", "");

                                                      created = created + "00";

                                                      push(context,
                                                          ListOfFollow());
                                                      commonToast(
                                                          context, value);
                                                      /*commonLaunchURL(
                                                          "https://calendar.google.com/calendar/u/0/r/eventedit?action=TEMPLATE&text=" +
                                                              (providerListener
                                                                      .contactsList[
                                                                          widget
                                                                              .index]
                                                                      .name ??
                                                                  "") +
                                                              "&details=" +
                                                              (notesController
                                                                      .text ??
                                                                  "") +
                                                              "&dates=" +
                                                              created +
                                                              "/" +
                                                              created);*/

                                                      setState(() {
                                                        created = "";
                                                        notesController.clear();
                                                      });
                                                    });
                                                  } else {
                                                    commonToast(context,
                                                        "To Schedule followup select date, time and submit");
                                                  }
                                                },
                                                child: Container(
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Color(
                                                          COLOR_PURPLE_PRIMARY),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(3)),
                                                    color: Color(
                                                            COLOR_PURPLE_PRIMARY)
                                                        .withOpacity(0.1),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 30),
                                                      child: Text(
                                                        "Add",
                                                        style: GoogleFonts
                                                            .montserrat(
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
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
