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

class ServicesListScreen extends StatefulWidget {
  @override
  _ServicesListScreenState createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  bool _enabled = true;

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future initTask() {
    Provider.of<CustomViewModel>(context, listen: false)
        .allServices()
        .then((value) {
      setState(() {
        _enabled = false;
      });
    });
  }

  Future DeletService(id, index) {
    Provider.of<CustomViewModel>(context, listen: false)
        .DeletService(id, index)
        .then((value) {
      setState(() {
        setState(() {
          _enabled = false;
        });
        if (value == "success") {
          commonToast(context, value);
        } else {
          commonToast(context, value);
        }
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
          backgroundColor: Color(COLOR_BACKGROUND),
          title: commonTitle(context, "All Services"),
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
          actions: [
            InkWell(
              onTap: () {
                // id, index = nulll
                push(context, AddEditService(null, null, "", "", "", ""));
              },
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Icon(
                    Icons.add,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                _launchURL((apiUrl +
                    "/../../services.php?id=" +
                    (providerListener.userData.id ?? "")));
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
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
              : providerListener.servicesList.length > 0
                  ? ListView.builder(
                      itemCount: providerListener.servicesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(

                          color: Color(0xffE3E8FF),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                          providerListener
                                                  .servicesList[index].title ??
                                              "",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color(COLOR_TITLE))),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text((providerListener
                                            .servicesList[index].description ??
                                        "")),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        push(
                                            context,
                                            AddEditService(
                                                providerListener
                                                    .servicesList[index].id,
                                                index,
                                                providerListener.servicesList[index]
                                                        .title ??
                                                    "",
                                                providerListener.servicesList[index]
                                                        .description ??
                                                    "",
                                                providerListener.servicesList[index]
                                                        .imagePath ??
                                                    "",
                                                providerListener.servicesList[index]
                                                        .videoPath ??
                                                    ""));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.edit_outlined,
                                        ),
                                      ),
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


                                                      setState(() {
                                                        _enabled = true;
                                                      });
                                                      DeletService(
                                                          providerListener.servicesList[index].id,
                                                          index);

                                                      Navigator.of(context).pop();



                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.delete_outline,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
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
