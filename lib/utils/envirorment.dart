import 'package:shared_preferences/shared_preferences.dart';

enum Envirorment { production, staging }

class EnvirormentPreferences {
  static const THEME_STATUS = "ENVIRORMENT";

  setEnvirorment(Envirorment value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(THEME_STATUS, value.name);
  }

  Future<Envirorment> getEnvirorment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(THEME_STATUS) == Envirorment.staging.name)
      return Envirorment.staging;
    else
      return Envirorment.production;
  }
}
