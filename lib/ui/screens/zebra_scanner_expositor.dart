import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:lead_generation_flutter_app/db/database_helper.dart';
import 'package:lead_generation_flutter_app/model/check_manager_model/check_model.dart';
import 'package:lead_generation_flutter_app/model/scan_offline.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositor_detail_screen.dart';
import 'package:lead_generation_flutter_app/utils/extension.dart';
import 'package:lead_generation_flutter_app/utils/sound_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lead_generation_flutter_app/model/user_model/user.dart';
import 'package:lead_generation_flutter_app/network/history_service.dart';
import 'package:lead_generation_flutter_app/network/visitors_service.dart';
import 'package:lead_generation_flutter_app/provider/envirorment_provider.dart';
import 'package:lead_generation_flutter_app/provider/offline_mode_provider.dart';
import 'package:lead_generation_flutter_app/store/infoCurrentPeopleBox_store/infoCurrentPeopleBox_store.dart';
import 'package:lead_generation_flutter_app/store/normalScan_store/normalScan_store.dart';
import 'package:lead_generation_flutter_app/store/visibility_store/visibility_store.dart';
import 'package:lead_generation_flutter_app/utils_backup/theme/custom_theme.dart';

class ZebraScannerExpositorPage extends StatefulWidget {
  ZebraScannerExpositorPage({super.key, required this.user});
  User user;
  @override
  State<ZebraScannerExpositorPage> createState() =>
      _ZebraScannerExpositorPageState();
}

class _ZebraScannerExpositorPageState extends State<ZebraScannerExpositorPage>
    with TickerProviderStateMixin {
  final player = AudioPlayer();
  EnvirormentProvider envirormentProvider = EnvirormentProvider();
  late TabController _controller;
  String codiceScan = "";
  String lastBarcode = "";
  final scanStore = NormalScanStore();
  final visibilityStore = VisibilityStore();
  final infoCurrentPeopleBoxStore = InfoCurrentPeopleBoxStore();
  VisitorsService visitorsService = VisitorsService();
  HistoryService historyService = HistoryService();
  static const MethodChannel methodChannel =
      MethodChannel('com.darryncampbell.datawedgeflutter/command');
  static const EventChannel scanChannel =
      EventChannel('com.darryncampbell.datawedgeflutter/scan');

  //  This example implementation is based on the sample implementation at
  //  https://github.com/flutter/flutter/blob/master/examples/platform_channel/lib/main.dart
  //  That sample implementation also includes how to return data from the method
  Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson =
          jsonEncode({"command": command, "parameter": parameter});

      await methodChannel.invokeMethod(
          'sendDataWedgeCommandStringParameter', argumentAsJson);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  Future<void> _createProfile(String profileName) async {
    try {
      await methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  String _barcodeString = "";
  String _barcodeSymbology = "";
  String _scanTime = "";

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);

    _createProfile("DataWedgeFlutterDemo");
  }

  List<Widget> tabBarWidget() => [
        Tab(text: 'Entrata'),
        Tab(
          text: 'Uscita',
        )
      ];

  Future<int> getVisitors() {
    Future<int> requestVisitors = visitorsService.requestVisitors(
        widget.user.manifestationId.toString(),
        widget.user.courseId!,
        envirormentProvider.envirormentState);
    return requestVisitors;
  }

  @override
  Widget build(BuildContext context) {
    final offlineMode = Provider.of<OfflineModeProvider>(context);

    Future<void> _onEvent(event) async {
      Map barcodeScan = jsonDecode(event);
      String barcode = barcodeScan['scanData'].toString();
      _barcodeString = "Barcode: " + barcodeScan['scanData'];
      _barcodeSymbology = "Symbology: " + barcodeScan['symbology'];
      _scanTime = "At: " + barcodeScan['dateTime'];
      if (codiceScan != barcode) {
        codiceScan = barcode;
        lastBarcode = barcode;
        SoundHelper.play(0, player);

        //Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ExpositorDetailScreen(
                      user: widget.user,
                      isNew: false,
                      codice20: codiceScan,
                    ))));

        // }
      }
    }

    Widget getLayerScan() {
      SVProgressHUD.dismiss();
      if (int.parse(scanStore.scanState.value!).isBetween(100, 199) ||
          int.parse(scanStore.scanState.value!).isBetween(300, 399)) {
        SoundHelper.play(1, player);
        return GestureDetector(
          child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    scanStore.scanState.description!,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Scansiona nuovo ticket",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              ),
              color: Color.fromARGB(212, 13, 168, 83)),
          onTap: () {
            visibilityStore.setSelected(true);
            codiceScan = "";
            //cameraController.start();
            scanStore
                .setScanState(CheckManagerResult(value: "0", description: ""));
          },
        );
      } else if (int.parse(scanStore.scanState.value!).isBetween(200, 299)) {
        SoundHelper.play(2, player);
        return GestureDetector(
          child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    scanStore.scanState.description!,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  /*Text(
                  "Click per riprovare",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),*/
                ],
              ),
              color: Color.fromARGB(213, 230, 7, 7)),
          onTap: () {
            visibilityStore.setSelected(true);
            codiceScan = "";
            //cameraController.start();
            scanStore
                .setScanState(CheckManagerResult(value: "0", description: ""));
          },
        );
      } else {
        return Container(
            height: double.infinity,
            width: double.infinity,
            color: Color(0x00FFFFFF));
      }
    }

    Widget infoCurrentPeopleBox(bool offlineMode) {
      return Container(
        margin: EdgeInsets.all(36),
        height: 60,
        width: 220,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${infoCurrentPeopleBoxStore.visitorState} " +
                  AppLocalizations.of(context).currentPeople,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 12,
            ),
            offlineMode == true
                ? Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                  )
                : Container()
          ],
        )),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(40))),
      );
    }

    Widget getScanBoxState() {
      if (int.parse(scanStore.scanState.value!).isBetween(100, 199) ||
          int.parse(scanStore.scanState.value!).isBetween(300, 399)) {
        SoundHelper.play(1, player);
        return Container(
          margin: EdgeInsets.all(36),
          height: 60,
          width: 220,
          child: Center(
            child: Text(
              scanStore.scanState.description!,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(40))),
        );
      } else if (int.parse(scanStore.scanState.value!).isBetween(200, 299)) {
        SoundHelper.play(2, player);
        return Container(
          margin: EdgeInsets.all(36),
          height: 60,
          width: 220,
          child: Center(
            child: Text(
              scanStore.scanState.description!,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(40))),
        );
      } else {
        return Container(
          margin: EdgeInsets.all(36),
          height: 60,
          width: 220,
          child: Center(
            child: Text(
              'Scannerizza un qr code',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(40))),
        );
      }
    }

    void _onError(Object error) {
      setState(() {
        _barcodeString = "Barcode: error";
        _barcodeSymbology = "Symbology: error";
        _scanTime = "At: error";
      });
    }

    void startScan() {
      setState(() {
        _sendDataWedgeCommand(
            "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "START_SCANNING");
      });
    }

    void stopScan() {
      setState(() {
        _sendDataWedgeCommand(
            "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "STOP_SCANNING");
      });
    }

    scanChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.manifestationName != null
                        ? widget.user.manifestationName!.length > 60
                            ? widget.user.manifestationName!
                                    .substring(0, 60)
                                    .capitalize() +
                                ".."
                            : widget.user.manifestationName!.capitalize()
                        : AppLocalizations.of(context).scanQrCode,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Text(
                    widget.user.courseName != null
                        ? widget.user.courseName!.length > 60
                            ? widget.user.courseName!
                                    .substring(0, 60)
                                    .capitalize() +
                                ".."
                            : widget.user.courseName!.capitalize()
                        : AppLocalizations.of(context).scanQrCode,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(24),
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child:
                              infoCurrentPeopleBox(offlineMode.getOfflineMode)),
                    ],
                  ),
                ),
              ),
              Observer(
                builder: (context) => getLayerScan(),
              ),
            ],
          )),
    );
  }
}
