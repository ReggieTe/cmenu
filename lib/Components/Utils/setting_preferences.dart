import 'dart:convert';

import 'package:cmenu/Components/Class/setting.dart';
import 'package:cmenu/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPreferences {
  static late SharedPreferences _preferences;
  static const _keySetting = settingPreferenceKey;

  static const mySetting = Setting(
      location: '',
      budget: 0.0,
      cart:'',
      history:''
      );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setSetting(Setting setting) async {
    final json = jsonEncode(setting.toJson());
    await _preferences.setString(_keySetting, json);
  }

  static Setting getSetting() {
    final json = _preferences.getString(_keySetting);
    var d = json == null
        ? mySetting
        : Setting.fromJson(jsonDecode(json.toString()));

    return d;
  }

  static Future clear() async {
    final json = jsonEncode(mySetting.toJson());
    await _preferences.setString(_keySetting, json);
  }
}
