import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:fliqcard/Helpers/size_config.dart';
import 'package:fliqcard/UI/Auth/WelcomeScreen.dart';
import 'package:fliqcard/UI/MainScreen.dart';
import 'package:fliqcard/View%20Models/CustomViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'ForgotScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  User user = FirebaseAuth.instance.currentUser;
  FocusNode focusNode1;
  FocusNode focusNode2;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }

  Future loginAccount() {
    Provider.of<CustomViewModel>(context, listen: false)
        .loginAccount(
      emailController.text,
      passwordController.text,
    )
        .then((value) {
      setState(() {
        EasyLoading.dismiss();
        if (value == "success") {
          Provider.of<CustomViewModel>(context, listen: false)
              .setBottomIndex(3);
          pushReplacement(context, MainScreen());
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
    focusNode1 = new FocusNode();
    focusNode2 = new FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(COLOR_BACKGROUND),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: buildImage('assets/logo.png', 80),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Log In",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 1.5,
                                  width: 85,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              height: 40,
                              width: SizeConfig.screenWidth,
                              child: TextFormField(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode1);
                                },
                                focusNode: focusNode1,
                                controller: emailController,
                                validator: (email) {
                                  email = email.replaceAll(" ", "");
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
                                    color: Color(COLOR_SUBTITLE),
                                  ),
                                  /*border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),*/
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 60,
                              width: SizeConfig.screenWidth,
                              child: TextFormField(
                                focusNode: focusNode2,
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(focusNode2);
                                },
                                controller: passwordController,
                                obscureText: _obscureText,
                                validator: (password) {
                                  if (password != "" && password.length > 5) {
                                    return null;
                                  } else {
                                    return "Password must be 6 digits or more";
                                  }
                                },
                                maxLength: 20,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        _toggle();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                      )),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Color(COLOR_SUBTITLE),
                                  ),
                                  /*border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),*/
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  EasyLoading.show(status: 'loading...');
                                  loginAccount();
                                } else {
                                  commonToast(context, "Invalid credentials");
                                }
                              },
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Color(COLOR_PURPLE_PRIMARY),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Log In",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                push(context, ForgotScreen());
                              },
                              child: Container(
                                child: Text(
                                  "Forgot password? Reset Now",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(COLOR_PURPLE_PRIMARY),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Platform.isIOS
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: SizeConfig.screenWidth / 3.5,
                                        height: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                      Text("OR",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                              letterSpacing: 1,
                                              textStyle: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(COLOR_TITLE)))),
                                      Container(
                                        width: SizeConfig.screenWidth / 3.5,
                                        height: 2,
                                        color: Colors.grey.shade300,
                                      )
                                    ],
                                  ),
                            Platform.isIOS
                                ? Container()
                                : SizedBox(
                                    height: 35,
                                  ),
                            Platform.isIOS
                                ? Container()
                                : InkWell(
                                    onTap: () async {
                                      FirebaseAuth auth = FirebaseAuth.instance;

                                      final GoogleSignIn googleSignIn =
                                          GoogleSignIn();

                                      await googleSignIn
                                          .signOut()
                                          .then((value) async {
                                        final GoogleSignInAccount
                                            googleSignInAccount =
                                            await googleSignIn.signIn();

                                        EasyLoading.show();
                                        if (googleSignInAccount != null) {
                                          final GoogleSignInAuthentication
                                              googleSignInAuthentication =
                                              await googleSignInAccount
                                                  .authentication;

                                          final AuthCredential credential =
                                              GoogleAuthProvider.credential(
                                            accessToken:
                                                googleSignInAuthentication
                                                    .accessToken,
                                            idToken: googleSignInAuthentication
                                                .idToken,
                                          );

                                          try {
                                            final UserCredential
                                                userCredential =
                                                await auth.signInWithCredential(
                                                    credential);

                                            user = userCredential.user;

                                            if (user != null) {
                                              EasyLoading.show(
                                                  status: 'loading...');

                                              Provider.of<CustomViewModel>(
                                                      context,
                                                      listen: false)
                                                  .loginWithGoogleAccount(
                                                      user.email ?? "")
                                                  .then((value) {
                                                setState(() {
                                                  EasyLoading.dismiss();
                                                  if (value == "success") {
                                                    Provider.of<CustomViewModel>(
                                                            context,
                                                            listen: false)
                                                        .setBottomIndex(3);
                                                    pushReplacement(
                                                        context, MainScreen());
                                                  } else {
                                                    commonToast(context, value);
                                                  }
                                                });
                                              });
                                            } else {
                                              commonToast(context,
                                                  "Please try different email or login with password");
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code ==
                                                'account-exists-with-different-credential') {
                                              // handle the error here
                                            } else if (e.code ==
                                                'invalid-credential') {
                                              // handle the error here
                                            }
                                          } catch (e) {
                                            // handle the error here
                                          }
                                        }
                                        EasyLoading.dismiss();
                                      });
                                    },
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          border: Border.all(
                                              width: 1.5, color: Colors.black)),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: buildImage(
                                                  'assets/google.png', 20),
                                            ),
                                            Text(
                                              "Continue With Google",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color(COLOR_TITLE),
                                              ),
                                            ),
                                            SizedBox(width: 1),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            Platform.isIOS
                                ? Container()
                                : SizedBox(
                                    height: 40,
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account? ",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        letterSpacing: 1,
                                        textStyle: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(COLOR_TITLE)))),
                                InkWell(
                                  onTap: () {
                                    pushReplacement(context, WelcomeScreen());
                                  },
                                  child: Text("SignUp",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.underline,
                                        letterSpacing: 1,
                                        textStyle: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(COLOR_PURPLE_PRIMARY),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
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
