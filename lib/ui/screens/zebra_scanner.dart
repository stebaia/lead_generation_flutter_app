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
import 'package:lead_generation_flutter_app/l10n/app_localizations.dart';
import 'package:lead_generation_flutter_app/model/user_model/user.dart';
import 'package:lead_generation_flutter_app/network/history_service.dart';
import 'package:lead_generation_flutter_app/network/visitors_service.dart';
import 'package:lead_generation_flutter_app/provider/envirorment_provider.dart';
import 'package:lead_generation_flutter_app/provider/offline_mode_provider.dart';
import 'package:lead_generation_flutter_app/store/infoCurrentPeopleBox_store/infoCurrentPeopleBox_store.dart';
import 'package:lead_generation_flutter_app/store/normalScan_store/normalScan_store.dart';
import 'package:lead_generation_flutter_app/store/visibility_store/visibility_store.dart';
import 'package:lead_generation_flutter_app/utils_backup/theme/custom_theme.dart';
import 'package:lead_generation_flutter_app/provider/dark_theme_provider.dart';
import 'package:lead_generation_flutter_app/store/dropdown_store/dropdown_store.dart';
import 'package:lead_generation_flutter_app/model/id_value_model.dart';
import 'package:lead_generation_flutter_app/model/course_model/course.dart';
import 'package:lead_generation_flutter_app/network/course_service.dart';
import 'package:lead_generation_flutter_app/network/logout_service.dart';
import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';
import 'package:lead_generation_flutter_app/ui/screens/login_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositor_detail_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/zebra_scanner_expositor.dart';

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

  // Variabili per la dropdown dei corsi
  final dropDownStore = DropdownStore();
  List<IdValueObject> coursesDropdownItems = [];
  List<Course> availableCourses = [];
  CourseService courseService = CourseService();

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

    // Carica i corsi disponibili
    _loadCourses();
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
                  AppLocalizations.of(context)!.currentPeople,
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

    final themeChange = Provider.of<DarkThemeProvider>(context);
    final envirormentTheme = Provider.of<EnvirormentProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: ThemeHelper.primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: ThemeHelper.primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.user.email,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "User ID: ${widget.user.id}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(AppLocalizations.of(context)!.scan),
                  selected: true,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "PREFERENZE",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
                Consumer<OfflineModeProvider>(
                  builder: (context, offlineMode, child) => ListTile(
                    leading: Icon(CupertinoIcons.wifi_slash),
                    title: Text('Offline Mode'),
                    trailing: CupertinoSwitch(
                      value: offlineMode.getOfflineMode,
                      onChanged: (value) async {
                        await DatabaseHelper.instance
                            .getOfflineScan()
                            .then((scans) {
                          if (scans.isNotEmpty) {
                            // Qui andrebbe mostrato il dialog per inviare i dati offline
                          }
                        });
                        offlineMode.offlineMode = value;
                      },
                    ),
                  ),
                ),
                Consumer<DarkThemeProvider>(
                  builder: (context, themeChange, child) => ListTile(
                    leading: Icon(CupertinoIcons.moon),
                    title: Text('Dark Mode'),
                    trailing: CupertinoSwitch(
                      value: themeChange.darkTheme,
                      onChanged: (value) {
                        themeChange.darkTheme = value;
                      },
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(AppLocalizations.of(context)!.logout),
                  onTap: () {
                    Navigator.of(context)
                        .restorablePush(_dialogBuilder, arguments: {
                      'idUser': widget.user.id,
                      'envirorment':
                          envirormentProvider.envirormentState.toString()
                    });
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: ThemeHelper.primaryColor),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: ThemeHelper.primaryColor,
                  size: 30,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Text(
              widget.user.manifestationName != null &&
                      widget.user.manifestationName!.isNotEmpty
                  ? widget.user.manifestationName!
                  : AppLocalizations.of(context)!.scan,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              Observer(builder: (_) => getHistory(context)),
            ],
            bottom: TabBar(
                controller: _controller,
                labelColor: Colors.black,
                tabs: tabBarWidget(),
                indicatorWeight: 6,
                indicatorColor: ThemeHelper.primaryColor),
          ),
          backgroundColor:
              themeChange.darkTheme ? Colors.black26 : Colors.white,
          body: Column(
            children: [
              // Barra per selezionare il corso subito sotto l'AppBar
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? Colors.black : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildElegantCourseSelector(themeChange.darkTheme),
                    ),
                  ],
                ),
              ),
              // Contenuto principale
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 200,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(24),
                        child: Stack(
                          children: [
                            Container(
                              child: Center(
                                  child: lastBarcode != ""
                                      ? Text(
                                          'Ultimo codice scannerizzato: $lastBarcode',
                                          style: TextStyle(
                                            color: themeChange.darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        )
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
                ),
              ),
            ],
          )),
    );
  }

  // Metodo per caricare i corsi disponibili
  Future<void> _loadCourses() async {
    if (widget.user.manifestationId != null) {
      try {
        print(
            "Caricamento corsi per manifestazione ID: ${widget.user.manifestationId}");
        final courses = await courseService.requestCourses(
            widget.user.manifestationId.toString(),
            widget.user.id ?? 0,
            envirormentProvider.envirormentState);

        print("Corsi ricevuti: ${courses.length}");

        // Se non ci sono corsi ma l'utente ne ha uno corrente, aggiungiamolo
        if (courses.isEmpty &&
            widget.user.courseId != null &&
            widget.user.courseName != null) {
          print("Aggiungo il corso corrente alla lista vuota");
          courses.add(Course(
              id: widget.user.courseId!, description: widget.user.courseName!));
        }

        setState(() {
          availableCourses = courses;
          coursesDropdownItems = _mapCoursesToDropdownItems(courses);

          // Imposta il corso attualmente selezionato
          if (widget.user.courseId != null && widget.user.courseName != null) {
            final currentCourse = IdValueObject(
                id: widget.user.courseId!, value: widget.user.courseName!);

            // Verifica se il corso esiste nella lista
            bool courseExists = coursesDropdownItems
                .any((item) => item.id == widget.user.courseId);

            if (courseExists) {
              // Trova l'elemento corrispondente nella lista
              final matchingCourse = coursesDropdownItems.firstWhere(
                  (item) => item.id == widget.user.courseId,
                  orElse: () => coursesDropdownItems.isNotEmpty
                      ? coursesDropdownItems.first
                      : currentCourse);
              dropDownStore.setSelectedItem(matchingCourse);
            } else if (coursesDropdownItems.isNotEmpty) {
              // Se il corso non esiste nella lista, usa il primo corso disponibile
              dropDownStore.setSelectedItem(coursesDropdownItems.first);
            } else {
              // Altrimenti usa il corso corrente
              dropDownStore.setSelectedItem(currentCourse);
              // Aggiungi il corso corrente alla lista se non è vuoto
              if (widget.user.courseName!.isNotEmpty) {
                coursesDropdownItems.add(currentCourse);
              }
            }
          } else if (courses.isNotEmpty) {
            dropDownStore.setSelectedItem(coursesDropdownItems.first);
          }
        });
      } catch (e) {
        print('Errore nel caricamento dei corsi: $e');
        // Assicuriamoci di avere almeno il corso corrente nella lista
        if (widget.user.courseId != null &&
            widget.user.courseName != null &&
            widget.user.courseName!.isNotEmpty) {
          final currentCourse = IdValueObject(
              id: widget.user.courseId!, value: widget.user.courseName!);
          setState(() {
            coursesDropdownItems = [currentCourse];
            dropDownStore.setSelectedItem(currentCourse);
          });
        }
      }

      // Forza il caricamento del corso corrente se la lista è vuota
      if (coursesDropdownItems.isEmpty &&
          widget.user.courseId != null &&
          widget.user.courseName != null) {
        print("Forzo l'aggiunta del corso corrente");
        final currentCourse = IdValueObject(
            id: widget.user.courseId!, value: widget.user.courseName!);
        setState(() {
          coursesDropdownItems = [currentCourse];
          dropDownStore.setSelectedItem(currentCourse);
        });
      }
    }
  }

  // Converte i corsi in elementi per la dropdown
  List<IdValueObject> _mapCoursesToDropdownItems(List<Course> courses) {
    return courses
        .map(
            (course) => IdValueObject(id: course.id, value: course.description))
        .toList();
  }

  // Costruisce il widget della dropdown
  Widget _buildElegantCourseSelector(bool isDarkMode) {
    // Verifica se ci sono corsi disponibili
    if (coursesDropdownItems.isEmpty) {
      // Se non ci sono corsi ma l'utente ha un corso, aggiungiamolo
      if (widget.user.courseId != null && widget.user.courseName != null) {
        final currentCourse = IdValueObject(
            id: widget.user.courseId!, value: widget.user.courseName!);
        coursesDropdownItems = [currentCourse];
        if (dropDownStore.selectedItem == null) {
          dropDownStore.setSelectedItem(currentCourse);
        }
      } else {
        // Creiamo un elemento placeholder
        coursesDropdownItems = [
          IdValueObject(id: -1, value: "Seleziona corso")
        ];
        dropDownStore.setSelectedItem(coursesDropdownItems.first);
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? Colors.grey[800] : Colors.white,
      ),
      child: Row(
        children: [
          Icon(
            Icons.school,
            color: ThemeHelper.primaryColor,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: Observer(
                builder: (context) => DropdownButton<IdValueObject>(
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: ThemeHelper.primaryColor,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  hint: Text(
                    AppLocalizations.of(context)!.selectCourse,
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : Colors.black.withOpacity(0.5),
                    ),
                  ),
                  // Assicurati che il valore selezionato sia nella lista degli elementi
                  value:
                      coursesDropdownItems.contains(dropDownStore.selectedItem)
                          ? dropDownStore.selectedItem
                          : (coursesDropdownItems.isNotEmpty
                              ? coursesDropdownItems.first
                              : null),
                  onChanged: (IdValueObject? newValue) async {
                    if (newValue != null) {
                      // Aggiorna lo store e l'utente
                      dropDownStore.setSelectedItem(newValue);
                      setState(() {
                        widget.user.courseId = newValue.id;
                        widget.user.courseName = newValue.value;
                      });

                      // Aggiorna il database e ricarica i visitatori
                      await DatabaseHelper.instance.update(widget.user);
                      try {
                        // Ricarica i visitatori
                        infoCurrentPeopleBoxStore.fetchVisitors(
                            widget.user.manifestationId.toString(),
                            widget.user.courseId.toString(),
                            envirormentProvider.envirormentState);
                      } catch (e) {
                        print('Errore nel caricamento dei visitatori: $e');
                      }
                    }
                  },
                  dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  items: coursesDropdownItems
                      .map<DropdownMenuItem<IdValueObject>>(
                          (IdValueObject valueItem) {
                    return DropdownMenuItem<IdValueObject>(
                      value: valueItem,
                      child: Text(
                        valueItem.value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog per il logout
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

  static Future<int> requestLogout(int id, Envirorment envirorment) {
    LogoutService logoutService = LogoutService();
    Future<int> responseLogout = logoutService.requestLogout(id, envirorment);
    return responseLogout;
  }
}
