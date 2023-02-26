import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/UI/Staff/AddEditStaff.dart';
import 'package:fliqcard/UI/Themes/Ecom/Service/AddEditService.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class AllOrdersListScreen extends StatefulWidget {
  @override
  _AllOrdersListScreenState createState() => _AllOrdersListScreenState();
}

class _AllOrdersListScreenState extends State<AllOrdersListScreen> {
  bool _enabled = true;

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future initTask() {
    Provider.of<CustomViewModel>(context, listen: false)
        .allOrders()
        .then((value) {
      setState(() {
        _enabled = false;
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTask();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: AppBar(
          backgroundColor: Color(COLOR_PRIMARY),
          title: Text("Received Orders",
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white))) ,
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
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: _enabled == true
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: _enabled,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          itemCount: 6,
                        ),
                      ),
                    )
                  ],
                )
              : providerListener.productEnquiryList.length > 0
                  ? ListView.builder(
                      itemCount: providerListener.productEnquiryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0,
                          color: Color(COLOR_BACKGROUND),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                minLeadingWidth: 20,
                                leading: Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      image: AssetImage("assets/profile.png"),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        providerListener
                                                .productEnquiryList[index].name ??
                                            "",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Color(COLOR_PRIMARY))),
                                    SizedBox(height: 3),
                                    Text(
                                       providerListener.productEnquiryList[index]
                                                .orderId ??
                                            "",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(COLOR_TITLE))),

                                  ],
                                ),
                                subtitle: Text((providerListener
                                        .productEnquiryList[index].message ??
                                    "")),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (providerListener
                                          .productEnquiryList[index].updatedAt ??
                                          ""),
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color(COLOR_TITLE),
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        _launchURL((apiUrl +
                                            "/../../cart.php?id=" +
                                            (providerListener.userData.id ?? "")+"&order_id="+(providerListener.productEnquiryList[index].orderId)+"&hide=yes"));
                                      },
                                      child: Text(
                                        "View Details",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          color: Color(COLOR_PRIMARY),
                                          decoration: TextDecoration.underline
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(left: 15, right: 5),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                  : Container(
                      margin: EdgeInsets.only(bottom: 0),
                      child: Center(
                          child: commonTitle(context, "No results Found!"))),
        ),
      ),
    );
  }
}
