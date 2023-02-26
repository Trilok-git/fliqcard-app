import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
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

class ShareAppointment extends StatefulWidget {
  final url, title;

  ShareAppointment(this.url, this.title);

  @override
  _ShareAppointmentState createState() => _ShareAppointmentState();
}

class _ShareAppointmentState extends State<ShareAppointment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(COLOR_PRIMARY),
          title: commonTitleSmallWhite(context, "SHARE WITH FliQCard USERS: " + widget.title),
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
          color: Color(COLOR_BACKGROUND),
          child: WebView(
            initialUrl: widget.url ?? "",
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (String url) {
              EasyLoading.show();
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              if (url != null) {
                if (url ==
                    "https://fliqcard.com/digitalcard/dashboard/shareAppointment.php") {
                  Provider.of<CustomViewModel>(context, listen: false)
                      .getAllappointment()
                      .then((value) {
                    EasyLoading.dismiss();

                    pop(context);
                  });
                } else {
                  EasyLoading.dismiss();
                }
              } else {
                EasyLoading.dismiss();
              }

              print('Page finished loading: $url');
            },
          ),
        ),
      ),
    );
  }
}
