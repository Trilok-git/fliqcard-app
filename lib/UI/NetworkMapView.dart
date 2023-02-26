import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NetworkMapView extends StatefulWidget {
  @override
  _NetworkMapViewState createState() => _NetworkMapViewState();
}

class _NetworkMapViewState extends State<NetworkMapView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Stack(
      children: [
        Image.asset(
          "assets/map_placeholder.png",
          height: 200,
          width: SizeConfig.screenWidth,
        ),
        Container(
          height: 200,
          color: Colors.transparent,
          width: SizeConfig.screenWidth,
          child: WebView(
            initialUrl: "https://fliqcard.com/networks_map.php?email=" +
                (providerListener.userData.email ?? ""),
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (String url) {
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
                });
              }
            },
            onPageFinished: (String url) {},
            gestureNavigationEnabled: true,
          ),
        ),
      ],
    );
  }
}
