import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lead_generation_flutter_app/network/history_without_course_service.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/model/history_model/history.dart';
import 'package:lead_generation_flutter_app/provider/envirorment_provider.dart';
import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';
import 'dart:math' as math;

import '../../network/history_service.dart';
import '../../provider/dark_theme_provider.dart';
import '../../utils_backup/theme/custom_theme.dart';

class ComplexModal extends StatefulWidget {
  ComplexModal(
      {Key? key,
      required this.idManifestazione,
      this.idCorso,
      required this.barcode})
      : super(
          key: key,
        );

  final int idManifestazione;
  final int? idCorso;
  final String barcode;
  @override
  State<ComplexModal> createState() => _MyComplexModalState();
}

class _MyComplexModalState extends State<ComplexModal> {
  List<History> listOfHistory = [];
  int? idCorso;
  @override
  Widget build(BuildContext rootContext) {
    final themeChange = Provider.of<DarkThemeProvider>(rootContext);
    final envirormentProvider = Provider.of<EnvirormentProvider>(rootContext);
    if (widget.idCorso != null) {
      idCorso = widget.idCorso!;
    }
    int idManifestazione = widget.idManifestazione;
    String barcode = widget.barcode;
    return Material(
        child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context2) => Builder(
          builder: (context) => CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(
                  AppLocalizations.of(context).historyScannerization,
                  style: TextStyle(color: ThemeHelper.primaryColor),
                ),
                trailing: GestureDetector(
                    onTap: () {
                      Navigator.pop(rootContext);
                    },
                    child: Transform.rotate(
                      angle: -90 * math.pi / 180,
                      child: Icon(
                        CupertinoIcons.back,
                        color: ThemeHelper.primaryColor,
                      ),
                    )),
              ),
              child: idCorso != null
                  ? FutureBuilder(
                      future: getHistoryScan(idManifestazione, idCorso!,
                          barcode, envirormentProvider.envirormentState),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          listOfHistory = snapshot.data as List<History>;
                          if (listOfHistory.length > 0) {
                            return SafeArea(
                              bottom: false,
                              child: ListView.builder(
                                  itemCount: listOfHistory.length,
                                  itemBuilder: (context, index) => ListTile(
                                        title: Text(
                                          listOfHistory[index].description,
                                          style: TextStyle(
                                            color: themeChange.darkTheme
                                                ? CupertinoColors.white
                                                : CupertinoColors.black,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${listOfHistory[index].gate} ${listOfHistory[index].data}",
                                          style: TextStyle(
                                            color: themeChange.darkTheme
                                                ? CupertinoColors.white
                                                : CupertinoColors.black,
                                          ),
                                        ),
                                      )),
                            );
                          } else {
                            return Center(
                              child: Text('Nessuno storico presente'),
                            );
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  : FutureBuilder(
                      future: getHistoryCaScan(idManifestazione, barcode,
                          envirormentProvider.envirormentState),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          listOfHistory = snapshot.data as List<History>;
                          if (listOfHistory.length > 0) {
                            return SafeArea(
                              bottom: false,
                              child: ListView.builder(
                                  itemCount: listOfHistory.length,
                                  itemBuilder: (context, index) => ListTile(
                                        title: Text(
                                          listOfHistory[index].description,
                                          style: TextStyle(
                                            color: themeChange.darkTheme
                                                ? CupertinoColors.white
                                                : CupertinoColors.black,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${listOfHistory[index].gate} ${listOfHistory[index].data}",
                                          style: TextStyle(
                                            color: themeChange.darkTheme
                                                ? CupertinoColors.white
                                                : CupertinoColors.black,
                                          ),
                                        ),
                                      )),
                            );
                          } else {
                            return Center(
                              child: Text('Nessuno storico presente'),
                            );
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )),
        ),
      ),
    ));
  }

  Future<List<History>> getHistoryScan(int idManifestazione, int idCorso,
      String barcode, Envirorment envirorment) {
    HistoryService historyService = HistoryService();
    Future<List<History>> requestVisitors = historyService.requestHistory(
        idManifestazione, idCorso, barcode, envirorment);
    return requestVisitors;
  }

  Future<List<History>> getHistoryCaScan(
      int idManifestazione, String barcode, Envirorment envirorment) {
    HistoryCaService historyService = HistoryCaService();
    Future<List<History>> requestVisitors =
        historyService.requestHistoryCa(idManifestazione, barcode, envirorment);
    return requestVisitors;
  }
}
