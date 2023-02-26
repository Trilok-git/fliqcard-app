import 'package:country_picker/country_picker.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Models/CountriesListParser.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

String category_name = "Work";

class UpdateContactScreen extends StatefulWidget {
  final index, id, tags, notes, category, phone;

  UpdateContactScreen(
      this.index, this.id, this.tags, this.notes, this.category, this.phone);

  @override
  _UpdateContactScreenState createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController tagsController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  String country1 = "+1";

  Future UpdateContact() async {
    Provider.of<CustomViewModel>(context, listen: false)
        .UpdateContact(
            widget.index,
            widget.id,
            tagsController.text.toString(),
            notesController.text.toString(),
            category_name ?? "",
            (country1) + "" + (phoneController.text ?? "").replaceAll(" ", ""))
        .then((value) {
      setState(() {
        Provider.of<CustomViewModel>(context, listen: false)
            .getLatestContacts()
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
      tagsController.text = widget.tags ?? "";

      notesController.text = widget.notes ?? "";
      category_name = widget.category ?? "";
      if ((widget.phone ?? "").contains("+")) {
        country1 = "+1";

        print(widget.phone);
        for (int a = 0; a < asdf.length; a++) {
          print(asdf[a][1]);
          if ((widget.phone ?? "").toString().contains(
              CountriesListParser.fromJson(asdf[a]).dialCode ?? "NA")) {
            country1 = CountriesListParser.fromJson(asdf[a]).dialCode ?? "+91";
          }
        }
        if (country1.isNotEmpty) {
          phoneController.text =
              (widget.phone ?? "").toString().replaceAll(country1, "");
        }
      } else {
        phoneController.text = (widget.phone ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(COLOR_BACKGROUND),
          appBar: AppBar(
            backgroundColor: Color(COLOR_PRIMARY),
            title: commonTitleSmallWhite(context, "Manage Contact"),
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
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      commonTitle(context, "Category"),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 50,
                        decoration: ShapeDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Padding(
                              child: commonTitle(context, category_name),
                              padding: EdgeInsets.only(left: 15, top: 5),
                            ),
                            items: <String>[
                              'Client',
                              'Family',
                              'Friend',
                              'Business',
                              'Vendor',
                              'Other'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                category_name = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      commonTitleSmall(context,
                          "Phone (Make Sure number is valid and does not contain unnecessary characters like 0, -, (,)"),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          // for below version 2 use this
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value != "") {
                            return null;
                          } else {
                            return "Field required!";
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            width: 70,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    countryListTheme: CountryListThemeData(
                                      flagSize: 25,
                                      backgroundColor: Color(COLOR_BACKGROUND),
                                      textStyle: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      //Optional. Sets the border radius for the bottomsheet.
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                      //Optional. Styles the search field.

                                      inputDecoration: InputDecoration(
                                        labelText: 'Search',
                                        labelStyle: TextStyle(
                                            color: Color(COLOR_PRIMARY)),
                                        hintStyle: TextStyle(
                                            color: Color(COLOR_PRIMARY)),
                                        hintText: 'Start typing to search',
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Color(COLOR_PRIMARY),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          borderSide: BorderSide(
                                              color: Color(COLOR_PRIMARY)),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color(COLOR_PRIMARY)
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 1, vertical: 1),
                                      ),
                                    ),
                                    onSelect: (Country OBJ) {
                                      setState(() {
                                        country1 = "+" +
                                            (OBJ.phoneCode ?? 1).toString();
                                      });
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                      child: Text(
                                    (country1).toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(COLOR_PRIMARY),
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                              ),
                            ),
                          ),
                          hintText: 'Primary Phone Number',
                          hintStyle: TextStyle(
                              fontSize: 16, color: Color(COLOR_SUBTITLE)),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      commonTitleSmall(
                          context,
                          providerListener.memberShip != null
                              ? "Tags (comma separated values)"
                              : "Tags (go premium for tags)"),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly:
                            providerListener.memberShip != null ? false : true,
                        controller: tagsController,
                        minLines: 3,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: TextStyle(
                              fontSize: 16, color: Color(COLOR_SUBTITLE)),
                          filled: true,
                          fillColor: providerListener.memberShip == null
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.1),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 15),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      commonTitleSmall(
                          context,
                          providerListener.memberShip != null
                              ? "Notes"
                              : "Notes (go premium for Notes)"),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly:
                            providerListener.memberShip != null ? false : true,
                        controller: notesController,
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: TextStyle(
                              fontSize: 16, color: Color(COLOR_SUBTITLE)),
                          filled: true,
                          fillColor: providerListener.memberShip == null
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.1),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        onTap: () {
                          EasyLoading.show(status: 'loading...');

                          UpdateContact();
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(COLOR_PURPLE_PRIMARY),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Save",
                              style: GoogleFonts.montserrat(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
