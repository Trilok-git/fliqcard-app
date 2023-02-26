import 'dart:io';

import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/MainScreen.dart';
import 'package:fliqcard/UI/Pricing/PricingScreen.dart';
import 'package:fliqcard/UI/Staff/StaffListScreen.dart';
import 'package:fliqcard/UI/Themes/ThemeSelector.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEditPaymentOptions extends StatefulWidget {
  String id, user_id, title, link, description, imagePath;
  int index;

  AddEditPaymentOptions(this.id, this.index, this.title, this.link, this.description,
      this.imagePath);

  @override
  _AddEditPaymentOptionsState createState() => _AddEditPaymentOptionsState();
}

class _AddEditPaymentOptionsState extends State<AddEditPaymentOptions> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleCotroller = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController linkCotroller = TextEditingController();

  var errorMessage = "";
  int myVar = 0;

  File imageFile;

  final picker = ImagePicker();

  Future _pickImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          imageFile = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }



  Future saveCard(String operation) {
    Provider.of<CustomViewModel>(context, listen: false)
        .AddEditPaymentOptions(
        operation,
        widget.id,
        titleCotroller.text ?? "",
        linkCotroller.text ?? "",
        descController.text ?? "",
        imageFile)
        .then((value) {
      setState(() {
        Provider.of<CustomViewModel>(context, listen: false)
            .allPaymentOptions()
            .then((value) {
          EasyLoading.dismiss();
          pop(context);
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      titleCotroller.text = widget.title;
      linkCotroller.text = widget.link;
      descController.text = widget.description;
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        appBar: AppBar(
          backgroundColor: Color(COLOR_BACKGROUND),
          title: commonTitle(context, "Manage Payment"),
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
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      errorMessage = "";
                    });
                    if (widget.id != null) {
                      EasyLoading.show(status: 'loading...');
                      saveCard("save");
                    } else {
                      EasyLoading.show(status: 'loading...');
                      saveCard("add");
                    }
                  } else {
                    //  commonToast(context, "Please fill required data");
                    setState(() {
                      errorMessage = "Please fill required data";
                    });
                  }
                },
                child: Container(
                  width: 80,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(COLOR_PRIMARY),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(COLOR_SECONDARY).withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Save ",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  (errorMessage ?? "").toString()==""?Container(): Container(
                    width: SizeConfig.screenWidth,
                    child: Text(
                      errorMessage ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: titleCotroller,
                    validator: (value) {
                      if (value != "") {
                        return null;
                      } else {
                        return "Field required!";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle:
                      TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),

                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: linkCotroller,
                    validator: (value) {
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'link',
                      hintStyle:
                      TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),

                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: descController,
                    maxLines: 5,
                    validator: (value) {
                      if (value != "") {
                        return null;
                      } else {
                        return "Field required!";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle:
                      TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),

                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonTitleSmall(
                          context, "Image Only, recommended 512 X 512, 1:1"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              _pickImage();
                            },
                            child: Text("Upload Image"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 200,
                            child: Column(
                              children: [
                                imageFile != null
                                    ? commonTitleSmall(context,
                                    imageFile.path.split("/").last ?? "")
                                    : SizedBox(
                                  width: 1,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            imageFile == null
                                ? widget.imagePath != null
                                ? widget.imagePath != ""
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(

                                    image: DecorationImage(
                                      image: NetworkImage(apiUrl +
                                          "../../" +
                                          widget.imagePath),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)),
                                    border: Border.all(
                                      color: Color(int.parse(
                                          providerListener
                                              .vcardData.fontcolor
                                              .replaceAll(
                                              "#", "0xff"))),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                              ],
                            )
                                : SizedBox(
                              height: 1,
                            )
                                : SizedBox(
                              height: 1,
                            )
                                : Container(
                              width: 60,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(imageFile),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            widget.id != null &&
                                (imageFile != null || widget.imagePath != "")
                                ? InkWell(
                              onTap: () {
                                Provider.of<CustomViewModel>(context,
                                    listen: false)
                                    .deletePaymentOptionImage(widget.id)
                                    .then((value) {
                                  setState(() {
                                    widget.imagePath = "";
                                    imageFile = null;
                                    providerListener
                                        .paymentOptionsList[widget.index]
                                        .imagePath = "";
                                  });
                                });
                              },
                              child: Container(
                                height: 30,
                                padding:
                                EdgeInsets.only(left: 20, right: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(COLOR_SECONDARY)
                                          .withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Remove",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
