import 'package:contacts_service/contacts_service.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportFromDeviceScreen extends StatefulWidget {
  @override
  _ImportFromDeviceScreenState createState() => _ImportFromDeviceScreenState();
}

class _ImportFromDeviceScreenState extends State<ImportFromDeviceScreen> {
  bool _isloaded = false;
  bool _isSearchBarOpen = false;
  TextEditingController searchTextController = new TextEditingController();

  FocusNode focusSearch = FocusNode();

  List<Contact> contactsFetchedList = [];
  List<bool> contactsAddedList = [];

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

//Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  Future getNumbers() async {
    try {
      setState(() {
        _isloaded = false;
      });
      contactsFetchedList = await ContactsService.getContacts();

      if (contactsFetchedList.length > 0) {
        for (int c = 0; c < contactsFetchedList.length; c++) {
          contactsAddedList.add(false);
        }
      }

      setState(() {
        _isloaded = true;
      });
    } catch (e) {
      commonToast(context, "Please provide permission or contact admin.");
    }
  }

  Future initTask() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      getNumbers();
    } else {
      commonToast(context,
          "Contacts read permissions required to add contacts to received FliQ from the device.");

      openAppSettings();
      pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    initTask();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 20, top: 10),
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
                        commonTitle(context, "Contacts from device"),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: new CircularProgressIndicator(
                          strokeWidth: 1,
                          backgroundColor: Color(COLOR_PRIMARY),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(COLOR_BACKGROUND)),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                          child: commonTitleSmall(
                              context, "Please wait, fetching contacts...")),
                    ],
                  ),
                )
              : contactsFetchedList.length > 0
                  ? ListView.builder(
                      itemCount: contactsFetchedList.length,
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
                                  Row(
                                    children: [
                                      Container(
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/profile.png"),
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          border: Border.all(
                                            color: Color(COLOR_SECONDARY),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            width: SizeConfig.screenWidth - 180,
                                            child: Text(
                                                contactsFetchedList[index]
                                                        .displayName ??
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
                                          SizedBox(
                                            height: 4,
                                          ),
                                          contactsFetchedList[index].emails ==
                                                  null
                                              ? Container()
                                              : contactsFetchedList[index]
                                                          .emails
                                                          .length ==
                                                      0
                                                  ? Container()
                                                  : Container(
                                                      width: SizeConfig
                                                              .screenWidth -
                                                          180,
                                                      child: Text(
                                                          contactsFetchedList[index]
                                                                  .emails[0]
                                                                  .value ??
                                                              "",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black87))),
                                                    ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          contactsFetchedList[index].phones ==
                                                  null
                                              ? Container()
                                              : contactsFetchedList[index]
                                                          .phones
                                                          .length ==
                                                      0
                                                  ? Container()
                                                  : Container(
                                                      width: SizeConfig
                                                              .screenWidth -
                                                          180,
                                                      child: Text(
                                                          contactsFetchedList[index]
                                                                  .phones[0]
                                                                  .value ??
                                                              "",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .green))),
                                                    ),
                                          Divider()
                                        ],
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          EasyLoading.show();
                                          Provider.of<CustomViewModel>(context,
                                                  listen: false)
                                              .AddContactFromDevice(
                                            contactsFetchedList[index]
                                                    .displayName ??
                                                "",
                                            contactsFetchedList[index].emails ==
                                                    null
                                                ? ""
                                                : contactsFetchedList[index]
                                                            .emails
                                                            .length ==
                                                        0
                                                    ? ""
                                                    : contactsFetchedList[index]
                                                            .emails[0]
                                                            .value ??
                                                        "",
                                            contactsFetchedList[index].phones ==
                                                    null
                                                ? ""
                                                : contactsFetchedList[index]
                                                            .phones
                                                            .length ==
                                                        0
                                                    ? ""
                                                    : (contactsFetchedList[
                                                                index]
                                                            .phones[0]
                                                            .value ??
                                                        ""),
                                            contactsFetchedList[index]
                                                        .company ==
                                                    null
                                                ? ""
                                                : (contactsFetchedList[index]
                                                        .company ??
                                                    ""),
                                          )
                                              .then((value) {
                                            EasyLoading.dismiss();
                                            commonToast(context, value);
                                            setState(() {
                                              contactsAddedList[index] = true;
                                            });
                                          });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: (providerListener
                                                          .contactsListPhonesOnly
                                                          .contains((contactsFetchedList[index]
                                                                          .phones ==
                                                                      null
                                                                  ? "NA"
                                                                  : contactsFetchedList[index]
                                                                              .phones
                                                                              .length ==
                                                                          0
                                                                      ? "NA"
                                                                      : (contactsFetchedList[index].phones[0].value ??
                                                                          "NA")) ??
                                                              "NA") ||
                                                      providerListener
                                                          .contactsListEmailsOnly
                                                          .contains((contactsFetchedList[index]
                                                                          .emails ==
                                                                      null
                                                                  ? "NA"
                                                                  : contactsFetchedList[index]
                                                                              .emails
                                                                              .length ==
                                                                          0
                                                                      ? "NA"
                                                                      : (contactsFetchedList[index]
                                                                              .emails[0]
                                                                              .value ??
                                                                          "NA")) ??
                                                              "NA"))
                                                  ? Colors.green
                                                  : contactsAddedList[index] == true
                                                      ? Colors.green
                                                      : Color(COLOR_PURPLE_PRIMARY),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: (providerListener
                                                            .contactsListPhonesOnly
                                                            .contains((contactsFetchedList[index].phones ==
                                                                        null
                                                                    ? "NA"
                                                                    : contactsFetchedList[index].phones.length ==
                                                                            0
                                                                        ? "NA"
                                                                        : (contactsFetchedList[index].phones[0].value ??
                                                                            "NA")) ??
                                                                "NA") ||
                                                        providerListener
                                                            .contactsListEmailsOnly
                                                            .contains((contactsFetchedList[index].emails ==
                                                                        null
                                                                    ? "NA"
                                                                    : contactsFetchedList[index].emails.length ==
                                                                            0
                                                                        ? "NA"
                                                                        : (contactsFetchedList[index].emails[0].value ??
                                                                            "NA")) ??
                                                                "NA"))
                                                    ? 10
                                                    : contactsAddedList[index] ==
                                                            true
                                                        ? 10
                                                        : 20,
                                                vertical: 5),
                                            child: Text(
                                                (providerListener
                                                            .contactsListPhonesOnly
                                                            .contains((contactsFetchedList[index].phones == null
                                                                    ? "NA"
                                                                    : contactsFetchedList[index].phones.length == 0
                                                                        ? "NA"
                                                                        : (contactsFetchedList[index].phones[0].value ?? "NA")) ??
                                                                "NA") ||
                                                        providerListener.contactsListEmailsOnly.contains((contactsFetchedList[index].emails == null
                                                                ? "NA"
                                                                : contactsFetchedList[index].emails.length == 0
                                                                    ? "NA"
                                                                    : (contactsFetchedList[index].emails[0].value ?? "NA")) ??
                                                            "NA"))
                                                    ? "ADDED"
                                                    : contactsAddedList[index] == true
                                                        ? "ADDED"
                                                        : "ADD",
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        fontSize: (providerListener.contactsListPhonesOnly.contains((contactsFetchedList[index].phones == null
                                                                        ? "NA"
                                                                        : contactsFetchedList[index].phones.length == 0
                                                                            ? "NA"
                                                                            : (contactsFetchedList[index].phones[0].value ?? "NA")) ??
                                                                    "NA") ||
                                                                providerListener.contactsListEmailsOnly.contains(contactsFetchedList[index].emails == null
                                                                    ? "NA"
                                                                    : contactsFetchedList[index].emails.length == 0
                                                                        ? "NA"
                                                                        : (contactsFetchedList[index].emails[0].value ?? "NA") ?? "NA"))
                                                            ? 13
                                                            : contactsAddedList[index] == true
                                                                ? 13
                                                                : 14.0,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white)))),
                                      ),
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
