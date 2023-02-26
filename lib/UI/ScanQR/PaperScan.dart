import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fliqcard/Helpers/constants.dart';
import 'package:fliqcard/Helpers/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'DetailScreen.dart';

BuildContext parentContext;

List<CameraDescription> cameras = [];

class PaperScan extends StatefulWidget {
  PaperScan({Key key}) : super(key: key);

  @override
  _PaperScanState createState() => _PaperScanState();
}

class _PaperScanState extends State<PaperScan> {
  CameraController _controller;

  bool isLoaded = false;

  Future<void> initTask() async {
    try {
      await Firebase.initializeApp();
      print("aaaaaaaaaaaaaaaa1");
      cameras = await availableCameras();
      print(cameras.length);
      print("aaaaaaaaaaaaaaaa2");
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      print("aaaaaaaaaaaaaaaa3");
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          isLoaded = true;
        });
      });
    } on CameraException catch (e) {
      print("aaaaaaaaaaaaaaaa3");
      print(e);
    }
  }

  Future<String> _takePicture() async {
    // Checking whether the controller is initialized
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');
    print("Formatted: $formattedDateTime");

    // Retrieving the path for saving an image
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    // Checking whether the picture is being taken
    // to prevent execution of the function again
    // if previous execution has not ended
    if (_controller.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }
    XFile tempFile;

    try {
      // Captures the image and saves it to the
      // provided path
      tempFile = await _controller.takePicture();
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return tempFile.path;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTask();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      parentContext = context;
    });

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
            "Paper Scan",
            style: GoogleFonts.montserrat(
              color: Color(COLOR_PRIMARY),
            ),
          ),
          backgroundColor: Color(COLOR_BACKGROUND),
        ),
        body: SingleChildScrollView(
          child: isLoaded == true
              ? _controller.value.isInitialized
                  ? Stack(
                      children: <Widget>[
                        Container(
                            width: screenWidth,
                            height: screenHeight - 80,
                            child: CameraPreview(_controller)),
                        Positioned(
                          bottom: 70,
                          left: 0,
                          right: 0,
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: RaisedButton.icon(
                              icon: Icon(Icons.camera),
                              label: Text("Click"),
                              onPressed: () async {
                                await _takePicture().then((String path) {
                                  if (path != null) {
                                    pop(context);
                                    push(parentContext, DetailScreen(path));
                                  }
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(
                      height: screenHeight,
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
              : Container(
                  height: screenHeight,
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }
}
