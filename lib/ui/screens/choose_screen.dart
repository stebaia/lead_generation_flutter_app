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
import '../../provider/dark_theme_provider.dart';
import '../../provider/envirorment_provider.dart';
import '../../store/dropdown_store/dropdown_store.dart';
import '../../store/visibility_store/visibility_store.dart';
import '../components/bazier_container.dart';

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
                              visible: visibilityStore.isVisible,
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
                                                    itemHeight: 80,
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
                                                      if ((value as IdValueObject)
                                                              .id !=
                                                          -1) {
                                                        visibilityStore
                                                            .setSelected(false);
                                                        dropDownStore
                                                            .setSelected(true);
                                                      } else {
                                                        visibilityStore
                                                            .setSelected(true);
                                                        dropDownStore
                                                            .setSelected(false);
                                                      }
                                                      IdValueObject
                                                          selectedItem = value
                                                              as IdValueObject;
                                                      dropDownStore
                                                          .setSelectedItem(
                                                              selectedItem);
                                                      selectedCourse =
                                                          getCourse.firstWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  selectedItem
                                                                      .id);
                                                    }),
                                              )),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Observer(
                                  builder: (_) => Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.black,
                                      ),
                                      onPressed: () {
                                        clickButtonToScan(
                                            dropDownStore.isSelected, context);
                                      },
                                      child: Text(dropDownStore.isSelected
                                          ? AppLocalizations.of(context)!
                                              .go_to_scan
                                          : AppLocalizations.of(context)!
                                              .select_event),
                                    ),
                                  ),
                                )
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

  void clickButtonToScan(bool enabled, BuildContext context) async {
    if (enabled) {
      User updateUser = user!;
      updateUser.courseId = selectedCourse.id;
      updateUser.courseName = selectedCourse.description;
      DatabaseHelper.instance
          .update(updateUser)
          .then((value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePageScreen(
                          user: user!,
                        )),
                ModalRoute.withName('/home'),
              ));
    } else {
      return;
    }
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
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
                          )
                        : Container(),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        e.value,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
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
}
