import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const double kBorderRaduis = 9;
const String domainURL = "https://cmenu.co.za/api/v1/";
//const String domainURL = "http://10.0.2.2:8001/api/v1/";
const String appVersion = "1.0.0";
const String appName = "cMenu";
const String mapApiKey = "AIzaSyA84_PFQQGykqnm3wnWNOXckY3uDF57pkI";
const bool kDebugMode = true;
const String currencyCode = "R";
//Preference keys
const String appPreferenceKey = "jiri_app_key_";
const String firstTimePreferenceKey = 'jiri_firstTime_key_';
const String settingPreferenceKey = 'jiri_setting_key_';
//formTypes

//ads
const String interstitialBannerAndroid =
    'ca-app-pub-4029429063328473/9042659928';
const String bannerAndroid = 'ca-app-pub-4029429063328473/3621112168';
const String rewardBannerAndroid = 'ca-app-pub-4029429063328473/2475319941';

const String banneriOS = 'ca-app-pub-3940256099942544/2934735716';
const String interstitialBanneriOS = "ca-app-pub-3940256099942544/4411468910";
const String rewardBanneriOS = "ca-app-pub-3940256099942544/1712485313";

/// form field gap
const double gapBetwnFields = 0.01;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// const AndroidNotificationChannel jiriChannel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'Jiri Notifications', // title
//   description:
//       'This channel is used for jiri important notifications.', // description
//   importance: Importance.max,
// );
// final android = AndroidNotificationDetails('0', 'Jiri App',
//     channelDescription: 'channel description',
//     priority: Priority.high,
//     importance: Importance.max,
//     icon: '');
// //final iOS = IOSNotificationDetails();
// final platform = NotificationDetails(android: android);
