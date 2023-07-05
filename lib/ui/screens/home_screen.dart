import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/model/user_model/user.dart';
import 'package:lead_generation_flutter_app/store/bottomNavigationBar_store/bottomNavigation_store.dart';
import 'package:lead_generation_flutter_app/ui/screens/expositors_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/initqr_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/settings_screen.dart';
import 'package:lead_generation_flutter_app/utils_backup/theme/custom_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/dark_theme_provider.dart';
import '../../provider/envirorment_provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;
  BottomNavigationStore bottomNavigationStore = BottomNavigationStore();
  late User user;

  List<Widget> _widgetPages(User mUser) {
    List<Widget> listPages = [];
    listPages.add(InitQrScreen(
      user: user,
    ));
    if (mUser.userType == 106) {
      listPages.add(ExpositorsScreen(user: user));
    }
    listPages.add(SettingsScreen(user: user));
    return listPages;
  }

  List<BottomNavigationBarItem> _widgetTab(User mUser) {
    List<BottomNavigationBarItem> tabList = [];
    tabList.add(BottomNavigationBarItem(
      icon: Icon(Icons.camera),
      label: AppLocalizations.of(context).scan,
    ));
    if (mUser.userType == 106) {
      tabList.add(BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: AppLocalizations.of(context).expositors,
      ));
    }
    tabList.add((BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: AppLocalizations.of(context).setting,
    )));
    return tabList;
  }

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final envirormentTheme = Provider.of<EnvirormentProvider>(context);
    return Observer(
        builder: (_) => Scaffold(
              backgroundColor:
                  themeChange.darkTheme ? Colors.black26 : Colors.white,
              body: _widgetPages(user)[bottomNavigationStore.selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor:
                    themeChange.darkTheme ? Colors.black26 : Colors.white,
                items: _widgetTab(user),
                unselectedItemColor: Colors.grey,
                currentIndex: bottomNavigationStore.selectedIndex,
                selectedItemColor: ThemeHelper.primaryColor,
                onTap: (int index) {
                  bottomNavigationStore.setSelected(index);
                },
              ),
            ));
  }
}
