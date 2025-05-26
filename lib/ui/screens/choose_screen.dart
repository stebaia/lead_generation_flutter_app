import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/model/id_value_model.dart';
import 'package:lead_generation_flutter_app/model/user_model/user.dart';
import 'package:lead_generation_flutter_app/ui/screens/home_screen.dart';
import 'package:lead_generation_flutter_app/utils_backup/theme/custom_theme.dart';

import '../../db/database_helper.dart';
import 'package:lead_generation_flutter_app/l10n/app_localizations.dart';

import '../../model/course_model/course.dart';
import '../../network/course_service.dart';
import '../../network/logout_service.dart';
import '../../provider/dark_theme_provider.dart';
import '../../provider/envirorment_provider.dart';
import '../../store/dropdown_store/dropdown_store.dart';
import '../../store/visibility_store/visibility_store.dart';
import '../../utils_backup/envirorment.dart';
import '../components/bazier_container.dart';
import 'login_screen.dart';

class ChooseScreen extends StatelessWidget {
  final User? user;
  final dropDownStore = DropdownStore();

  List<IdValueObject> idValueList = [];
  List<Course> getCourse = [];
  late Course selectedCourse;
  final visibilityStore = VisibilityStore();
  CourseService courseService = CourseService();

  ChooseScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final envirormentProvider = Provider.of<EnvirormentProvider>(context);

    return Scaffold(
        backgroundColor: themeChange.darkTheme
            ? CupertinoColors.label
            : CupertinoColors.white,
        appBar: AppBar(
          backgroundColor: themeChange.darkTheme
              ? CupertinoColors.label
              : CupertinoColors.white,
          title: Text(
            user!.manifestationName!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeChange.darkTheme
                  ? CupertinoColors.white
                  : CupertinoColors.black,
            ),
          ),
        ),
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
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: ThemeHelper.primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user?.email ?? 'Utente',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.manifestationName ?? '',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(AppLocalizations.of(context)!.logout),
                onTap: () {
                  Navigator.of(context).pop(); // Chiudi il drawer
                  Navigator.of(context)
                      .restorablePush(_dialogBuilder, arguments: {
                    'idUser': user!.id,
                    'envirorment':
                        envirormentProvider.envirormentState.toString()
                  });
                },
              ),
            ],
          ),
        ),
        body: user!.userType != 106 || user!.userType == 110
            ? FutureBuilder(
                future: getCourses(user!, envirormentProvider),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    getCourse.clear();
                    getCourse
                        .add(Course(id: -1, description: 'Seleziona evento'));
                    getCourse.addAll(snapshot.data as List<Course>);
                    idValueList = mapCourseToIdValue(getCourse);
                    return Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height * .60,
                          right: MediaQuery.of(context).size.width * .3,
                          child: RotatedBox(
                              quarterTurns: 2, child: BezierContainer()),
                        ),
                        Observer(builder: ((context) {
                          return Visibility(
                              visible: visibilityStore.isVisible &&
                                  user!.userType != 110,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: TextButton.icon(
                                        icon: Icon(Icons.qr_code),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              ThemeHelper.primaryColor,
                                        ),
                                        onPressed: () {
                                          User updateUser = user!;
                                          updateUser.courseId = 0;
                                          updateUser.courseName = null;
                                          DatabaseHelper.instance
                                              .update(updateUser)
                                              .then((value) =>
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            HomePageScreen(
                                                              user: user!,
                                                            )),
                                                    ModalRoute.withName(
                                                        '/home'),
                                                  ));
                                        },
                                        label: Text('Controllo accessi'))),
                              ));
                        })),
                        Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocalizations.of(context)!.select_event,
                                    style: TextStyle(
                                        color: themeChange.darkTheme
                                            ? CupertinoColors.white
                                            : CupertinoColors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ThemeHelper.primaryColor,
                                        ),
                                        color: ThemeHelper.primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    width: double.infinity,
                                    padding: EdgeInsets.all(2),
                                    child: Center(
                                      child: Observer(
                                          builder: (_) =>
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                    dropdownColor:
                                                        Color.fromARGB(
                                                            255, 245, 242, 242),
                                                    itemHeight: null,
                                                    menuMaxHeight:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    isExpanded: true,
                                                    hint: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .select_event,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    iconEnabledColor:
                                                        Colors.white,
                                                    items:
                                                        dropDownListManifestation(
                                                            context),
                                                    value: dropDownStore
                                                        .selectedItem,
                                                    onChanged: (value) {
                                                      IdValueObject
                                                          selectedItem = value
                                                              as IdValueObject;

                                                      if (selectedItem.id !=
                                                          -1) {
                                                        // Navigate directly to home screen when a course is selected
                                                        selectedCourse =
                                                            getCourse.firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    selectedItem
                                                                        .id);

                                                        User updateUser = user!;
                                                        updateUser.courseId =
                                                            selectedCourse.id;
                                                        updateUser.courseName =
                                                            selectedCourse
                                                                .description;
                                                        DatabaseHelper.instance
                                                            .update(updateUser)
                                                            .then((value) =>
                                                                Navigator
                                                                    .pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          HomePageScreen(
                                                                            user:
                                                                                user!,
                                                                          )),
                                                                  ModalRoute
                                                                      .withName(
                                                                          '/home'),
                                                                ));
                                                      } else {
                                                        visibilityStore
                                                            .setSelected(true);
                                                        dropDownStore
                                                            .setSelected(false);
                                                      }

                                                      dropDownStore
                                                          .setSelectedItem(
                                                              selectedItem);
                                                    }),
                                              )),
                                    )),
                              ],
                            ))
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return controlloAccessi(context);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }))
            : controlloAccessi(context));
  }

  Widget controlloAccessi(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: MediaQuery.of(context).size.height * .60,
        right: MediaQuery.of(context).size.width * .3,
        child: RotatedBox(quarterTurns: 2, child: BezierContainer()),
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 50,
                    width: 300,
                    child: TextButton.icon(
                        icon: Icon(Icons.qr_code),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: ThemeHelper.primaryColor,
                        ),
                        onPressed: () {
                          User updateUser = user!;
                          DatabaseHelper.instance
                              .update(updateUser)
                              .then((value) => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomePageScreen(
                                              user: user!,
                                            )),
                                    ModalRoute.withName('/home'),
                                  ));
                        },
                        label: Text('Controllo accessi')))
              ]))
    ]);
  }

  List<DropdownMenuItem<IdValueObject>> dropDownListManifestation(
      BuildContext context) {
    return idValueList
        .map((e) => DropdownMenuItem(
              value: e,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  constraints: BoxConstraints(
                    minHeight: 48.0, // Minimum touch target size
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        e.id > -1
                            ? SizedBox(
                                width: 10,
                              )
                            : Container(),
                        e.id > -1
                            ? SizedBox(
                                width: 10,
                              )
                            : Container(),
                        e.id > -1
                            ? Icon(
                                Icons.event,
                                color: ThemeHelper.primaryColor,
                                size: 20,
                              )
                            : Container(),
                        SizedBox(
                          width: 10,
                        ),
                        // ID del corso in arancione e grassetto
                        if (e.id > -1)
                          Text(
                            e.id.toString(),
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        if (e.id > -1)
                          SizedBox(
                            width: 8,
                          ),
                        Expanded(
                          child: Text(
                            e.value,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                            softWrap: true,
                          ),
                        )
                      ])),
            ))
        .toList();
  }

  Future<List<Course>> getCourses(
      User user, EnvirormentProvider envirormentProvider) {
    Future<List<Course>> requestCourse = courseService.requestCourses(
        user.manifestationId.toString(),
        user.id!,
        envirormentProvider.envirormentState);
    return requestCourse;
  }

  List<IdValueObject> mapCourseToIdValue(List<Course> list) {
    List<IdValueObject> idValueList = [];
    list.forEach((element) {
      idValueList
          .add(IdValueObject(id: element.id, value: element.description));
    });
    return idValueList;
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
