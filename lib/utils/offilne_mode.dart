import 'package:shared_preferences/shared_preferences.dart';

class OfflineModePreferences {
  static const OFFLINE_MODE = "OFFLINE_MODE";

  setOfflineMode(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(OFFLINE_MODE, value);
  }

  Future<bool> getMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(OFFLINE_MODE) ?? false;
  }
}