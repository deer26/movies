import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie/models/constants/colors.dart';
import 'package:movie/ui/pages/home_screen.dart';

import 'mycustom_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  void navigationPage() {
    Navigator.push(
            context, new MyCustomRoute(builder: (context) => new HomeScreen()))
        .then((value) => _key.currentState.setState(() {
              startTime();
            }));
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      key: _key,
      backgroundColor: bgColor,
      body: new Center(
        child: new Image.asset(
          "assets/icon/movie.png",
        ),
      ),
    );
  }
}
