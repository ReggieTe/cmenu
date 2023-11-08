// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';

import 'package:cmenu/Components/Class/first_time.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/first_time_preferences.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Components/progress_loader.dart';
import 'package:cmenu/NoInternetConnection/no_internet_connection_screen.dart';
import 'package:cmenu/Onboarding/onboarding_screen.dart';
import 'package:cmenu/Search/search_screen.dart';
import 'package:cmenu/Splash/components/background.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> {
  late FirstTime firstTime = FirstTimePreferences.getFirstTime();
  
  var settings = SettingPreferences.getSetting();
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
    return const Background(
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
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> initializeApp() async {
    //save id    

    if(settings.token.isEmpty){
      String deviceId = await getUniqueDeviceId();
      var setting = settings.copy( token: deviceId);
          SettingPreferences.setSetting(setting);
    }
                                     
    var isConnected =  await Common.checkInternetConnection(InternetConnectionChecker());
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

  Future<String> getUniqueDeviceId() async {
  String uniqueDeviceId = '';

  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    uniqueDeviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS
  } else if(Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    uniqueDeviceId = '${androidDeviceInfo.brand}:${androidDeviceInfo.id}' ; // unique ID on Android
  }
  
  return uniqueDeviceId;

}
}
