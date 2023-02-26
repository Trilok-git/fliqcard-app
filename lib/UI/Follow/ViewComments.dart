import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewComments extends StatefulWidget {
  final email;

  ViewComments(this.email);

  @override
  _ViewCommentsState createState() => _ViewCommentsState();
}

class _ViewCommentsState extends State<ViewComments> {
  bool _isloaded = false;
  bool _isSearchBarOpen = false;
  TextEditingController searchTextController = new TextEditingController();

  FocusNode focusSearch = FocusNode();

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future getComments() async {
    setState(() {
      _isloaded = false;
    });
    print(widget.email);
    Provider.of<CustomViewModel>(context, listen: false)
        .getComments(widget.email)
        .then((value) {
      setState(() {
        _isloaded = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 20, top: 20),
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
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Color(COLOR_PRIMARY),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        commonTitle(context, "Comments"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: Color(COLOR_BACKGROUND),
          width: double.infinity,
          child: _isloaded == false
              ? Container(
                  height: SizeConfig.screenHeight / 2,
                  child: Center(
                    child: new CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: Color(COLOR_PRIMARY),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(COLOR_BACKGROUND)),
                    ),
                  ),
                )
              : providerListener.commentsList.length > 0
                  ? ListView.builder(
                      itemCount: providerListener.commentsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Color(COLOR_BACKGROUND),
                              elevation: 0,
                              child: Stack(
                                children: [
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Container(
                                            width: SizeConfig.screenWidth - 80,
                                            child: Text(
                                                providerListener
                                                        .commentsList[index]
                                                        .description ??
                                                    "",
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.black87))),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    providerListener
                                                            .commentsList[index]
                                                            .createdAt ??
                                                        "",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  ),
                                ],
                              )),
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

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 10.0,
      width: 10.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
