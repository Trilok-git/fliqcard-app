import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

BuildContext parentContext;


void _launchURL(String _url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

class DetailScreen extends StatefulWidget {
  final String imagePath;

  DetailScreen(this.imagePath);

  @override
  _DetailScreenState createState() => new _DetailScreenState(imagePath);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.path);

  final String path;

  bool isLoaded = false;
  String recognizedText = "Loading ...";

  List<String> recognizedFieldsList = [];

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();

  PageController controller = PageController();
   TextDetector _textDetector;


  bool isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  int currentStep = 0;
  int selectedFieldIndex = -1;

  void _initializeVision() async {
   /* final File imageFile = File(path);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }*/

    _textDetector = GoogleMlKit.vision.textDetector();

    final inputImage = InputImage.fromFilePath(path);
// Retrieving the RecognisedText from the InputImage
    final text = await _textDetector.processImage(inputImage);



    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regEx = RegExp(pattern);

    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        print("a");
        /*   if (regEx.hasMatch(line.text)) {
          mailAddress += line.text + '\n';
          for (TextElement element in line.elements) {
            _elements.add(element);
          }
        }
       */
        setState(() {
          if ((line.text ?? "").isNotEmpty &&
              (line.text ?? "").replaceAll(" ", "").isNotEmpty) {
            recognizedFieldsList.add((line.text ?? ""));
          }
        });
      }
    }

    setState(() {
      isLoaded = true;
    });
    
  }



  getSelectTitle() {
    switch (currentStep) {
      case 0:
        return "Select Name";
        break;
      case 1:
        return "Select Email";
        break;
      case 2:
        return "Select Phone";
        break;
      case 3:
        return "Select Company";
        break;
      default:
        return "Select Name";
        break;
    }
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textDetector.close();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      parentContext = context;
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 20,
              color: Color(COLOR_TITLE),
            ),
          ),
          title: Text(
            "Manage Fields",
            style: GoogleFonts.montserrat(
              color: Color(COLOR_PRIMARY),
            ),
          ),
          backgroundColor: Color(COLOR_BACKGROUND),
        ),
        body: isLoaded != false
            ? SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 1,
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Color(COLOR_SECONDARY),
                                          child: Text(
                                            "1",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Color(COLOR_PRIMARY),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Name",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Color(COLOR_PRIMARY),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 3,
                                        color: Colors.black,
                                        width: SizeConfig.screenWidth / 6,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: currentStep > 0
                                              ? Color(COLOR_SECONDARY)
                                              : Colors.grey,
                                          child: Text(
                                            "2",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: currentStep > 0
                                                  ? Color(COLOR_PRIMARY)
                                                  : Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Email",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Color(COLOR_PRIMARY),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  currentStep > 0
                                      ? Container(
                                          height: 3,
                                          color: Colors.black,
                                          width: SizeConfig.screenWidth / 6,
                                        )
                                      : Container()
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: currentStep > 1
                                              ? Color(COLOR_SECONDARY)
                                              : Colors.grey,
                                          child: Text(
                                            "3",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: currentStep > 1
                                                  ? Color(COLOR_PRIMARY)
                                                  : Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Phone",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Color(COLOR_PRIMARY),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  currentStep > 1
                                      ? Container(
                                          height: 3,
                                          color: Colors.black,
                                          width: SizeConfig.screenWidth / 6,
                                        )
                                      : Container()
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: currentStep > 2
                                              ? Color(COLOR_SECONDARY)
                                              : Colors.grey,
                                          child: Text(
                                            "4",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: currentStep > 2
                                                  ? Color(COLOR_PRIMARY)
                                                  : Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Company",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Color(COLOR_PRIMARY),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  currentStep > 2
                                      ? Container(
                                          height: 3,
                                          color: Colors.black,
                                          width: SizeConfig.screenWidth / 6,
                                        )
                                      : Container()
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 25, bottom: 10),
                                  child: Text(
                                    getSelectTitle(),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      color: Color(COLOR_PRIMARY),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 0, bottom: 5),
                                  child: Text(
                                    getSelectTitle() +
                                        " to proceed to next steps",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      color: Color(COLOR_PRIMARY),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 0, bottom: 5),
                                  child: Text(
                                    "Tap field from list",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  child: PageView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: nameController,
                                          maxLines: 4,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 14),
                                          validator: (email) {
                                            if (email != "") {
                                              return null;
                                            } else {
                                              return "Name required";
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                'Tap any fields from the list',
                                            suffixIcon: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    nameController.clear();
                                                  });
                                                },
                                                child: Icon(Icons.clear)),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w600),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey, width: 0.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(COLOR_PRIMARY),
                                                  width: 0.5),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: emailController,
                                          maxLines: 4,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 14),
                                          validator: (email) {
                                            if (email != "") {
                                              if (isEmailValid(email)) {
                                                return null;
                                              } else
                                                return "Invalid email address";
                                            } else {
                                              return "Invalid email address";
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                'Tap any fields from the list',
                                            suffixIcon: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    emailController.clear();
                                                  });
                                                },
                                                child: Icon(Icons.clear)),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w600),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey, width: 0.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(COLOR_PRIMARY),
                                                  width: 0.5),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: phoneController,
                                          maxLines: 4,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 14),
                                          validator: (email) {
                                            if (email != "") {
                                              return null;
                                            } else {
                                              return "Phone required";
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                'Tap any fields from the list',
                                            suffixIcon: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    phoneController.clear();
                                                  });
                                                },
                                                child: Icon(Icons.clear)),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w600),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey, width: 0.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(COLOR_PRIMARY),
                                                  width: 0.5),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: companyController,
                                          maxLines: 4,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 14),
                                          validator: (email) {
                                            if (email != "") {
                                              return null;
                                            } else {
                                              return "Company required";
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                'Tap any fields from the list',
                                            suffixIcon: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    companyController.clear();
                                                  });
                                                },
                                                child: Icon(Icons.clear)),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w600),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey, width: 0.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(COLOR_PRIMARY),
                                                  width: 0.5),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
                                          ),
                                        ),
                                      )
                                    ],
                                    scrollDirection: Axis.horizontal,

                                    // reverse: true,
                                    // physics: BouncingScrollPhysics(),
                                    controller: controller,
                                    onPageChanged: (num) {
                                      setState(() {
                                        currentStep = num;
                                      });
                                    },
                                  ),
                                ),
                                currentStep == 3
                                    ? Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Container(
                                              width: SizeConfig.screenWidth / 1.2,
                                              child: Text(
                                                "Card will be save to received fliq and address book",
                                                textAlign: TextAlign.end,
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.green),
                                              )),
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      currentStep == 0
                                          ? Container()
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedFieldIndex = -1;
                                                  controller.animateToPage(
                                                      currentStep - 1,
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeIn);
                                                });
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2.0),
                                                ),
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 2,
                                                          vertical: 3),
                                                  child: Container(
                                                    width:
                                                        SizeConfig.screenWidth /
                                                            3,
                                                    child: Center(
                                                      child: Text(
                                                        "BACK",
                                                        style: GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                COLOR_PRIMARY),
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      currentStep == 3
                                          ? InkWell(
                                              onTap: () {
                                                EasyLoading.show();
                                                Provider.of<CustomViewModel>(
                                                    parentContext,
                                                        listen: false)
                                                    .AddPaperScanToReceive(
                                                        nameController.text,
                                                        emailController.text,
                                                        phoneController.text,
                                                        companyController.text)
                                                    .then((value) {
                                                  EasyLoading.dismiss();
                                                  pop(context);
                                                  _launchURL(apiUrl +
                                                      "/../paperScanVcf.php?name=" +
                                                      (nameController.text ??
                                                          "") +
                                                      "&email=" +
                                                      (emailController.text ??
                                                          "") +
                                                      "&phone=" +
                                                      (phoneController.text ??
                                                          "") +
                                                      "&company=" +
                                                      (companyController.text ??
                                                          ""));
                                                });
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2.0),
                                                ),
                                                color: Color(COLOR_SECONDARY),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 2,
                                                          vertical: 3),
                                                  child: Container(
                                                    width:
                                                        SizeConfig.screenWidth /
                                                            3,
                                                    child: Center(
                                                      child: Text(
                                                        "SAVE",
                                                        style: GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                COLOR_PRIMARY),
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                bool isStepValid = false;
                                                var errorMessage = "";
                                                if (currentStep == 0) {
                                                  if (nameController
                                                      .text.isNotEmpty) {
                                                    setState(() {
                                                      isStepValid = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      errorMessage =
                                                          "Invalid Name";
                                                      isStepValid = false;
                                                    });
                                                  }
                                                } else if (currentStep == 1) {
                                                  if (isEmailValid(
                                                      emailController.text)) {
                                                    setState(() {
                                                      isStepValid = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      errorMessage =
                                                          "Invalid email";
                                                      isStepValid = false;
                                                    });
                                                  }
                                                } else if (currentStep == 2) {
                                                  if (phoneController
                                                          .text.isNotEmpty &&
                                                      phoneController.text
                                                          .replaceAll(" ", "")
                                                          .isNotEmpty) {
                                                    setState(() {
                                                      phoneController.text
                                                          .replaceAll("+", "");
                                                      phoneController.text
                                                          .replaceAll("(", "");
                                                      phoneController.text
                                                          .replaceAll(")", "");
                                                      phoneController.text
                                                          .replaceAll("-", "");
                                                      isStepValid = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      errorMessage =
                                                          "Invalid Phone Number";
                                                      isStepValid = false;
                                                    });
                                                  }
                                                } else {
                                                  // Compnay name not required
                                                }
                                                if (isStepValid) {
                                                  setState(() {
                                                    selectedFieldIndex = -1;
                                                    controller.animateToPage(
                                                        currentStep + 1,
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.easeIn);
                                                  });
                                                } else {
                                                  commonToast(
                                                      context, errorMessage);
                                                }
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(2.0),
                                                ),
                                                color: Color(COLOR_PRIMARY),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 2,
                                                          vertical: 3),
                                                  child: Container(
                                                    width:
                                                        SizeConfig.screenWidth /
                                                            3,
                                                    child: Center(
                                                      child: Text(
                                                        "NEXT",
                                                        style: GoogleFonts.montserrat(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    Colors.white,
                                                                fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                           // height: SizeConfig.screenHeight / 1.5,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: recognizedFieldsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedFieldIndex = index;
                                        if (currentStep == 0) {
                                          nameController.text =
                                              recognizedFieldsList[index];
                                        } else if (currentStep == 1) {
                                          emailController.text =
                                              recognizedFieldsList[index];
                                        } else if (currentStep == 2) {
                                          phoneController.text =
                                              recognizedFieldsList[index];
                                        } else {
                                          companyController.text =
                                              recognizedFieldsList[index];
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 2),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                        ),
                                        color: Colors.white,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          child: Row(
                                            children: [
                                              Container(
                                                width:
                                                    SizeConfig.screenWidth / 1.5,
                                                child: Text(
                                                  recognizedFieldsList[index],
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.w400,
                                                      color: Color(COLOR_PRIMARY),
                                                      fontSize: 15),
                                                ),
                                              ),
                                              Icon(
                                                selectedFieldIndex == index
                                                    ? Icons.check_circle
                                                    : Icons
                                                        .radio_button_unchecked,
                                                color: Color(COLOR_PRIMARY),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
