import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lead_generation_flutter_app/network/logout_service.dart';
import 'package:lead_generation_flutter_app/provider/offline_mode_provider.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositor_detail_screen.dart';

import '../../db/database_helper.dart';
import '../../model/user_model/user.dart';
import '../../provider/dark_theme_provider.dart';
import '../../provider/envirorment_provider.dart';
import '../../utils/envirorment.dart';
import '../../utils/theme/custom_theme.dart';
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
            SizedBox(
              height: 20,
            ),
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
                          if (value) {
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
                                        : Colors.black);
                              }
                            });
                          }
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
        height: 50,
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
          ?
      GestureDetector(
        child: Container(
          height: 50,
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
                MaterialPageRoute(builder: (context) => ExpositorDetailScreen(user: widget.user,isNew: true,)),
              );
              
        },
      ): Container(),
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
    ]));
  }

  Future<void> showInformationDialog(
      BuildContext context, Color backgroundColor, Color anotherColor) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                backgroundColor: backgroundColor,
                content: Container(
                  height: 300,
                  width: 300,
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
          title: Text(AppLocalizations.of(context).titleDialogLogout),
          content: Text(AppLocalizations.of(context).contentDialogLogout),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text(AppLocalizations.of(context).yes),
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
              child: Text(AppLocalizations.of(context).no),
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
