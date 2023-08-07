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
import 'package:lead_generation_flutter_app/ui/components/history_modal.dart';
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

class ZebraScannerPage extends StatefulWidget {
  ZebraScannerPage({super.key, required this.user});
  User user;
  @override
  State<ZebraScannerPage> createState() => _ZebraScannerPageState();
}

class _ZebraScannerPageState extends State<ZebraScannerPage>
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
      //if (visibilityStore.isVisible) {
      SVProgressHUD.show();
      if (widget.user.courseName != null) {
        visibilityStore.setSelected(false);
        codiceScan = barcode;
        lastBarcode = barcode;
        SoundHelper.play(0, player);
        //cameraController.stop();
        if (offlineMode.getOfflineMode) {
          setState(() {
            lastBarcode = barcode;
          });
          //SOLO DA METTERE NELLA SCANNERIZZAZIONE NORMALE
          
          await DatabaseHelper.instance.addOfflineScan(OfflineScan(
            idManifestazione: widget.user.manifestationId!,
            codice: codiceScan,
            dataOra: DateTime.now().toString(),
            idCorso: widget.user.courseId!,
            idUtilizzatore: widget.user.id.toString(),
            ckExit: _controller.index.toString(),
          ));
          await DatabaseHelper.instance.getOfflineScan().then(
              (value) => infoCurrentPeopleBoxStore.setScanState(value.length));
          SVProgressHUD.dismiss();
        } else {
          scanStore
              .fetchScan(
                  widget.user.manifestationId.toString(),
                  codiceScan,
                  widget.user.id.toString(),
                  widget.user.courseId.toString(),
                  _controller.index.toString(),
                  envirormentProvider.envirormentState)
              .then((mValue) {
            infoCurrentPeopleBoxStore.fetchVisitors(
                widget.user.manifestationId.toString(),
                widget.user.courseId.toString(),
                envirormentProvider.envirormentState);
          });
        }

        debugPrint('Barcode found! $barcode');
      } else {
        visibilityStore.setSelected(false);
        codiceScan = barcode;
        lastBarcode = barcode;
        SoundHelper.play(0, player);
        //cameraController.stop();
        if (offlineMode.getOfflineMode) {
          setState(() {
            lastBarcode = barcode;
          });
          //SOLO DA METTERE NELLA SCANNERIZZAZIONE NORMALE
          await DatabaseHelper.instance.addOfflineScan(OfflineScan(
            idManifestazione: widget.user.manifestationId!,
            codice: codiceScan,
            dataOra: DateTime.now().toString(),
            idCorso: 0,
            idUtilizzatore: widget.user.id.toString(),
            ckExit: _controller.index.toString(),
          ));
          await DatabaseHelper.instance.getOfflineScan().then(
              (value) => infoCurrentPeopleBoxStore.setScanState(value.length));
              SVProgressHUD.dismiss();
        } else {
          scanStore
              .fetchScan(
                  widget.user.manifestationId.toString(),
                  codiceScan,
                  widget.user.id.toString(),
                  "0",
                  _controller.index.toString(),
                  envirormentProvider.envirormentState)
              .then((mValue) {
            infoCurrentPeopleBoxStore.fetchVisitors(
                widget.user.manifestationId.toString(),
                "0",
                envirormentProvider.envirormentState);
          });
        }

        debugPrint('Barcode found! $barcode');
      }

      // }
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

    Widget getHistory(BuildContext context) {
      return widget.user.courseName != null
          ? IconButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25))),
                          margin: EdgeInsets.only(top: 50),
                          child: ComplexModal(
                              idManifestazione: widget.user.manifestationId!,
                              idCorso: widget.user.courseId!,
                              barcode: lastBarcode));
                    });
              },
              icon: Icon(
                Icons.history_sharp,
                color: Colors.black,
              ))
          :  IconButton(
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        margin: EdgeInsets.only(top: 50),
                        child: ComplexModal(
                            idManifestazione: widget.user.manifestationId!,
                            idCorso: widget.user.courseId,
                            barcode: lastBarcode));
                  });
            },
            icon: Icon(
              Icons.history_sharp,
              color: Colors.black,
            ));
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                SVProgressHUD.dismiss();
                Navigator.pop(context);
              },
            ),
            actions: [
              Observer(builder: (_) => getHistory(context)),
            ],
            title: Column(
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
                      ? widget.user.courseName!.length > 50
                          ? widget.user.courseName!
                                  .substring(0, 50)
                                  .capitalize() +
                              ".."
                          : widget.user.courseName!
                      : AppLocalizations.of(context).scanQrCode,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
            bottom: TabBar(
                controller: _controller,
                labelColor: Colors.black,
                tabs: tabBarWidget(),
                indicatorWeight: 6,
                indicatorColor: ThemeHelper.primaryColor),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 120,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(24),
                  child: Stack(
                    children: [
                      Container(
                        child: Center(
                            child: lastBarcode != ""
                                ? Text(
                                    'Ultimo codice scannerizzato: $lastBarcode')
                                : Container()),
                      ),
                      Observer(
                        builder: (context) => Align(
                            alignment: Alignment.bottomCenter,
                            child: infoCurrentPeopleBox(
                                offlineMode.getOfflineMode)),
                      ),
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
