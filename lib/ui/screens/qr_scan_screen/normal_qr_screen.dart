import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/model/check_manager_model/check_model.dart';
import 'package:lead_generation_flutter_app/model/history_model/history.dart';
import 'package:lead_generation_flutter_app/network/history_service.dart';
import 'package:lead_generation_flutter_app/store/infoCurrentPeopleBox_store/infoCurrentPeopleBox_store.dart';
import 'package:lead_generation_flutter_app/store/normalScan_store/normalScan_store.dart';
import 'package:lead_generation_flutter_app/store/visibility_store/visibility_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lead_generation_flutter_app/ui/components/history_modal.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositors_screen.dart';
import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';
import 'package:lead_generation_flutter_app/utils_backup/extension.dart';
import 'package:lead_generation_flutter_app/utils_backup/sound_helper.dart';
import 'package:lead_generation_flutter_app/utils_backup/sound_play.dart';
import 'package:lead_generation_flutter_app/utils_backup/theme/custom_theme.dart';
import '../../../db/database_helper.dart';
import '../../../model/scan_offline.dart';
import '../../../model/user_model/user.dart';
import '../../../network/visitors_service.dart';
import '../../../provider/envirorment_provider.dart';
import '../../../provider/offline_mode_provider.dart';
import '../../../utils_backup/scanner_animations.dart';

class NormalQrScreen extends StatefulWidget {
  NormalQrScreen({Key? key, required this.user}) : super(key: key);
  User user;
  @override
  State<NormalQrScreen> createState() => _NormalQrScreenState();
}

class _NormalQrScreenState extends State<NormalQrScreen>
    with TickerProviderStateMixin {
  final player = AudioPlayer();
  EnvirormentProvider envirormentProvider = EnvirormentProvider();
  MobileScannerController cameraController = MobileScannerController();
  late TabController _controller;
  final scanStore = NormalScanStore();
  final visibilityStore = VisibilityStore();
  final infoCurrentPeopleBoxStore = InfoCurrentPeopleBoxStore();
  late AnimationController _animationController;
  bool _animationStopped = false;
  int _selectedIndex = 0;
  String codiceScan = "";
  String lastBarcode = "";
  String visitors = "0";

  VisitorsService visitorsService = VisitorsService();
  HistoryService historyService = HistoryService();
  static const MethodChannel methodChannel =
      MethodChannel('com.darryncampbell.datawedgeflutter/command');

  @override
  void initState() {
    _controller = TabController(length: lenghtTabBar(), vsync: this);
    _animationController = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    animateScanAnimation(false);
    _createProfile("DataWedgeFlutterDemo");
    super.initState();
  }

  Future<void> _createProfile(String profileName) async {
    try {
      await methodChannel.invokeMethod(
          'createDataWedgeProfileDisabled', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offlineMode = Provider.of<OfflineModeProvider>(context);
    return DefaultTabController(
        length: lenghtTabBar(),
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: (Icon(
                  Icons.close,
                  color: Colors.white,
                )),
                onPressed: () {
                  SVProgressHUD.dismiss();
                  Navigator.pop(context);
                },
              ),
              actions: [
                Observer(builder: (_) => getHistory(context)),
              ],
              backgroundColor: Colors.black,
              bottom: TabBar(
                  controller: _controller,
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  tabs: tabBarWidget(),
                  indicatorWeight: 6,
                  indicatorColor: ThemeHelper.primaryColor),
              title: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.manifestationName != null
                          ? widget.user.manifestationName!.length > 60
                              ? widget.user.manifestationName!
                                      .substring(0, 60)
                                      .capitalize() +
                                  ".."
                              : widget.user.manifestationName!.capitalize()
                          : AppLocalizations.of(context)!.scanQrCode,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      widget.user.courseName != null
                          ? widget.user.courseName!.length > 50
                              ? widget.user.courseName!
                                      .substring(0, 50)
                                      .capitalize() +
                                  ".."
                              : widget.user.courseName!
                          : AppLocalizations.of(context)!.scanQrCode,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                MobileScanner(
                    allowDuplicates: true,
                    controller: cameraController,
                    onDetect: (barcode, args) async {
                      //cameraController.stop();
                      //cameraController.stop();
                      if (barcode.rawValue == null) {
                        debugPrint('Failed to scan Barcode');
                      } else {
                        final String code = barcode.rawValue!;
                        if (visibilityStore.isVisible) {
                          if (widget.user.courseName != null) {
                            if (codiceScan != barcode.rawValue) {
                              SVProgressHUD.show();
                              visibilityStore.setSelected(false);
                              codiceScan = barcode.rawValue!;
                              lastBarcode = barcode.rawValue!;
                              SoundHelper.play(0, player);
                              //cameraController.stop();
                              if (offlineMode.getOfflineMode) {
                                //SOLO DA METTERE NELLA SCANNERIZZAZIONE NORMALE

                                await DatabaseHelper.instance
                                    .addOfflineScan(OfflineScan(
                                  idManifestazione:
                                      widget.user.manifestationId!,
                                  codice: codiceScan,
                                  dataOra: DateTime.now().toString(),
                                  idCorso: widget.user.courseId!,
                                  idUtilizzatore: widget.user.id.toString(),
                                  ckExit: _controller.index.toString(),
                                ));
                                await DatabaseHelper.instance
                                    .getOfflineScan()
                                    .then((value) => infoCurrentPeopleBoxStore
                                        .setScanState(value.length));
                                SVProgressHUD.dismiss();
                                visibilityStore.setSelected(true);
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

                              debugPrint('Barcode found! $code');
                            } else {
                              SVProgressHUD.dismiss();
                            }
                          } else {
                            if (codiceScan != barcode.rawValue) {
                              SVProgressHUD.show();
                              visibilityStore.setSelected(false);
                              codiceScan = barcode.rawValue!;
                              lastBarcode = barcode.rawValue!;
                              SoundHelper.play(0, player);
                              //cameraController.stop();
                              if (offlineMode.getOfflineMode) {
                                //SOLO DA METTERE NELLA SCANNERIZZAZIONE NORMALE
                                await DatabaseHelper.instance
                                    .addOfflineScan(OfflineScan(
                                  idManifestazione:
                                      widget.user.manifestationId!,
                                  codice: codiceScan,
                                  dataOra: DateTime.now().toString(),
                                  idCorso: 0,
                                  idUtilizzatore: widget.user.id.toString(),
                                  ckExit: _controller.index.toString(),
                                ));
                                await DatabaseHelper.instance
                                    .getOfflineScan()
                                    .then((value) => infoCurrentPeopleBoxStore
                                        .setScanState(value.length));
                                SVProgressHUD.dismiss();
                                visibilityStore.setSelected(true);
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

                              debugPrint('Barcode found! $code');
                            } else {
                              SVProgressHUD.dismiss();
                            }
                          }
                        }
                      }
                    }),
                Observer(
                    builder: ((context) => Visibility(
                          visible: visibilityStore.isVisible,
                          child: ScannerAnimation(
                            _animationStopped,
                            MediaQuery.of(context).size.width,
                            animation: _animationController,
                          ),
                        ))),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Observer(
                        builder: (_) =>
                            infoCurrentPeopleBox(offlineMode.getOfflineMode))),
                Observer(
                  builder: (context) => getLayerScan(),
                ),
              ],
            )));
  }

  int lenghtTabBar() => 2;

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

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
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
              color: Colors.white,
            ))
        : IconButton(
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
              color: Colors.white,
            ));
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
                Text(
                  "Click per riprovare",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
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
                AppLocalizations.of(context)!.currentPeople,
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(40))),
      );
    }
  }
}
