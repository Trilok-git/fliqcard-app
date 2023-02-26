import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/Models/CountriesListParser.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
//import 'package:google_sign_in/google_sign_in.dart';
import '../MainScreen.dart';

class CreateFliqCard extends StatefulWidget {
  @override
  _CreateFliqCardState createState() => _CreateFliqCardState();
}

class _CreateFliqCardState extends State<CreateFliqCard> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController titleController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  String _googleVerifiedEmail = "not";
  TextEditingController passwordController = TextEditingController();
  TextEditingController refcodeController = TextEditingController();

  List<CountriesListParser> countriesList = [];
  String country = "+91";

  bool _obscureText = true;
  final picker = ImagePicker();

  User user = FirebaseAuth.instance.currentUser;

  File _logo;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _launchURL(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future _pickProfileImageInsight() async {
    try {
      List<Media> _listImagePaths = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          selectCount: 1,
          showGif: false,
          showCamera: false,
          compressSize: 500,
          uiConfig: UIConfig(uiThemeColor: Color(COLOR_PURPLE_PRIMARY)),
          cropConfig: CropConfig(enableCrop: true));

      _listImagePaths.forEach((media) {
        setState(() {
          _logo = File(media.path);
        });
      });
    } on PlatformException {}
  }

  Future registerAccount() {
    EasyLoading.show(status: 'Creating FliQCard...');
    Provider.of<CustomViewModel>(context, listen: false)
        .registerAccount(
            fnameController.text + " " + lnameController.text,
            phoneController.text,
            country,
            emailController.text,
            passwordController.text,
            refcodeController.text ?? "",
            titleController.text ?? "",
            companyController.text ?? "",
            emailController.text.toLowerCase() ==
                    (_googleVerifiedEmail ?? "NA").toLowerCase()
                ? "1"
                : "0")
        .then((value) {
      if (value == "success") {
        //auto verified for google

        Provider.of<CustomViewModel>(context, listen: false).setBottomIndex(1);
        if (_logo != null) {
          Provider.of<CustomViewModel>(context, listen: false)
              .UploadProfile(_logo)
              .then((value) {
            EasyLoading.dismiss();
            pop(context);

            pushReplacement(context, MainScreen());
          });
        } else {
          EasyLoading.dismiss();
          pop(context);
          pushReplacement(context, MainScreen());
        }
      } else {
        EasyLoading.dismiss();
        commonToast(context, value);
      }
    });
  }

 /* Future initTask() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut().then((value) async {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      EasyLoading.show(status: 'Validating...');
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;

          if (user != null) {
            setState(() {
              fnameController.text = user.displayName.split(" ").first;
              lnameController.text = user.displayName.split(" ").last;
              phoneController.text = user.phoneNumber ?? "";
              emailController.text = user.email ?? "";
              _googleVerifiedEmail = user.email ?? "";
            });

            Provider.of<CustomViewModel>(context, listen: false)
                .loginWithGoogleAccount(user.email ?? "")
                .then((value) {
              setState(() {
                EasyLoading.dismiss();
                if (value == "success") {
                  Provider.of<CustomViewModel>(context, listen: false)
                      .setBottomIndex(3);
                  pop(context);
                  pushReplacement(context, MainScreen());
                  commonToast(context, "You already have FliQCard");
                } else {
                  // commonToast(context, value);
                }
              });
            });
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // handle the error here
          } else if (e.code == 'invalid-credential') {
            // handle the error here
          }
        } catch (e) {
          // handle the error here
        }
      }
      EasyLoading.dismiss();
    });
  }*/

  @override
  void initState() {
    super.initState();

    for (Map i in asdf) {
      countriesList.add(CountriesListParser.fromJson(i));
      print(CountriesListParser.fromJson(i).dialCode);
    }
    if (Platform.isAndroid) {
      //initTask();
    }
  }

  PageController controller = PageController();
  List<String> _list = [
    "What's your name?",
    "Add your phone number",
    "Next, add your title and your company",
    "Choose a picture of yourself",
    "Now, enter a login email,\npreferably your personal\nemail address"
  ];

  int _curr = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        body: Container(
          height: SizeConfig.screenHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_curr == 0) {
                          pop(context);
                        } else {
                          controller.animateToPage(
                            _curr - 1,
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 300),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color(COLOR_PRIMARY),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 3,
                          width: 40,
                          color: Color(COLOR_PURPLE_PRIMARY),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 3,
                          width: 40,
                          color: _curr > 0
                              ? Color(COLOR_PURPLE_PRIMARY)
                              : Colors.grey.shade300,
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 3,
                          width: 40,
                          color: _curr > 1
                              ? Color(COLOR_PURPLE_PRIMARY)
                              : Colors.grey.shade300,
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 3,
                          width: 40,
                          color: _curr > 2
                              ? Color(COLOR_PURPLE_PRIMARY)
                              : Colors.grey.shade300,
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 3,
                          width: 40,
                          color: _curr > 3
                              ? Color(COLOR_PURPLE_PRIMARY)
                              : Colors.grey.shade300,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 1,
                    ),
                  ],
                ),
                Container(
                  height: SizeConfig.screenHeight - 80,
                  width: SizeConfig.screenWidth,
                  child: PageView(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              commonTitleBig(context, _list[0]),
                              SizedBox(
                                height: 40,
                              ),
                              Column(
                                children: [
                                  TextFormField(
                                    controller: fnameController,
                                    validator: (fullname) {
                                      if (fullname != "") {
                                        return null;
                                      } else {
                                        return "First Name required";
                                      }
                                    },
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'First Name',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.grey.shade800,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(COLOR_PURPLE_PRIMARY)),
                                      ),
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: lnameController,
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    validator: (fullname) {
                                      if (fullname != "") {
                                        return null;
                                      } else {
                                        return "Last Name required";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Last Name',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.grey.shade800,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(COLOR_PURPLE_PRIMARY)),
                                      ),
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 10),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 150,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (fnameController.text.isNotEmpty &&
                                          lnameController.text.isNotEmpty) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();

                                        controller.animateToPage(
                                          _curr + 1,
                                          curve: Curves.easeIn,
                                          duration: Duration(milliseconds: 300),
                                        );
                                      } else {
                                        commonToast(context,
                                            "Please fill required fields");
                                      }
                                    },
                                    child: CircleAvatar(
                                        backgroundColor: fnameController
                                                    .text.isNotEmpty &&
                                                lnameController.text.isNotEmpty
                                            ? Color(COLOR_PURPLE_PRIMARY)
                                            : Colors.grey.shade300,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              commonTitleBig(context, _list[1]),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: SizeConfig.screenWidth - 80,
                                    child: TextFormField(
                                      controller: phoneController,
                                      inputFormatters: <TextInputFormatter>[
                                        // for below version 2 use this
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (phone) {
                                        if (phone != "") {
                                          return null;
                                        } else {
                                          return "Phone Number Required";
                                        }
                                      },
                                      onChanged: (v) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                        /* prefix: Container(
                                          child: SearchableDropdown.single(
                                            items: countriesList.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: (value.dialCode ?? "+91")
                                                    .toString(),
                                                child: Container(
                                                  child: new Text(
                                                      (value.dialCode ?? "+91")
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,

                                                      style: GoogleFonts.montserrat(
                                                          textStyle: TextStyle(
                                                              fontSize: 13.0,
                                                              color:
                                                                  Colors.black))),
                                                ),
                                              );
                                            }).toList(),
                                            underline: Container(),
                                            hint: Container(
                                              child: Text("+91" ?? "",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black))),
                                              padding: EdgeInsets.only(
                                                  left: 0, top: 1, right: 0),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                country = value;
                                                print(value);
                                              });
                                            },
                                            displayClearIcon: false,
                                          ),
                                        ),*/
                                        prefixIcon: Container(
                                          width: 70,
                                          child: Center(
                                            child: InkWell(
                                              onTap: () {
                                                showCountryPicker(
                                                  context: context,
                                                  countryListTheme:
                                                      CountryListThemeData(
                                                    flagSize: 25,
                                                    backgroundColor:
                                                        Color(COLOR_BACKGROUND),
                                                    textStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                    //Optional. Sets the border radius for the bottomsheet.
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      topRight:
                                                          Radius.circular(20.0),
                                                    ),
                                                    //Optional. Styles the search field.

                                                    inputDecoration:
                                                        InputDecoration(
                                                      labelText: 'Search',
                                                      labelStyle: TextStyle(
                                                          color: Color(
                                                              COLOR_PRIMARY)),
                                                      hintStyle: TextStyle(
                                                          color: Color(
                                                              COLOR_PRIMARY)),
                                                      hintText:
                                                          'Start typing to search',
                                                      prefixIcon: const Icon(
                                                        Icons.search,
                                                        color: Color(
                                                            COLOR_PRIMARY),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                COLOR_PRIMARY)),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: const Color(
                                                                  COLOR_PRIMARY)
                                                              .withOpacity(0.2),
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 1,
                                                              vertical: 1),
                                                    ),
                                                  ),
                                                  onSelect: (Country OBJ) {
                                                    setState(() {
                                                      country = "+" +
                                                          (OBJ.phoneCode ?? 1)
                                                              .toString();
                                                    });
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Container(
                                                    child: Text(
                                                  (country).toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Color(COLOR_PRIMARY),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                              ),
                                            ),
                                          ),
                                        ),
                                        hintText: 'Phone Number',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          color: Colors.grey.shade800,
                                        ),
                                        filled: true,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color(COLOR_PURPLE_PRIMARY)),
                                        ),
                                        fillColor: Colors.transparent,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 1, vertical: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 200,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (phoneController.text.isNotEmpty) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        controller.animateToPage(
                                          _curr + 1,
                                          curve: Curves.easeIn,
                                          duration: Duration(milliseconds: 300),
                                        );
                                      } else {
                                        commonToast(context,
                                            "Please fill required fields");
                                      }
                                    },
                                    child: CircleAvatar(
                                        backgroundColor:
                                            phoneController.text.isNotEmpty
                                                ? Color(COLOR_PURPLE_PRIMARY)
                                                : Colors.grey.shade300,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              commonTitleBig(context, _list[2]),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    validator: (fullname) {
                                      if (fullname != "") {
                                        return null;
                                      } else {
                                        return "Title required";
                                      }
                                    },
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Title',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.grey.shade800,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(COLOR_PURPLE_PRIMARY)),
                                      ),
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: companyController,
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Company Name (Optional)',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.grey.shade800,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(COLOR_PURPLE_PRIMARY)),
                                      ),
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: refcodeController,
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Referral Code (Optional)',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.grey.shade800,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(COLOR_PURPLE_PRIMARY)),
                                      ),
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20),
                                    ],
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    obscureText: _obscureText,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            _toggle();
                                          },
                                          child: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey,
                                          )),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.grey.shade800,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(COLOR_PURPLE_PRIMARY)),
                                      ),
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 10),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 70,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (titleController.text.isNotEmpty) {
                                        if (passwordController.text != "" &&
                                            passwordController.text.length >
                                                5) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          controller.animateToPage(
                                            _curr + 1,
                                            curve: Curves.easeIn,
                                            duration:
                                                Duration(milliseconds: 300),
                                          );
                                        } else {
                                          commonToast(context,
                                              "Password must be 6 digits or more");
                                        }
                                      } else {
                                        commonToast(context,
                                            "Please fill required fields");
                                      }
                                    },
                                    child: CircleAvatar(
                                        backgroundColor:
                                            titleController.text.isNotEmpty &&
                                                    passwordController
                                                        .text.isNotEmpty
                                                ? Color(COLOR_PURPLE_PRIMARY)
                                                : Colors.grey.shade300,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            commonTitleBig(
                                context,
                                _logo == null
                                    ? (_list[3])
                                    : "Picture Selected"),
                            SizedBox(
                              height: 12,
                            ),
                            commonTitleSmallBold(
                                context,
                                _logo == null
                                    ? ""
                                    : "If you wish to change the image,\nYou can change by clicking on camera"),
                            SizedBox(
                              height: 40,
                            ),
                            InkWell(
                              onTap: () {
                                _pickProfileImageInsight();
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _logo != null
                                        ? Container(
                                            width: 200.0,
                                            height: 200.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff7c94b6),
                                              image: DecorationImage(
                                                image: FileImage(_logo),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                            ),
                                          )
                                        : Container(
                                            width: 200.0,
                                            height: 200.0,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(7.0),
                                              child: Icon(
                                                Icons.photo_camera_outlined,
                                                size: 60,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: _logo == null
                                        ? Container()
                                        : Card(
                                            shape: CircleBorder(),
                                            color: Colors.white,
                                            elevation: 7,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(7.0),
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 25,
                                                color:
                                                    Color(COLOR_PURPLE_PRIMARY),
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      controller.animateToPage(
                                        _curr + 1,
                                        curve: Curves.easeIn,
                                        duration: Duration(milliseconds: 300),
                                      );
                                    },
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color(COLOR_PURPLE_PRIMARY),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              commonTitleBig(context, _list[4]),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  emailController.text.toLowerCase() ==
                                          (_googleVerifiedEmail ?? "NA")
                                              .toLowerCase()
                                      ? Row(
                                          children: [
                                            Icon(Icons.check_circle,
                                                color: Colors.green, size: 15),
                                            SizedBox(width: 12),
                                            Text("Verified",
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        fontSize: 14.0,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.green))),
                                          ],
                                        )
                                      : Container(),
                                  TextFormField(
                                    controller: emailController,
                                    maxLength: 40,
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: Colors.grey.shade800,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(COLOR_PURPLE_PRIMARY)),
                                      ),
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 10),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 150,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (emailController.text.isNotEmpty) {
                                        if (isEmailValid(
                                            emailController.text)) {
                                          registerAccount();
                                        } else {
                                          commonToast(
                                              context, "Invalid email address");
                                        }
                                      } else {
                                        commonToast(
                                            context, "Invalid email address");
                                      }
                                    },
                                    child: CircleAvatar(
                                        backgroundColor:
                                            emailController.text.isNotEmpty
                                                ? Color(COLOR_PURPLE_PRIMARY)
                                                : Colors.grey.shade300,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    scrollDirection: Axis.horizontal,

                    // reverse: true,
                    // physics: BouncingScrollPhysics(),
                    controller: controller,
                    onPageChanged: (num) {
                      setState(() {
                        _curr = num;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
