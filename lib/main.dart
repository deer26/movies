import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie/resources/genre_api_provider.dart';
import 'package:movie/ui/splash_intro/api_intro_screen.dart';
import 'package:movie/ui/splash_intro/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/constants/colors.dart';
import 'models/constants/constant.dart';

bool first = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _getFirstRunInfo();
  _getGenresAll();
  runApp(MyApp());
}

void _getGenresAll() async {
  genreModelGlobal = await GenreApiProvider().fetchGenreList();
}

void _getFirstRunInfo() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  first = preferences.getBool("firstRun");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.light, statusBarColor: bgColor));
    return MaterialApp(
      title: 'Movie App',
      home: !first ? ApiIntroScreen() : SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
