import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/model/history_model/history.dart';
import 'package:lead_generation_flutter_app/provider/envirorment_provider.dart';
import 'package:lead_generation_flutter_app/utils/envirorment.dart';
import 'dart:math' as math;

import '../../network/history_service.dart';
import '../../provider/dark_theme_provider.dart';
import '../../utils/theme/custom_theme.dart';

class ComplexModal extends StatefulWidget {
  ComplexModal(
      {Key? key,
      required this.idManifestazione,
      required this.idCorso,
      required this.barcode})
      : super(
          key: key,
        );

  final int idManifestazione;
  final int idCorso;
  final String barcode;
  @override
  State<ComplexModal> createState() => _MyComplexModalState();
}

class _MyComplexModalState extends State<ComplexModal> {
  List<History> listOfHistory = [];

  @override
  Widget build(BuildContext rootContext) {
    final themeChange = Provider.of<DarkThemeProvider>(rootContext);
    final envirormentProvider = Provider.of<EnvirormentProvider>(rootContext);
    int idCorso = widget.idCorso;
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
              child: FutureBuilder(
                future: getHistoryScan(idManifestazione, idCorso, barcode,
                    envirormentProvider.envirormentState),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (listOfHistory.length == 0) {
                      listOfHistory = snapshot.data as List<History>;
                    }
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
}
