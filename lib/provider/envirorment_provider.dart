import 'package:flutter/material.dart';
import 'package:lead_generation_flutter_app/utils/envirorment.dart';
import 'package:lead_generation_flutter_app/utils/theme/dark_theme.dart';

class EnvirormentProvider with ChangeNotifier {
  EnvirormentPreferences envirormentPreferences = EnvirormentPreferences();
  Envirorment _evirormentProvider = Envirorment.production;

  Envirorment get envirormentState => _evirormentProvider;

  set envirormentState(Envirorment value) {
    _evirormentProvider = value;
    envirormentPreferences.setEnvirorment(value);
    notifyListeners();
  }
}
