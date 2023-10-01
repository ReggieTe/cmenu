import 'dart:convert';

import 'package:cmenu/Components/Class/first_time.dart';
import 'package:cmenu/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTimePreferences {
  static SharedPreferences? _preferences;
  static const _keyFirstTime = firstTimePreferenceKey;

  static const myFirstTime = FirstTime(onBoarding:true,splash: true);

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setFirstTime(FirstTime firsttime) async {
    final json = jsonEncode(firsttime.toJson());
    await _preferences?.setString(_keyFirstTime, json);
  }

  static FirstTime getFirstTime() {
    final json = _preferences?.getString(_keyFirstTime);
    return json == null ? myFirstTime : FirstTime.fromJson(jsonDecode(json));
  }

  static Future clear() async {
    final json = jsonEncode(myFirstTime.toJson());
    await _preferences?.setString(_keyFirstTime, json);
  }
}
