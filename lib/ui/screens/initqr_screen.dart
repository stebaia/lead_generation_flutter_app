import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/model/user_model/user.dart';
import 'package:lead_generation_flutter_app/network/visitors_service.dart';
import 'package:lead_generation_flutter_app/provider/envirorment_provider.dart';
import 'package:lead_generation_flutter_app/ui/screens/choose_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/qr_scan_screen/expositor_qr_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/qr_scan_screen/normal_qr_screen.dart';
import 'package:lead_generation_flutter_app/utils/custom_colors.dart';
import 'package:lead_generation_flutter_app/utils/extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../provider/dark_theme_provider.dart';
import '../../store/dropdown_store/dropdown_store.dart';
import '../../utils/theme/custom_theme.dart';

class InitQrScreen extends StatelessWidget {
  InitQrScreen({Key? key, required this.user}) : super(key: key);
  final User user;
  int visitors = 0;
  EnvirormentProvider envirormentProvider = EnvirormentProvider();
  VisitorsService visitorsService = VisitorsService();

  Future<int> getVisitors() {
    Future<int> requestVisitors = visitorsService.requestVisitors(
        user.manifestationId.toString(),
        user.courseId!,
        envirormentProvider.envirormentState);
    return requestVisitors;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Center(
        child: Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: ThemeHelper.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.manifestationName!.capitalize(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      user.courseName != null
                          ? Container(
                              width: 250,
                              child: Text(
                                user.courseName!.length > 60
                                    ? user.courseName!
                                            .substring(0, 60)
                                            .capitalize() +
                                        ".."
                                    : user.courseName!.capitalize(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          : Container(),
                      user.courseName != null
                          ? FutureBuilder(
                              future: getVisitors(),
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  visitors = snapshot.data as int;
                                  return Text(
                                    "$visitors " +
                                        AppLocalizations.of(context)
                                            .currentPeople,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  );
                                } else {
                                  return Container();
                                }
                              }))
                          : Container()
                    ],
                  ),
                  GestureDetector(
                    onTap: (() {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ChooseScreen(
                                  user: user,
                                )),
                        ModalRoute.withName('/choose'),
                      );
                    }),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.change_circle,
                          color: Colors.white,
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            AppLocalizations.of(context).scanQrCode,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: themeChange.darkTheme ? Colors.white : Colors.black),
          ),
          Text(
            AppLocalizations.of(context).tap_the_button,
            style: TextStyle(
                color: themeChange.darkTheme ? Colors.white : Colors.black),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Image.asset(
              'assets/qrcode.png',
            ),
          ),
          /*Row(
                  
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.ads_click,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.flash_on,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),*/
          SizedBox(
            height: 30,
          ),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 60,
              width: double.infinity,
              child: TextButton(
                  onPressed: (() {
                    switch (user.userType) {
                      case 106:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ExpositorQrScreen(
                                    user: user,
                                  )),
                        );
                        break;

                      default:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => NormalQrScreen(
                                    user: user,
                                  )),
                        );
                        break;
                    }
                    /*if (user!.isAutorizzazione == 0) {
                              context.pushRoute(QrViewRoute(user: user!));
                            } else {
                              context.pushRoute(
                                  AutorizationQrViewRoute(user: user!));
                            }*/
                  }),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: PrimaryColor,
                  ),
                  child: Text(
                    AppLocalizations.of(context).scan_exclamative,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
        ],
      ),
    ));
  }
}
