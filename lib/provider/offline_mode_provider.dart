import 'package:flutter/material.dart';
import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';
import 'package:lead_generation_flutter_app/utils_backup/offilne_mode.dart';
import 'package:lead_generation_flutter_app/utils_backup/theme/dark_theme.dart';

class OfflineModeProvider with ChangeNotifier {
  OfflineModePreferences envirormentPreferences = OfflineModePreferences();
  bool _offlineMode = false;

  bool get getOfflineMode => _offlineMode;

  set offlineMode(bool value) {
    _offlineMode = value;
    envirormentPreferences.setOfflineMode(value);
    notifyListeners();
  }
}
