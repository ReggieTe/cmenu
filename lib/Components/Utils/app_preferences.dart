import 'dart:convert';
import 'package:cmenu/Components/Class/app.dart';
import 'package:cmenu/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _preferences;
  static const _keyApp = appPreferenceKey;

  static const myApp = App(
      app: "",
      petType: "",
      gender: "",
      documentType: "",
      documentUploadType: "",
      accountState: "",
      searchType: "",
      postMessage: "",
      timeIntervals: "",
      listTypes: "",
      locationCities: "",
      listReportType: "",
      radius: "",
      type: "",
      country: "",
      location: "",
      adState: "",
      build: "",
      dashboardEnum: "",
      eyes: "",
      found: "",
      hair: "",
      height: "",
      payment: "",
      paymentStatus: "",
      race: "",
      weight: "",
      state: "",
      accountType: "",
      searchHistory: "",
      feedType:"");

  static Future init() async {
    var x = await Future.wait([SharedPreferences.getInstance()]);
    return _preferences = x[0];
  }

  static Future setApp(App setting) async {
    final json = jsonEncode(setting.toJson());
    await _preferences.setString(_keyApp, json);
  }

  static App getApp() {
    final json = _preferences.getString(_keyApp);
    return json == null ? myApp : App.fromJson(jsonDecode(json));
  }

  static Future clear() async {
    final json = jsonEncode(myApp.toJson());
    await _preferences.setString(_keyApp, json);
  }

  static Future delete() async {
    await Future.wait([_preferences.clear()]);
  }
}
