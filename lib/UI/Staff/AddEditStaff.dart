import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/UI/GoPremiumWidget.dart';
import 'package:fliqcard/UI/MainScreen.dart';
import 'package:fliqcard/UI/Staff/StaffListScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'AddEditPosition.dart';

class AddEditStaff extends StatefulWidget {
  final id, fullname, department, phone, email;

  AddEditStaff(this.id, this.fullname, this.department, this.phone, this.email);

  @override
  _AddEditStaffState createState() => _AddEditStaffState();
}

class _AddEditStaffState extends State<AddEditStaff> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<String> positionStringList = [];
  String selectedPosition = "";

  Future getPosition() {
    Provider.of<CustomViewModel>(context, listen: false)
        .getPosition()
        .then((value) {

          EasyLoading.dismiss();
          print(value);
          print(Provider.of<CustomViewModel>(context, listen: false).positionList);
          print("helllll");
      // Provider.of<CustomViewModel>(context, listen: false).positionOptions.clear();
          positionStringList.clear();
          print(positionStringList);
      Provider.of<CustomViewModel>(context, listen: false).positionList.forEach((element) {
        // Provider.of<CustomViewModel>(context, listen: false).positionOptions.add(element['position']);
        positionStringList.add(element['position']);
      });
      print(positionStringList);
        selectedPosition = positionStringList.first;

    });
  }

  Future updateStaff() {
    Provider.of<CustomViewModel>(context, listen: false)
        .updateStaff(
      widget.id,
      fullnameController.text,
      departmentController.text,
      positionController.text,
      phoneController.text,
      emailController.text,
      passwordController.text,
    )
        .then((value) {
      setState(() {
        EasyLoading.dismiss();
        if (value == "success") {
          pushReplacement(context, StaffListScreen());
          commonToast(context, "Contact Saved");
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
    EasyLoading.show;

    getPosition();

    setState(() {
      fullnameController.text = widget.fullname;
      departmentController.text = widget.department;
      phoneController.text = widget.phone;
      emailController.text = widget.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(COLOR_PRIMARY),
          title: commonTitleSmallWhite(context, "Manage Staff Account"),
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
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> AddEditPosition()))
                    .then((value) {
                      print(value);
                      getPosition();
                    });

                // push(context, AddEditPosition()).then((value){
                //   print(value);
                //   print("yoooooooooooooo");
                //   getPosition();
                // });
              },
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  commonTitleSmallBoldWhite(context, 'Add Position'),
                  SizedBox(width: 10),
                ],
              )
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: providerListener.memberShip != null
                ? (widget.id == "0" &&
                        providerListener.memberShip.plan == "EXECUTIVE" &&
                        providerListener.staffList.length > 2)
                    ? Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: commonTitleSmall(
                              context, "Go premium to add more staffs!"),
                        ),
                        GoPremiumWidget(context, 2),
                      ])
                    : (widget.id == "0" &&
                            providerListener.memberShip.plan == "ECOMMERCE" &&
                            providerListener.staffList.length > 2)
                        ? Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: commonTitleSmall(
                                  context, "Go premium to add more staffs!"),
                            ),
                            GoPremiumWidget(context, 2),
                          ])
                        : (widget.id == "0" &&
                                providerListener.memberShip.plan == "CORPORATE" &&
                                providerListener.staffList.length > 24)
                            ? Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: commonTitleSmall(
                                      context, "Go premium to add more staffs!"),
                                ),
                                GoPremiumWidget(context, 2),
                              ])
                            : (widget.id == "0" &&
                                    providerListener.memberShip.plan ==
                                        "CORPORATE PLUS" &&
                                    providerListener.staffList.length >=
                                        int.parse(providerListener
                                                .memberShip.staffCount ??
                                            "0"))
                                ? Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: commonTitleSmall(context,
                                          "Go premium to add more staffs!"),
                                    ),
                                    GoPremiumWidget(context, 2),
                                  ])
                                : Column(
                                  children: [

                                    // commonTitleSmall(context,"Add Position"),

                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              controller: fullnameController,
                                              decoration: InputDecoration(
                                                hintText: 'Full Name',
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(COLOR_SUBTITLE)),
                                                filled: true,
                                                fillColor:
                                                    Colors.grey.withOpacity(0.1),
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              controller: departmentController,
                                              decoration: InputDecoration(
                                                hintText: 'Department',
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(COLOR_SUBTITLE)),
                                                filled: true,
                                                fillColor:
                                                    Colors.grey.withOpacity(0.1),
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            DropdownButton(
                                              value: selectedPosition,
                                              icon: const Icon(Icons.arrow_downward),
                                              elevation: 16,
                                              iconSize: 20,
                                              style: const TextStyle(color: Colors.black, fontSize: 16),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (value) {
                                                print(value);

                                                setState(() {
                                                  selectedPosition = value;
                                                  // providerListener.selectedPosition = value;
                                                });

                                                print(providerListener.selectedPosition);
                                                // Provider.of<CustomViewModel>(context, listen: false)
                                                //     .selectedPosition = value;
                                              },
                                              items: positionStringList.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                    child: Text(value[0].toUpperCase()+value.substring(1).toLowerCase()),
                                                  ),
                                                );
                                              }).toList(),


                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              controller: phoneController,
                                              maxLength: 15,
                                              decoration: InputDecoration(
                                                hintText: 'Phone Number',
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(COLOR_SUBTITLE)),
                                                filled: true,
                                                fillColor:
                                                    Colors.grey.withOpacity(0.1),
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              readOnly:
                                                  widget.id == "0" ? false : true,
                                              controller: emailController,
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
                                              maxLength: 40,
                                              decoration: InputDecoration(
                                                hintText: 'Email',
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(COLOR_SUBTITLE)),
                                                filled: true,
                                                fillColor: widget.id == "0"
                                                    ? Colors.grey.withOpacity(0.1)
                                                    : Colors.grey.withOpacity(0.7),
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              controller: passwordController,
                                              validator: (password) {
                                                if (password != "" &&
                                                    password.length > 5) {
                                                  return null;
                                                } else {
                                                  return "Password must be 6 digits or more";
                                                }
                                              },
                                              maxLength: 20,
                                              decoration: InputDecoration(
                                                hintText: 'Password',
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(COLOR_SUBTITLE)),
                                                filled: true,
                                                fillColor:
                                                    Colors.grey.withOpacity(0.1),
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  EasyLoading.show(
                                                      status: 'loading...');
                                                  updateStaff();
                                                } else {
                                                  commonToast(
                                                      context, "Invalid credentials");
                                                }
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
                                                    "Save ",
                                                    style: GoogleFonts.montserrat(
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.w500,
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
                                  ],
                                )
                : SizedBox(
                    height: 1,
                  ),
          ),
        ),
      ),
    );
  }
}
