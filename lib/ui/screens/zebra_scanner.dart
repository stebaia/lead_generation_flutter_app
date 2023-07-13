import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lead_generation_flutter_app/utils/extension.dart';
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
    void _onEvent(event) {
    setState(() {
      Map barcodeScan = jsonDecode(event);
      _barcodeString = "Barcode: " + barcodeScan['scanData'];
      _barcodeSymbology = "Symbology: " + barcodeScan['symbology'];
      _scanTime = "At: " + barcodeScan['dateTime'];

    });
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Zebra scanner"),
            bottom: TabBar(
                controller: _controller,
                labelColor: Colors.black,
                tabs: tabBarWidget(),
                indicatorWeight: 6,
                indicatorColor: ThemeHelper.primaryColor),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(24),
              child: Column(
                
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      widget.user.manifestationName != null
                          ? widget.user.manifestationName!.length > 60
                              ? widget.user.manifestationName!
                                      .substring(0, 60)
                                      .capitalize() +
                                  ".."
                              : widget.user.manifestationName!.capitalize()
                          : AppLocalizations.of(context).scanQrCode,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
                          textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30,),
                  const Text(
                    'Usa i pulsanti a lato\noppure\nutilizza il bottone sottostante',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        
                        fontSize: 14),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                      onPressed: () => startScan(),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ThemeHelper.primaryColor),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Scan!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Icon(
                                CupertinoIcons.qrcode,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      )),
                      
                      Align(
                    alignment: Alignment.bottomCenter,
                    child: infoCurrentPeopleBox(offlineMode.getOfflineMode)),
                ],
              ),
            ),
          )),
    );
  }
}
