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

class UpdateCurrency extends StatefulWidget {
  final String currency;

  const UpdateCurrency(this.currency);

  @override
  _UpdateCurrencyState createState() => _UpdateCurrencyState();
}

class _UpdateCurrencyState extends State<UpdateCurrency> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController currencyCotroller = TextEditingController();

  Future UpdateCurrency() {
    EasyLoading.show();
    Provider.of<CustomViewModel>(context, listen: false)
        .UpdateCurrency(currencyCotroller.text ?? "")
        .then((value) {
      Provider.of<CustomViewModel>(context, listen: false).getData();
      EasyLoading.dismiss();
      pop(context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currencyCotroller.text = widget.currency;
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(COLOR_BACKGROUND),
          title: commonTitle(context, "Manage Currency"),
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
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: currencyCotroller,
                    validator: (value) {
                      if (value != "") {
                        return null;
                      } else {
                        return "Field required!";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Currency',
                      hintStyle:
                          TextStyle(fontSize: 16, color: Color(COLOR_SUBTITLE)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          UpdateCurrency();
                        } else {
                          commonToast(context, "Please fill required data");
                        }
                      },
                      child: Container(
                        width: 80,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(COLOR_SECONDARY),
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
                              color: Color(COLOR_PRIMARY),
                            ),
                          ),
                        ),
                      ),
                    ),
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
