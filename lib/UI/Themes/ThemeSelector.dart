import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../GoPremiumWidget.dart';

void _launchURL(String _url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

class ThemeSelector extends StatefulWidget {
  @override
  createState() {
    return new ThemeSelectorState();
  }
}

class ThemeSelectorState extends State<ThemeSelector> {
  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(new RadioModel('1', "The Original"));
    sampleData.add(new RadioModel('2',
        "The Banner\n2. Banner Video/image should be Horizontal \n3. 608 X1080 Resolution recommended"));
    sampleData.add(new RadioModel('3', "The Basic"));
    sampleData.add(new RadioModel(
        '4',
        "The Dynamic"
            ". \n 1. Logo required for this theme \n2. Banner Video/image should be Vertical \n3. 1080 X 608 Resolution recommended"));
    sampleData.add(
        new RadioModel('5', "E-com (* Products, Services, Payment Options)"));
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return providerListener.vcardData != null
        ? providerListener.vcardData.title != null
            ? SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Color(COLOR_BACKGROUND),
                    title: commonTitle(context, "Theme Selector"),
                    elevation: 0,
                    leading: InkWell(
                      onTap: () {
                        pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color(COLOR_PRIMARY),
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    height: 110,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth / 1.5,
                            child: Text(
                                "For custom designs and videos contact us",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(COLOR_TITLE)))),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL("mailto:fliqcard@fliqcard.com");
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Icon(
                                Icons.email,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          providerListener.memberShip != null
                              ? providerListener.memberShip.plan == "EXECUTIVE" ||
                                      providerListener.memberShip.plan ==
                                          "ECOMMERCE" ||
                                      providerListener.memberShip.plan ==
                                          "CORPORATE" ||
                                      providerListener.memberShip.plan ==
                                          "CORPORATE PLUS"
                                  ? Container(
                                      width: SizeConfig.screenWidth / 1.2,
                                      margin: new EdgeInsets.only(left: 10.0),
                                      child: new Text(
                                          "* Tap to select, Whatever you select will be used for the viewers of the FliQCard."),
                                    )
                                  : new Container(
                                      width: SizeConfig.screenWidth / 1.2,
                                      margin: new EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        children: [
                                          new Text(
                                              "* In Basic Free Plan you can preview all themes, But can use 'Theme Original' Only."),
                                          GoPremiumWidget(context, 2),
                                        ],
                                      ),
                                    )
                              : new Container(
                                  width: SizeConfig.screenWidth / 1.2,
                                  margin: new EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    children: [
                                      new Text(
                                          "* In Basic Free Plan you can preview all themes, But can use 'Theme Original' Only."),
                                      GoPremiumWidget(context, 2),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: SizeConfig.screenHeight,
                            child: new ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: sampleData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 3,
                                  child: Row(
                                    children: [
                                      new InkWell(
                                        //highlightColor: Colors.red,
                                        splashColor: Color(COLOR_PRIMARY),
                                        onTap: () {
                                          setState(() {
                                            if (providerListener.memberShip !=
                                                null) {
                                              if (providerListener.memberShip.plan == "EXECUTIVE" ||
                                                  providerListener
                                                          .memberShip.plan ==
                                                      "ECOMMERCE" ||
                                                  providerListener
                                                          .memberShip.plan ==
                                                      "CORPORATE" ||
                                                  providerListener
                                                          .memberShip.plan ==
                                                      "CORPORATE PLUS") {
                                                if ((sampleData[index]
                                                                .buttonText ??
                                                            "1") ==
                                                        "5" &&
                                                    providerListener
                                                            .memberShip.plan ==
                                                        "EXECUTIVE") {
                                                  commonToast(context,
                                                      "Theme available for ECOMMERCE and CORPORATE Plans.");
                                                } else {
                                                  Provider.of<CustomViewModel>(
                                                          context,
                                                          listen: false)
                                                      .themeToogle(
                                                          sampleData[index]
                                                                  .buttonText ??
                                                              "1");
                                                  setState(() {
                                                    Provider.of<CustomViewModel>(
                                                            context,
                                                            listen: false)
                                                        .setBottomIndex(1);

                                                    providerListener.vcardData
                                                            .themeSelected =
                                                        sampleData[index]
                                                                .buttonText ??
                                                            "1";
                                                    pop(context);
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  Provider.of<CustomViewModel>(
                                                          context,
                                                          listen: false)
                                                      .setBottomIndex(1);

                                                  providerListener.vcardData
                                                          .themeSelected =
                                                      sampleData[index]
                                                              .buttonText ??
                                                          "1";
                                                  pop(context);
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                Provider.of<CustomViewModel>(
                                                        context,
                                                        listen: false)
                                                    .setBottomIndex(1);

                                                providerListener
                                                        .vcardData.themeSelected =
                                                    sampleData[index]
                                                            .buttonText ??
                                                        "1";
                                                pop(context);
                                              });
                                            }
                                          });
                                        },
                                        child: new RadioItem(
                                            sampleData[index], index),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (index == 0) {
                                            _launchURL(
                                                "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=250");
                                          } else if (index == 1) {
                                            _launchURL(
                                                "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=252");
                                          } else if (index == 2) {
                                            _launchURL(
                                                "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=253");
                                          } else if (index == 3) {
                                            _launchURL(
                                                "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=254");
                                          } else {
                                            _launchURL(
                                                "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=414");
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            children: [
                                              Icon(
                                                FlutterIcons.eye_ant,
                                                size: 30,
                                              ),
                                              Text('Sample')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            )
            : SizedBox(
                width: 1,
              )
        : SizedBox(
            width: 1,
          );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  final int index;

  RadioItem(this._item, this.index);

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    return new Container(
      margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 30.0,
            width: 30.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: GoogleFonts.montserrat(
                      color: providerListener.vcardData.themeSelected ==
                              (index + 1).toString()
                          ? Colors.white
                          : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 14.0)),
            ),
            decoration: new BoxDecoration(
              color: providerListener.vcardData.themeSelected ==
                      (index + 1).toString()
                  ? Color(COLOR_PRIMARY)
                  : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: providerListener.vcardData.themeSelected ==
                          (index + 1).toString()
                      ? Color(COLOR_PRIMARY)
                      : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          new Container(
            width: SizeConfig.screenWidth / 1.6,
            margin: new EdgeInsets.only(left: 15.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  final String buttonText;
  final String text;

  RadioModel(this.buttonText, this.text);
}
