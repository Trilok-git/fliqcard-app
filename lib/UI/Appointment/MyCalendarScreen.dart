import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Appointment/ListOfAppointment.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:fliqcard/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapclip_pageview/snapclip_pageview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fliqcard/UI/Appointment/SlotsByDate.dart';

SharedPreferences prefs;

class MyCalendarScreen extends StatefulWidget {
  final url;

  MyCalendarScreen(this.url);

  @override
  _MyCalendarScreenState createState() => _MyCalendarScreenState();
}

class _MyCalendarScreenState extends State<MyCalendarScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: AppBar(
          backgroundColor: Color(COLOR_PRIMARY),
          title: commonTitleSmallBoldWhite(context, "My Calendar"),
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
        //TODO
        body: Container(
          child: WebView(
            initialUrl: widget.url ?? "",
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (String url) {
              print('Page started loading: $url');
              EasyLoading.show();
              if (url != null) {
                if (url ==
                    "https://fliqcard.com/digitalcard/dashboard/appointment.php" || url ==
                    "https://fliqcard.com/digitalcard/login.php") {
                  pushReplacement(context, ListOfAppointment());
                } else {
                  EasyLoading.dismiss();
                }
              }
            },
            onPageFinished: (String url) {
              EasyLoading.dismiss();
            },
          ),
        ),
      ),
    );
  }
}
