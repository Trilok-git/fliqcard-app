import 'dart:convert';

import 'package:fliqcard/Helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'UI/Auth/WelcomeScreen.dart';
import 'View Models/CustomViewModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HomeWidget.registerBackgroundCallback(backgroundCallback);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(COLOR_PRIMARY),
      statusBarIconBrightness: Brightness.light));
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(ShowCaseWidget(
      autoPlay: true,
      onStart: (index, key) {
        prefs.setBool("introFinished", true);
      },
      onComplete: (index, key) async {},
      blurValue: 1,
      builder: Builder(builder: (context) {
        return App();
      })));
}

// Called when Doing Background Work initiated from Widget
Future<void> backgroundCallback(Uri uri) async {
  if (uri.host == 'updatecounter') {
    var x;
    // int _counter;
    await HomeWidget.getWidgetData<String>('_vcardata', defaultValue: "")
        .then((value) {
      x = jsonEncode(value);
      print(x);
    });
    await HomeWidget.saveWidgetData<String>('_vcardata', x);
    await HomeWidget.updateWidget(
        name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => CustomViewModel(),
                child: MaterialApp(
                    debugShowCheckedModeBanner: false, home: WelcomeScreen())),
          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false, home: WelcomeScreen())),
      builder: EasyLoading.init(),
    );
  }
}

/*class VideoIntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VideoIntroScreenState();
}

class _VideoIntroScreenState extends State<VideoIntroScreen>
    with TickerProviderStateMixin {
  VideoPlayerController _controller;
  bool _visible = false;

  Future initTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id") ?? "null";

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (id != null && id != "null") {
        pushReplacement(context, MainScreen());
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (id != null && id != "null") {
        pushReplacement(context, MainScreen());
      }
    } else {
      if (id != null && id != "null") {
        pushReplacement(context, NoInternet(id));
      } else {
        pushReplacement(context, NoInternet("0"));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initTask();
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
    _controller = VideoPlayerController.network(
        "https://fliqcard.com/digitalcard/assets/img/appdata/intro.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      setState(() {
        _controller.setVolume(0.0);
        _controller.play();
        _visible = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        color: Colors.white,
        child: Stack(
          children: [
            _visible == true
                ? _getVideoBackground()
                : Container(
                    color: Colors.white,
                    child: Center(
                      child: new CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Color(COLOR_PRIMARY),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(COLOR_BACKGROUND)),
                      ),
                    ),
                  ),
            Positioned(
              bottom: 15,
              right: 15,
              child: InkWell(
                onTap: () {
                  pushReplacement(context, OnBoardingPage());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(COLOR_SECONDARY),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Next  ',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(COLOR_PRIMARY),
                              fontWeight: FontWeight.w700)),
                      Icon(Icons.arrow_forward, color: Color(COLOR_PRIMARY))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
