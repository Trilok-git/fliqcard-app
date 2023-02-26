import 'dart:async';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Staff/AddEditStaff.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(String _url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

class SelectWhomToSentScreen extends StatefulWidget {
  @override
  _SelectWhomToSentScreenState createState() => _SelectWhomToSentScreenState();
}

class _SelectWhomToSentScreenState extends State<SelectWhomToSentScreen> {
  List<String> selectedIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
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
          title: commonTitleSmallWhite(context, "Send using Radar"),
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
          child: providerListener.nearByUsersList.length > 0
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: SizeConfig.screenWidth / 1.5,
                              child: Text(
                                  (providerListener.nearByUsersList.length
                                          .toString()) +
                                      " Receivers found near you",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: Color(COLOR_PRIMARY))),
                            ),
                          ),
                          InkWell(
                            onTap: () async {



                               if(selectedIds.length>0){
                                 EasyLoading.show(status: 'Sending...');
                                 for(int i=0;i<selectedIds.length;i++){
                                   Provider.of<CustomViewModel>(context,
                                       listen: false)
                                       .SendOneByOne(selectedIds[i])
                                       .then((value) {
                                   });
                                 }

                                 EasyLoading.dismiss();
                                 commonToast(context, "Card send!");
                               }else{
                                 commonToast(context, "No receiver selected");
                               }


                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color(COLOR_PURPLE_PRIMARY),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Text("Send",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)))),
                          ),
                        ],
                      ),
                      ListView.builder(
                          itemCount: providerListener.nearByUsersList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: (){
                                if (!selectedIds.contains(
                                    providerListener
                                        .nearByUsersList[index].id)) {
                                  setState(() {
                                    selectedIds.add(providerListener
                                        .nearByUsersList[index].id);
                                  });
                                } else {
                                  setState(() {
                                    selectedIds.remove(
                                        providerListener
                                            .nearByUsersList[index]
                                            .id);
                                  });
                                }
                              },
                              child: Card(
                                elevation: 0,
                                color: Color(COLOR_BACKGROUND),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 60.0,
                                            height: 60.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/profile.png"),
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
                                          Container(
                                            width: SizeConfig.screenWidth / 2,
                                            child: Text(
                                                providerListener
                                                        .nearByUsersList[index]
                                                        .fullname ??
                                                    "",
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(COLOR_PRIMARY))),
                                          ),
                                          selectedIds.contains(
                                                  providerListener
                                                      .nearByUsersList[index].id)
                                              ? Icon(
                                                  Icons.check_box,
                                                  color:
                                                      Color(COLOR_PURPLE_PRIMARY),
                                                )
                                              : Icon(
                                                  Icons.check_box_outline_blank),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 0),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: commonTitleSmallBold(
                            context, "No active receiver found!"),
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
