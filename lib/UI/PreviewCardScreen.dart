import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PreviewCardScreen extends StatefulWidget {
  @override
  _PreviewCardScreenState createState() => _PreviewCardScreenState();
}

class _PreviewCardScreenState extends State<PreviewCardScreen> {
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
          backgroundColor: Colors.white,
          title: commonTitle(context, "FliQCard Preview"),
          elevation: 0,
          centerTitle: false,
          leading: Container(
            child: Icon(
              Icons.remove_red_eye_outlined,
              color: Colors.black,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(right: 20, top: 2),
                child: Icon(
                  Icons.close,
                  size: 25,
                  color: Color(COLOR_PRIMARY),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: WebView(
            initialUrl:
                "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                    (providerListener.userData.id ?? "") +
                    "&preview=1",
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (String url) {
              EasyLoading.show();
              print("*********");
              print(url);
              if (!url.contains("visitcard.php")) {
                commonLaunchURL(
                    "https://fliqcard.com/digitalcard/dashboard/visitcard.php?id=" +
                        (providerListener.userData.id ?? "") +
                        "&preview=1");

                EasyLoading.dismiss();
                pop(context);
              }
            },
            onPageFinished: (String url) {
              EasyLoading.dismiss();
            },
            gestureNavigationEnabled: true,
          ),
        ),
      ),
    );
  }
}
