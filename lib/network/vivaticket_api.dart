import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';

class VivaticketApi {
  static const String _protocol = 'https';
  static const String _login = 'LoginUtente';
  static const String _logOut = 'LogoutUtente';
  static const String _getCourses = 'GetCorsi';
  static const String _checkManager = 'CheckManager';
  static const String _historyQrScan = 'History';
  static const String _historyCaScan = 'Historyca';
  static const String _getUsersExtra = 'GetUsersExtra';
  static const String _getUserExtra = 'GetUtenteExtra';
  static const String _setUtenteApp = 'Setutenteapp';
  static const String _sendOffline = 'SendOffline';
  static const String _setUtenteAppManual = 'Setutenteappmanuale';
  static const String _getUterExtra20 = 'GetUtenteExtraByCode20';
  static const String _sendOfflineBulk = 'SendOffline';

  static String serverName(Envirorment envirorment) {
    if (envirorment == Envirorment.production) {
      return 'rnmanager.vivaticket.com';
    } else {
      return 'rnmanagertest.vivaticket.com';
    }
  }

  static String endpoint(Envirorment envirorment) {
    return '$_protocol://${serverName(envirorment)}/webservicemanager.asmx?op=';
  }

  static String REQUEST_LOGIN(Envirorment envirorment) =>
      endpoint(envirorment) + _login;

  static String REQUEST_LOGOUT(Envirorment envirorment) =>
      endpoint(envirorment) + _logOut;

  static String REQUEST_COURSES(Envirorment envirorment) =>
      endpoint(envirorment) + _getCourses;
  static String REQUEST_CHECK_MANAGER(Envirorment envirorment) =>
      endpoint(envirorment) + _checkManager;

  static String REQUEST_HISTORY_SCAN(Envirorment envirorment) =>
      endpoint(envirorment) + _historyQrScan;

  static String REQUEST_HISTORYCA_SCAN(Envirorment envirorment) =>
      endpoint(envirorment) + _historyCaScan;

  static String REQUEST_GET_USERS_EXTRA(Envirorment envirorment) =>
      endpoint(envirorment) + _getUsersExtra;

  static String REQUEST_GET_UTENTE_EXTRA(Envirorment envirorment) =>
      endpoint(envirorment) + _getUserExtra;

  static String REQUEST_GET_UTENTE_EXTRA_BY_CODE_20(Envirorment envirorment) =>
      endpoint(envirorment) + _getUterExtra20;

  static String REQUEST_SET_UTENTE_APP(Envirorment envirorment) =>
      endpoint(envirorment) + _setUtenteApp;

  static String REQUEST_SET_UTENTE_APP_MANUAL(Envirorment envirorment) =>
      endpoint(envirorment) + _setUtenteApp;

  static String REQUEST_SEND_OFFLINE(Envirorment envirorment) =>
      endpoint(envirorment) + _sendOffline;

  static String REQUEST_SEND_OFFLINE_BULK(Envirorment envirorment) =>
      endpoint(envirorment) + _sendOfflineBulk;
}
