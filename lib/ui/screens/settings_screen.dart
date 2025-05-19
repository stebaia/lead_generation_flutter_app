import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lead_generation_flutter_app/db/database_helper.dart';
import 'package:lead_generation_flutter_app/ui/screens/zebra_scanner_expositor.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/l10n/app_localizations.dart';
import 'package:lead_generation_flutter_app/model/scan_offline.dart';
import 'package:lead_generation_flutter_app/network/logout_service.dart';
import 'package:lead_generation_flutter_app/network/send_code_offline_service.dart';
import 'package:lead_generation_flutter_app/provider/offline_mode_provider.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositor_detail_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/zebra_scanner.dart';

import '../../model/user_model/user.dart';
import '../../provider/dark_theme_provider.dart';
import '../../provider/envirorment_provider.dart';
import '../../utils_backup/envirorment.dart';
import '../../utils_backup/theme/custom_theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.user})
      : super(
          key: key,
        );

  final User user;

  @override
  State<SettingsScreen> createState() => _SettingUserScreenState();
}

class _SettingUserScreenState extends State<SettingsScreen> {
  EnvirormentProvider envirormentProvider = EnvirormentProvider();
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final envirormentTheme = Provider.of<EnvirormentProvider>(context);
    final offlineMode = Provider.of<OfflineModeProvider>(context);
    return SingleChildScrollView(
        child: Column(children: [
      Container(
        height: 200,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              widget.user.email,
              style: TextStyle(
                  color: ThemeHelper.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Preferenze'.toUpperCase(),
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              letterSpacing: 1.6,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      widget.user.userType != 106
          ? Container(
              height: 50,
              color: themeChange.darkTheme
                  ? CupertinoColors.label
                  : CupertinoColors.white,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.wifi_slash,
                        color: themeChange.darkTheme
                            ? CupertinoColors.white
                            : CupertinoColors.label,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Offline Mode',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: themeChange.darkTheme
                                ? Colors.white
                                : Colors.black),
                      ),
                      Spacer(),
                      CupertinoSwitch(
                        value: offlineMode.getOfflineMode,
                        onChanged: (value) async {
                          await DatabaseHelper.instance
                              .getOfflineScan()
                              .then((value) {
                            if (value.isNotEmpty) {
                              showInformationDialog(
                                  context,
                                  themeChange.darkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  themeChange.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  value);
                            }
                          });

                          offlineMode.offlineMode = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
      Container(
        height: 60,
        color: themeChange.darkTheme
            ? CupertinoColors.label
            : CupertinoColors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.moon,
                  color: themeChange.darkTheme
                      ? CupertinoColors.white
                      : CupertinoColors.label,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Dark Mode',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color:
                          themeChange.darkTheme ? Colors.white : Colors.black),
                ),
                Spacer(),
                CupertinoSwitch(
                  value: themeChange.darkTheme,
                  onChanged: (value) {
                    themeChange.darkTheme = value;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      widget.user.userType == 106
          ? GestureDetector(
              child: Container(
                height: 60,
                color: themeChange.darkTheme
                    ? CupertinoColors.label
                    : CupertinoColors.white,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.hand_draw,
                          color: themeChange.darkTheme
                              ? CupertinoColors.white
                              : CupertinoColors.label,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Manual Mode',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: themeChange.darkTheme
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Spacer(),
                        Icon(
                          CupertinoIcons.chevron_forward,
                          color: themeChange.darkTheme
                              ? CupertinoColors.white
                              : CupertinoColors.label,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExpositorDetailScreen(
                            user: widget.user,
                            isNew: true,
                          )),
                );
              },
            )
          : Container(),
      GestureDetector(
          child: Container(
            height: 60,
            color: themeChange.darkTheme
                ? CupertinoColors.label
                : CupertinoColors.white,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.square_arrow_left,
                      color: themeChange.darkTheme
                          ? CupertinoColors.white
                          : CupertinoColors.label,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: themeChange.darkTheme
                              ? Colors.white
                              : Colors.black),
                    ),
                    Spacer(),
                    Icon(
                      CupertinoIcons.chevron_forward,
                      color: themeChange.darkTheme
                          ? CupertinoColors.white
                          : CupertinoColors.label,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () =>
              Navigator.of(context).restorablePush(_dialogBuilder, arguments: {
                'idUser': widget.user.id,
                'envirorment': envirormentTheme.envirormentState.toString()
              })),
      GestureDetector(
          child: Container(
            height: 60,
            color: themeChange.darkTheme
                ? CupertinoColors.label
                : CupertinoColors.white,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.scanner,
                      color: themeChange.darkTheme
                          ? CupertinoColors.white
                          : CupertinoColors.label,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Zebra mode',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: themeChange.darkTheme
                              ? Colors.white
                              : Colors.black),
                    ),
                    Spacer(),
                    Icon(
                      CupertinoIcons.chevron_forward,
                      color: themeChange.darkTheme
                          ? CupertinoColors.white
                          : CupertinoColors.label,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            switch (widget.user.userType) {
              case 106:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ZebraScannerExpositorPage(
                            user: widget.user,
                          )),
                );
                break;

              default:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ZebraScannerPage(
                            user: widget.user,
                          )),
                );
                break;
            }
          }),
    ]));
  }

  Future<void> showInformationDialog(
      BuildContext context,
      Color backgroundColor,
      Color anotherColor,
      List<OfflineScan> offlineScan) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Text("Attenzione!",
                    style: TextStyle(
                      color: anotherColor,
                    )),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(color: Colors.black),
                      backgroundColor: Color.fromARGB(0, 252, 252, 252),
                    ),
                    onPressed: () {},
                    child: Text(
                      "No",
                      style: TextStyle(
                          color: anotherColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      SendOfflineService sendOfflineService =
                          SendOfflineService();
                      for (final scan in offlineScan) {
                        sendOfflineService.sendOffline(
                            scan.idManifestazione.toString(),
                            scan.idCorso.toString(),
                            scan.idUtilizzatore.toString(),
                            scan.dataOra,
                            scan.ckExit,
                            scan.codice,
                            envirormentProvider.envirormentState);
                        await DatabaseHelper.instance
                            .deleteOfflineScan(scan.codice)
                            .then((value) {
                          /*Fluttertoast.showToast(
                              msg:
                                  "Scannerizzazione con codice ${scan.codice} inviata correttamente");*/
                        }).onError((error, stackTrace) {
                          /*Fluttertoast.showToast(
                              backgroundColor: Colors.red,
                              msg:
                                  "Errore nell'invio della scannerizzazione con codice ${scan.codice}");*/
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Si, invia!",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                backgroundColor: backgroundColor,
                content: Container(
                  height: 150,
                  width: 300,
                  child: Column(children: [
                    Text(
                      "Sono presenti delle scannerizzazioni offline",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: anotherColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Vuoi inviarle al server?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: anotherColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ]),
                ));
          });
        });
  }

  static Future<int> requestLogout(int id, Envirorment envirorment) {
    LogoutService logoutService = new LogoutService();
    Future<int> responseLogout = logoutService.requestLogout(id, envirorment);
    return responseLogout;
  }

  static Route<Object?> _dialogBuilder(
    BuildContext context,
    Object? arguments,
  ) {
    Map mapArguments = arguments as Map;
    int idUser = mapArguments["idUser"];
    Envirorment envirorment = mapArguments["envirorment"] == "staging"
        ? Envirorment.staging
        : Envirorment.production;

    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.titleDialogLogout),
          content: Text(AppLocalizations.of(context)!.contentDialogLogout),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text(AppLocalizations.of(context)!.yes),
                onPressed: () {
                  requestLogout(idUser, envirorment).then((value) {
                    if (value > -1) {
                      DatabaseHelper.instance.delete(idUser).then((value) =>
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              ModalRoute.withName("/login")));
                    }
                  });
                }),
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
