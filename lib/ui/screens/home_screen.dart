import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/model/user_model/user.dart';
import 'package:lead_generation_flutter_app/store/bottomNavigationBar_store/bottomNavigation_store.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositors_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/settings_screen.dart';
import 'package:lead_generation_flutter_app/utils_backup/theme/custom_theme.dart';
import 'package:lead_generation_flutter_app/l10n/app_localizations.dart';
import 'package:lead_generation_flutter_app/store/visibility_store/visibility_store.dart';
import 'package:lead_generation_flutter_app/store/normalScan_store/normalScan_store.dart';
import 'package:lead_generation_flutter_app/store/infoCurrentPeopleBox_store/infoCurrentPeopleBox_store.dart';
import 'package:lead_generation_flutter_app/store/enable_store/enable_store.dart';
import 'package:lead_generation_flutter_app/utils_backup/scanner_animations.dart';
import 'package:lead_generation_flutter_app/utils_backup/sound_helper.dart';
import 'package:lead_generation_flutter_app/network/visitors_service.dart';
import 'package:lead_generation_flutter_app/network/history_service.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositor_detail_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/zebra_scanner.dart';
import 'package:lead_generation_flutter_app/ui/screens/zebra_scanner_expositor.dart';
import 'package:lead_generation_flutter_app/provider/offline_mode_provider.dart';
import 'package:lead_generation_flutter_app/db/database_helper.dart';
import 'package:lead_generation_flutter_app/model/scan_offline.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:lead_generation_flutter_app/utils_backup/extension.dart';
import 'package:lead_generation_flutter_app/store/dropdown_store/dropdown_store.dart';
import 'package:lead_generation_flutter_app/model/id_value_model.dart';
import 'package:lead_generation_flutter_app/model/course_model/course.dart';
import 'package:lead_generation_flutter_app/network/course_service.dart';
import 'package:lead_generation_flutter_app/network/logout_service.dart';
import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';
import 'package:lead_generation_flutter_app/ui/screens/login_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/qr_scan_screen/normal_qr_screen.dart';
import 'package:lead_generation_flutter_app/model/check_manager_model/check_model.dart';

import '../../provider/dark_theme_provider.dart';
import '../../provider/envirorment_provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  BottomNavigationStore bottomNavigationStore = BottomNavigationStore();
  late User user;
  bool isScanning = true;

  // Variabili per QR Scanner
  final player = AudioPlayer();
  EnvirormentProvider envirormentProvider = EnvirormentProvider();
  MobileScannerController cameraController = MobileScannerController();
  final scanStore = NormalScanStore();
  final visibilityStore = VisibilityStore();
  final infoCurrentPeopleBoxStore = InfoCurrentPeopleBoxStore();
  final enableStore = EnableStore();
  late AnimationController _animationController;
  bool _animationStopped = false;
  String codiceScan = "";
  String lastBarcode = "";
  String visitors = "0";
  bool enableCamera = true;

  // Variabili per la dropdown dei corsi
  final dropDownStore = DropdownStore();
  List<IdValueObject> coursesDropdownItems = [];
  List<Course> availableCourses = [];
  CourseService courseService = CourseService();

  VisitorsService visitorsService = VisitorsService();
  HistoryService historyService = HistoryService();

  // Variabile per il controller delle tabs
  late TabController _tabController;

  List<Widget> _widgetPages(User mUser) {
    List<Widget> listPages = [];
    listPages.add(
        Container()); // Placeholder per la scansione QR (verrà sostituito dinamicamente)
    if (mUser.userType == 106) {
      listPages.add(ExpositorsScreen(user: user));
    }
    listPages.add(SettingsScreen(user: user));
    return listPages;
  }

  @override
  void initState() {
    user = widget.user;

    // Inizializzazione per QR Scanner
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    animateScanAnimation(false);

    // Imposto la visibilità dello scanner come attiva all'avvio
    visibilityStore.setSelected(true);

    // Inizializza controller per le tab entrata/uscita
    _tabController = TabController(length: 2, vsync: this);

    // Carica i corsi disponibili
    _loadCourses();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // Se si torna all'indice 0 (scanner), assicuriamoci che la scansione sia attiva
      if (index == 0) {
        isScanning = true;
      }
    });
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  Future<int> getVisitors() {
    Future<int> requestVisitors = visitorsService.requestVisitors(
        user.manifestationId.toString(),
        user.courseId!,
        envirormentProvider.envirormentState);
    return requestVisitors;
  }

  // Helper per le schede Entrata/Uscita
  List<Widget> tabBarWidget() => [
        Tab(
          text: AppLocalizations.of(context)!.enter,
        ),
        Tab(
          text: AppLocalizations.of(context)!.exit,
        ),
      ];

  // Widget per le tab di Entrata/Uscita
  Widget _buildEntryExitTabs() {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.darkTheme;

    return Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: tabBarWidget(),
        unselectedLabelColor: isDarkMode ? Colors.grey : Colors.grey.shade600,
        labelColor: isDarkMode ? Colors.white : Colors.black,
        indicatorColor: ThemeHelper.primaryColor,
        indicatorWeight: 3,
        labelPadding: EdgeInsets.symmetric(horizontal: 8),
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.0,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // Funzione aggiornata per la scansione QR con supporto Entrata/Uscita
  void _handleQRScan(String code) {
    if (visibilityStore.isVisible) {
      if (user.courseName != null) {
        if (codiceScan != code) {
          SVProgressHUD.show();
          visibilityStore.setSelected(false);
          codiceScan = code;
          lastBarcode = code;
          SoundHelper.play(0, player);

          final offlineMode =
              Provider.of<OfflineModeProvider>(context, listen: false);
          if (offlineMode.getOfflineMode) {
            // Modalità offline
            DatabaseHelper.instance.addOfflineScan(OfflineScan(
              idManifestazione: user.manifestationId!,
              codice: codiceScan,
              dataOra: DateTime.now().toString(),
              idCorso: user.courseId!,
              idUtilizzatore: user.id.toString(),
              ckExit: _tabController.index
                  .toString(), // Usa indice tab per distinguere entrata/uscita
            ));
            DatabaseHelper.instance.getOfflineScan().then((value) =>
                infoCurrentPeopleBoxStore.setScanState(value.length));
            SVProgressHUD.dismiss();
            visibilityStore.setSelected(true);
          } else {
            // Modalità online
            scanStore
                .fetchScan(
                    user.manifestationId.toString(),
                    codiceScan,
                    user.id.toString(),
                    user.courseId.toString(),
                    _tabController.index
                        .toString(), // Usa indice tab per distinguere entrata/uscita
                    envirormentProvider.envirormentState)
                .then((mValue) {
              infoCurrentPeopleBoxStore.fetchVisitors(
                  user.manifestationId.toString(),
                  user.courseId.toString(),
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

  Widget buildScannerView() {
    return Stack(
      children: [
        // Vista scanner sempre attiva
        Stack(
          children: [
            MobileScanner(
              controller: cameraController,
              onDetect: (barcode) async {
                if (user.userType == 106) {
                  // Logica per ExpositorQrScreen
                  if (enableCamera) {
                    if (barcode.raw == null) {
                      debugPrint('Failed to scan Barcode');
                    } else {
                      if (!barcode.raw![0]["rawValue"].contains("http") &&
                          !barcode.raw![0]["rawValue"].contains("www")) {
                        final String code = barcode.raw![0]["rawValue"];
                        print("TICKET: " + code);
                        if (codiceScan != barcode.raw[0]["rawValue"]) {
                          codiceScan = barcode.raw![0]["rawValue"];
                          lastBarcode = barcode.raw![0]["rawValue"];
                          SoundHelper.play(0, player);
                          setState(() {
                            enableCamera = false;
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ExpositorDetailScreen(
                                        user: user,
                                        isNew: false,
                                        codice20: codiceScan,
                                      )))).then((value) {
                            setState(() {
                              enableCamera = true;
                            });
                          });

                          debugPrint('Barcode found! $code');
                        }
                      }
                    }
                  }
                } else {
                  // Logica per utenti normali - utilizziamo la funzione unificata
                  if (barcode.raw == null) {
                    debugPrint('Failed to scan Barcode');
                  } else {
                    final String code = barcode.raw![0]["rawValue"];
                    _handleQRScan(code);
                  }
                }
              },
            ),
            Observer(
                builder: ((context) => Visibility(
                      visible: visibilityStore.isVisible,
                      child: ScannerAnimation(
                        _animationStopped,
                        MediaQuery.of(context).size.width,
                        animation: _animationController,
                      ),
                    ))),
          ],
        ),
        // Conteggio visitatori in basso
        Align(
          alignment: Alignment.bottomCenter,
          child: Observer(
            builder: (_) {
              final offlineMode =
                  Provider.of<OfflineModeProvider>(context, listen: false);
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
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 12),
                      offlineMode.getOfflineMode
                          ? Icon(Icons.wifi_off, color: Colors.white)
                          : Container()
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
              );
            },
          ),
        ),
        // Stato della scansione (successo/errore)
        Observer(
          builder: (context) {
            // Verifica se c'è uno stato da mostrare
            if (scanStore.scanState.value == null ||
                scanStore.scanState.value == "0") {
              return Container();
            }

            int stateValue = int.parse(scanStore.scanState.value!);

            // Scansione riuscita
            if (stateValue >= 100 && stateValue <= 199 ||
                stateValue >= 300 && stateValue <= 399) {
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
                  scanStore.setScanState(
                      CheckManagerResult(value: "0", description: ""));
                },
              );
            }
            // Scansione fallita
            else if (stateValue >= 200 && stateValue <= 299) {
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
                  scanStore.setScanState(
                      CheckManagerResult(value: "0", description: ""));
                },
              );
            }

            return Container();
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final envirormentTheme = Provider.of<EnvirormentProvider>(context);

    return Observer(
        builder: (_) => Scaffold(
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
                            user.email,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "User ID: ${user.id}",
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
                      selected: bottomNavigationStore.selectedIndex == 0,
                      onTap: () {
                        bottomNavigationStore.setSelected(0);
                        _onItemTapped(0);
                        Navigator.pop(context);
                      },
                    ),
                    // Expositors - disponibile solo per userType 106
                    if (user.userType == 106)
                      ListTile(
                        leading: Icon(Icons.people),
                        title: Text(AppLocalizations.of(context)!.expositors),
                        selected: bottomNavigationStore.selectedIndex == 1,
                        onTap: () {
                          bottomNavigationStore.setSelected(1);
                          _onItemTapped(1);
                          Navigator.pop(context);
                        },
                      ),
                    // Toggles e informazioni aggiuntive
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                    // Offline mode - solo per userType diverso da 106
                    if (user.userType != 106)
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
                                  // Per ora lo omettiamo per semplicità
                                }
                              });
                              offlineMode.offlineMode = value;
                            },
                          ),
                        ),
                      ),
                    // Dark mode
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
                    // Manual Mode - solo per userType 106
                    if (user.userType == 106)
                      ListTile(
                        leading: Icon(CupertinoIcons.hand_draw),
                        title: Text('Manual Mode'),
                        trailing: Icon(CupertinoIcons.chevron_forward),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExpositorDetailScreen(
                                      user: user,
                                      isNew: true,
                                    )),
                          );
                        },
                      ),
                    // Zebra Mode

                    // Toggle per la torcia

                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(AppLocalizations.of(context)!.logout),
                      onTap: () {
                        Navigator.of(context)
                            .restorablePush(_dialogBuilder, arguments: {
                          'idUser': user.id,
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
                  // Mostro il nome della manifestazione se esistente
                  user.manifestationName != null &&
                          user.manifestationName!.isNotEmpty
                      ? user.manifestationName!
                      : AppLocalizations.of(context)!.scan,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                actions: [
                  if (bottomNavigationStore.selectedIndex == 0)
                    IconButton(
                      icon: Icon(Icons.flash_on),
                      onPressed: () {
                        cameraController.toggleTorch();
                      },
                    ),
                ],
              ),
              backgroundColor:
                  themeChange.darkTheme ? Colors.black26 : Colors.white,
              body: Column(
                children: [
                  // Barra per selezionare il corso subito sotto l'AppBar
                  if (bottomNavigationStore.selectedIndex == 0)
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            themeChange.darkTheme ? Colors.black : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildElegantCourseSelector(
                                themeChange.darkTheme),
                          ),
                        ],
                      ),
                    ),

                  // Tab per Entrata/Uscita (solo per utenti non expositor e se siamo nella schermata 0)
                  if (bottomNavigationStore.selectedIndex == 0 &&
                      user.userType != 106)
                    _buildEntryExitTabs(),

                  // Contenuto principale
                  Expanded(
                    child: bottomNavigationStore.selectedIndex == 0
                        ? buildScannerView()
                        : _widgetPages(
                            user)[bottomNavigationStore.selectedIndex],
                  ),
                ],
              ),
            ));
  }

  @override
  void didChangeDependencies() {
    // Controlla se è un dispositivo Zebra all'avvio
    if (Platform.isAndroid) {
      checkForZebraDevice();
    }
    super.didChangeDependencies();
  }

  // Flag per evitare navigazioni duplicate verso Zebra mode
  bool _navigatedToZebraMode = false;

  Future<void> checkForZebraDevice() async {
    // Se abbiamo già navigato verso la modalità Zebra, non farlo di nuovo
    if (_navigatedToZebraMode) return;

    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.brand.toLowerCase() == "zebra") {
        // Imposta il flag per evitare navigazioni duplicate
        _navigatedToZebraMode = true;

        // Usa un breve ritardo per assicurarsi che tutto sia inizializzato correttamente
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (user.userType == 106) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ZebraScannerExpositorPage(
                        user: user,
                      )),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ZebraScannerPage(
                        user: user,
                      )),
            );
          }
        });
      }
    } catch (e) {
      print('Errore durante il controllo del dispositivo Zebra: $e');
    }
  }

  // Metodo per caricare i corsi disponibili
  Future<void> _loadCourses() async {
    if (user.manifestationId != null) {
      try {
        print(
            "Caricamento corsi per manifestazione ID: ${user.manifestationId}");
        final courses = await courseService.requestCourses(
            user.manifestationId.toString(),
            user.id ?? 0,
            envirormentProvider.envirormentState);

        print("Corsi ricevuti: ${courses.length}");

        // Se non ci sono corsi ma l'utente ne ha uno corrente, aggiungiamolo
        if (courses.isEmpty &&
            user.courseId != null &&
            user.courseName != null) {
          print("Aggiungo il corso corrente alla lista vuota");
          courses
              .add(Course(id: user.courseId!, description: user.courseName!));
        }

        setState(() {
          availableCourses = courses;
          coursesDropdownItems = _mapCoursesToDropdownItems(courses);

          // Imposta il corso attualmente selezionato
          if (user.courseId != null && user.courseName != null) {
            final currentCourse =
                IdValueObject(id: user.courseId!, value: user.courseName!);

            // Verifica se il corso esiste nella lista
            bool courseExists =
                coursesDropdownItems.any((item) => item.id == user.courseId);

            if (courseExists) {
              // Trova l'elemento corrispondente nella lista
              final matchingCourse = coursesDropdownItems.firstWhere(
                  (item) => item.id == user.courseId,
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
              if (user.courseName!.isNotEmpty) {
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
        if (user.courseId != null &&
            user.courseName != null &&
            user.courseName!.isNotEmpty) {
          final currentCourse =
              IdValueObject(id: user.courseId!, value: user.courseName!);
          setState(() {
            coursesDropdownItems = [currentCourse];
            dropDownStore.setSelectedItem(currentCourse);
          });
        }
      }

      // Forza il caricamento del corso corrente se la lista è vuota
      if (coursesDropdownItems.isEmpty &&
          user.courseId != null &&
          user.courseName != null) {
        print("Forzo l'aggiunta del corso corrente");
        final currentCourse =
            IdValueObject(id: user.courseId!, value: user.courseName!);
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
      if (user.courseId != null && user.courseName != null) {
        final currentCourse =
            IdValueObject(id: user.courseId!, value: user.courseName!);
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
                        user.courseId = newValue.id;
                        user.courseName = newValue.value;
                      });

                      // Aggiorna il database e ricarica i visitatori
                      await DatabaseHelper.instance.update(user);
                      try {
                        // Ricarica i visitatori
                        infoCurrentPeopleBoxStore.fetchVisitors(
                            user.manifestationId.toString(),
                            user.courseId.toString(),
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
                      child: Row(
                        children: [
                          // ID del corso in arancione e grassetto
                          Text(
                            valueItem.id.toString(),
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          // Titolo del corso che va a capo
                          Expanded(
                            child: Text(
                              valueItem.value,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                              maxLines: null,
                            ),
                          ),
                        ],
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
