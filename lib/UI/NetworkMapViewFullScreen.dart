import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NetworkMapViewFullScreen extends StatefulWidget {
  @override
  _NetworkMapViewFullScreenState createState() =>
      _NetworkMapViewFullScreenState();
}

class _NetworkMapViewFullScreenState extends State<NetworkMapViewFullScreen> {
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
          title: commonTitle(context, "Networks"),
          elevation: 0,
          centerTitle: false,
          leading: Container(
            child: Icon(
              Icons.people,
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
          initialUrl: "https://fliqcard.com/networks_map.php?email=" +
              (providerListener.userData.email ?? ""),
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (String url) {
            EasyLoading.show();

            if (url.contains("codes=")) {
              Uri myurl = Uri.parse(url); //get complete url
              String codes = myurl.queryParameters["codes"];
              codes = codes.replaceAll("+", "");
              codes = codes.replaceAll(" ", "");
              print(codes);
              String names = myurl.queryParameters["names"];
              EasyLoading.show();
              Provider.of<CustomViewModel>(context, listen: false)
                  .setCountryCodeFilter("+" + codes, names, "All")
                  .then((value) {
                EasyLoading.dismiss();
                Provider.of<CustomViewModel>(context, listen: false)
                    .setBottomIndex(2);
                pop(context);
              });
            }
          },
          onPageFinished: (String url) {
            EasyLoading.dismiss();
          },
          gestureNavigationEnabled: true,
        )),
      ),
    );
  }
}
