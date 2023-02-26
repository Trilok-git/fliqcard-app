import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Contacts/UpdateContactScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';


BuildContext parentContext;

class ListOfEvents extends StatefulWidget {
  @override
  _ListOfEventsState createState() => _ListOfEventsState();
}

class _ListOfEventsState extends State<ListOfEvents> {
  bool _isloaded = false;
  bool _isSearchBarOpen = false;
  TextEditingController searchTextController = new TextEditingController();

  FocusNode focusSearch = FocusNode();

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future getEvents() async {
    setState(() {
      _isloaded = false;
    });

    Provider.of<CustomViewModel>(context, listen: false)
        .getEvents()
        .then((value) {
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
    getEvents();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      parentContext = context;
    });
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            color: Color(COLOR_BACKGROUND),
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 20,),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
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
                              color: Color(COLOR_PRIMARY),
                            ),
                          ),
                        ),
                        commonTitle(context, "Events"),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _launchURL(apiUrl +
                                "/../create_event.php?user_id=" +
                                providerListener.userData.id);
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 15),
                              Icon(
                                Icons.add,
                                color: Color(COLOR_PRIMARY),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            getEvents();
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 15),
                              Icon(
                                Icons.refresh,
                                color: Color(COLOR_PRIMARY),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: commonTitleSmallBold(context,
                    "After add or edit completed, please refresh to see the changes."),
              ),
              providerListener.eventsList.length > 0
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: providerListener.eventsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              color: Color(0xffE3E8FF),
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 0,
                                            top: 15,
                                            bottom: 15),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10,
                                              bottom: 10,
                                              top: 10,
                                              right: 5),
                                          width: SizeConfig.screenWidth,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              commonTitleSmall(
                                                  context,
                                                  providerListener
                                                          .eventsList[index]
                                                          .title ??
                                                      ""),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, right: 20),
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
                                                    color: Color(COLOR_PRIMARY),
                                                    size: 14,
                                                  ),
                                                  SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  commonTitleSmall(
                                                      context,
                                                      providerListener
                                                              .eventsList[index]
                                                              .venue ??
                                                          ""),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    color: Color(COLOR_PRIMARY),
                                                    size: 14,
                                                  ),
                                                  SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  commonTitleSmall(
                                                      context,
                                                      (providerListener
                                                                  .eventsList[
                                                                      index]
                                                                  .updatedAt ??
                                                              "")
                                                          .replaceAll(" ", ", ")
                                                          .replaceAll("T", ", ")),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _launchURL(apiUrl +
                                                    "/../../event.php?id=" +
                                                    providerListener
                                                        .eventsList[index].id);
                                              },
                                              child: Icon(
                                                Icons.remove_red_eye,
                                                color: Color(COLOR_PRIMARY),
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _launchURL(apiUrl +
                                                    "/../create_event.php?action=edit&user_id=" +
                                                    providerListener
                                                        .eventsList[index]
                                                        .userId +
                                                    "&" +
                                                    "id=" +
                                                    providerListener
                                                        .eventsList[index].id);
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: Color(COLOR_PRIMARY),
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
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
                                                            onPressed: () {

                                                              EasyLoading.show();
                                                              Provider.of<CustomViewModel>(
                                                                  parentContext,
                                                                  listen: false)
                                                                  .DeleteEvent(providerListener
                                                                  .eventsList[index].id, index)
                                                                  .then((value) {
                                                                EasyLoading.dismiss();
                                                                commonToast(parentContext, value);

                                                              });

                                                              Navigator.of(context).pop();



                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });


                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Color(COLOR_PRIMARY),
                                                size: 35,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _launchURL(apiUrl +
                                                    "/../share_event.php?id=" +
                                                    (providerListener
                                                            .eventsList[index]
                                                            .id ??
                                                        "") +
                                                    "&title=" +
                                                    (providerListener
                                                            .eventsList[index]
                                                            .title ??
                                                        "") +
                                                    "&schedued_at=" +
                                                    (providerListener
                                                            .eventsList[index]
                                                            .updatedAt ??
                                                        "") +
                                                    "&organizer=" +
                                                    (providerListener
                                                            .eventsList[index]
                                                            .organizer ??
                                                        "") +
                                                    "&email=" +
                                                    (providerListener
                                                            .userData.email ??
                                                        "") +
                                                    "&user_id=" +
                                                    providerListener
                                                        .eventsList[index]
                                                        .userId);
                                              },
                                              child: Icon(
                                                Icons.share,
                                                color: Color(COLOR_PRIMARY),
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
