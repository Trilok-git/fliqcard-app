import 'dart:io';

import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/MainScreen.dart';
import 'package:fliqcard/UI/Pricing/PricingScreen.dart';
import 'package:fliqcard/UI/Staff/StaffListScreen.dart';
import 'package:fliqcard/UI/Themes/ThemeSelector.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'SlotsByDate.dart';

class AddEditAppoitmentNew extends StatefulWidget {
  final appointmentID,
      appointmentType,
      title,
      meeting_link,
      meeting_place,
      map_link,
      desc,
      appointment_duration,
      appIndex,
      StartDate,
      endDate;

  const AddEditAppoitmentNew(
      this.appointmentID,
      this.appointmentType,
      this.title,
      this.meeting_link,
      this.meeting_place,
      this.map_link,
      this.desc,
      this.appointment_duration,
      this.appIndex,
      this.StartDate,
      this.endDate);

  @override
  _AddEditAppoitmentNewState createState() => _AddEditAppoitmentNewState();
}

class _AddEditAppoitmentNewState extends State<AddEditAppoitmentNew> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleCotroller = TextEditingController();
  TextEditingController meeting_linkController = TextEditingController();
  TextEditingController meeting_placeCotroller = TextEditingController();
  TextEditingController map_linkCotroller = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController appointment_durationCotroller = TextEditingController();
  var StartDate = "";
  var endDate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      titleCotroller.text = widget.title;
      meeting_linkController.text = widget.meeting_link;
      meeting_placeCotroller.text = widget.meeting_place;
      map_linkCotroller.text = widget.map_link;
      descController.text = widget.desc;
      appointment_durationCotroller.text = widget.appointment_duration;
      StartDate = widget.StartDate;
      endDate = widget.endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      // TODO: implement your code here

      try {
        if (args != null) {
          setState(() {
            final difference =
                args.value.endDate.difference(args.value.startDate).inDays;
            if (int.parse(difference.toString()) < 0) {
              commonToast(
                  context, "End date cannot be greater than start date");
            } else {
              StartDate =
                  args.value.startDate.toString().split(" ").first.toString();
              endDate =
                  args.value.endDate.toString().split(" ").first.toString();
            }
          });
        }
      } catch (e) {
        // print(e);

        setState(() {
          StartDate = "";
          endDate = "";
        });
      }
    }

    return InkWell(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(COLOR_BACKGROUND),
          appBar: AppBar(
            backgroundColor: Color(COLOR_PRIMARY),
            title: commonTitleSmallBoldWhite(
                context, "Manage " + (widget.appointmentType ?? "")),
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
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 10, bottom: 5),
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      if (StartDate == "" || endDate == "") {
                        commonToast(context, "please select date");
                      } else {
                        if (widget.appointmentID == null) {
                          EasyLoading.show(status: 'Please wait, adding...');
                          Provider.of<CustomViewModel>(context, listen: false)
                              .addAppointMent(
                                  StartDate,
                                  endDate,
                                  titleCotroller.text,
                                  widget.appointmentType,
                                  meeting_linkController.text,
                                  meeting_placeCotroller.text,
                                  map_linkCotroller.text,
                                  descController.text,
                                  appointment_durationCotroller.text)
                              .then((value) {
                            Provider.of<CustomViewModel>(context, listen: false)
                                .getAllappointment()
                                .then((value) {
                              EasyLoading.dismiss();

                              pushReplacement(
                                  context,
                                  SlotsByDate(
                                      providerListener
                                          .appointmentList[widget.appIndex]
                                          .appointmentID,
                                      0));
                            });
                          });
                        } else {
                          EasyLoading.show(status: 'Please wait, Updating...');
                          Provider.of<CustomViewModel>(context, listen: false)
                              .updateAppointMent(
                                  widget.appointmentID,
                                  StartDate,
                                  endDate,
                                  titleCotroller.text,
                                  widget.appointmentType,
                                  meeting_linkController.text,
                                  meeting_placeCotroller.text,
                                  map_linkCotroller.text,
                                  descController.text,
                                  appointment_durationCotroller.text)
                              .then((value) {
                            Provider.of<CustomViewModel>(context, listen: false)
                                .getAllappointment()
                                .then((value) {
                              EasyLoading.dismiss();

                              pushReplacement(
                                  context,
                                  SlotsByDate(
                                      providerListener
                                          .appointmentList[widget.appIndex]
                                          .appointmentID,
                                      widget.appIndex));
                            });
                          });
                        }
                      }
                    } else {
                      commonToast(context, "Please fill required data");
                    }
                  },
                  child: Container(
                    width: 80,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(COLOR_PURPLE_PRIMARY),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(COLOR_PURPLE_PRIMARY).withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: GoogleFonts.montserrat(
                            textStyle:
                                TextStyle(fontSize: 15.0, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: Container(
            width: SizeConfig.screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: titleCotroller,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value != "") {
                          return null;
                        } else {
                          return "Field required!";
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Subject',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: meeting_placeCotroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Venue (Optional)',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Duration in minutes",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey.shade700))),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: appointment_durationCotroller,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != "") {
                          return null;
                        } else {
                          return "Field required!";
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Recommended 30 minutes',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (StartDate ?? "") == ""
                              ? commonTitleSmallBoldRed(context,
                                  "Select date range.     OR \nDouble tap on date for single day.")
                              : commonTitleSmallBoldBlue(
                                  context, (StartDate ?? "")),
                          commonTitleSmallBoldBlue(context, endDate ?? ""),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: SfDateRangePicker(
                            minDate: DateTime.now(),
                            backgroundColor: Colors.white,
                            selectionColor: Color(COLOR_PRIMARY),
                            rangeSelectionColor:
                                Color(COLOR_SECONDARY).withOpacity(0.3),
                            startRangeSelectionColor: Colors.black,
                            endRangeSelectionColor: Colors.black,
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode: DateRangePickerSelectionMode.range,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: meeting_linkController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Meeting link (Optional)',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: map_linkCotroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Google Map link (Optional)',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: descController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Details (Optional)',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
