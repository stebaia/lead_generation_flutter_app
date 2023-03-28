import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/db/database_helper.dart';
import 'package:lead_generation_flutter_app/model/check_manager_model/check_model.dart';
import 'package:lead_generation_flutter_app/model/history_model/history.dart';
import 'package:lead_generation_flutter_app/model/scan_offline.dart';
import 'package:lead_generation_flutter_app/network/history_service.dart';
import 'package:lead_generation_flutter_app/provider/offline_mode_provider.dart';
import 'package:lead_generation_flutter_app/store/enable_store/enable_store.dart';
import 'package:lead_generation_flutter_app/store/infoCurrentPeopleBox_store/infoCurrentPeopleBox_store.dart';
import 'package:lead_generation_flutter_app/store/normalScan_store/normalScan_store.dart';
import 'package:lead_generation_flutter_app/store/visibility_store/visibility_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lead_generation_flutter_app/ui/components/history_modal.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositor_detail_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositors_screen.dart';
import 'package:lead_generation_flutter_app/utils/envirorment.dart';
import 'package:lead_generation_flutter_app/utils/extension.dart';
import 'package:lead_generation_flutter_app/utils/sound_helper.dart';
import 'package:lead_generation_flutter_app/utils/sound_play.dart';
import 'package:lead_generation_flutter_app/utils/theme/custom_theme.dart';

import '../../../model/user_model/user.dart';
import '../../../network/visitors_service.dart';
import '../../../provider/dark_theme_provider.dart';
import '../../../provider/envirorment_provider.dart';
import '../../../utils/scanner_animations.dart';

class ExpositorQrScreen extends StatefulWidget {
  ExpositorQrScreen({Key? key, required this.user}) : super(key: key);
  User user;
  @override
  State<ExpositorQrScreen> createState() => _ExpositorQrScreenState();
}

class _ExpositorQrScreenState extends State<ExpositorQrScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();
  final player = AudioPlayer();
  EnvirormentProvider envirormentProvider = EnvirormentProvider();
  MobileScannerController cameraController = MobileScannerController();
  EnableStore enableStore = EnableStore();
  final scanStore = NormalScanStore();
  final visibilityStore = VisibilityStore();
  final infoCurrentPeopleBoxStore = InfoCurrentPeopleBoxStore();
  late AnimationController _animationController;
  bool _animationStopped = false;
  int _selectedIndex = 0;
  String codiceScan = "";
  String lastBarcode = "";
  String visitors = "0";
  bool checkedValuePrivacy = false;
  bool checkedValueCommerical = false;

  VisitorsService visitorsService = VisitorsService();
  HistoryService historyService = HistoryService();

  @override
  void initState() {
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
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

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
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.black,
              title: Text(
                widget.user.courseName != null
                    ? widget.user.courseName!.length > 60
                        ? widget.user.courseName!
                                .substring(0, 60)
                                .capitalize() +
                            ".."
                        : widget.user.courseName!.capitalize()
                    : AppLocalizations.of(context).scanQrCode,
                style: TextStyle(color: Colors.white, fontSize: 16),
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
                        if (codiceScan != barcode.rawValue) {
                          codiceScan = barcode.rawValue!;
                          lastBarcode = barcode.rawValue!;
                          SoundHelper.play(0, player);
                          
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        ExpositorDetailScreen(
                                          user: widget.user,
                                          isNew: false,
                                          codice20: codiceScan,
                                        ))));
                          
                          //visibilityStore.setSelected(false);

                          //cameraController.stop();

                          debugPrint('Barcode found! $code');
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
                    child: infoCurrentPeopleBox()),
                /*Observer(
                  builder: (context) => getLayerScan(),
                ),*/
              ],
            )));
  }

  int lenghtTabBar() => 2;

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
    return IconButton(
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
        ));
  }

  Widget infoCurrentPeopleBox() {
    return Container(
      margin: EdgeInsets.all(36),
      height: 60,
      width: 220,
      child: Center(
        child: Text(
          AppLocalizations.of(context).scan,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(40))),
    );
  }

  Future<void> showInformationDialog(
      BuildContext context, Color backgroundColor, Color anotherColor) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          bool isChecked2 = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                          side: BorderSide(color: anotherColor),
                          
                          title: Text(
                            "Acconsenti al trattamento della privacy",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: isChecked,
                          onChanged: (checked) {
                            setState(() {
                              isChecked = checked!;
                              enableStore.setEnabled(checked);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading),
                      CheckboxListTile(
                          side: BorderSide(color: anotherColor),
                          title: Text(
                            "Acconsenti all'utilizzo dei miei dati personali per scopi commerciali",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: isChecked2,
                          onChanged: (checked) {
                            setState(() {
                              isChecked2 = checked!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading),
                    ],
                  )),
              title: Text(
                'Privacy Policy',
                style: TextStyle(color: anotherColor),
              ),
              actions: <Widget>[
                Observer(
                    builder: ((context) => MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        color:
                            enableStore.isEnabled ? Colors.green : Colors.grey,
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (enableStore.isEnabled) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        ExpositorDetailScreen(
                                          user: widget.user,
                                          isNew: false,
                                          codice20: codiceScan,
                                        ))));
                          }
                        })))
              ],
            );
          });
        });
  }
}
