import 'dart:async';

import 'package:cmenu/Components/Class/first_time.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/first_time_preferences.dart';
import 'package:cmenu/Components/progress_loader.dart';
import 'package:cmenu/NoInternetConnection/no_internet_connection_screen.dart';
import 'package:cmenu/Onboarding/onboarding_screen.dart';
import 'package:cmenu/Search/search_screen.dart';
import 'package:cmenu/Splash/components/background.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> {
  late FirstTime firstTime = FirstTimePreferences.getFirstTime();
  bool isApiCallProcess = false;
  bool isUserFirstTime = false;

  @override
  void initState() {
    isApiCallProcess = true;
     WidgetsBinding.instance
          .addPostFrameCallback((_) => initializeApp());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressLoader(
      inAsyncCall: isApiCallProcess,
      opacity: 0,
      alignment: Alignment.bottomCenter,
      whiteBg: true,
      child: _uiSetup(context),
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "cMenu",
            style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          ),
          Text(
            "One for All",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Quicksand'),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> initializeApp() async {
    var isConnected =  await common.checkInternetConnection(InternetConnectionChecker());
    if (!isConnected) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const NoInternetConnectionScreen();
      }));
    }
    if (firstTime.onBoarding) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const OnboardingScreen();
      }));
     } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const SearchScreen();
      }));
    }
  }
}
