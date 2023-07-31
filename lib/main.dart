import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/db/database_helper.dart';
import 'package:lead_generation_flutter_app/provider/dark_theme_provider.dart';
import 'package:lead_generation_flutter_app/provider/envirorment_provider.dart';
import 'package:lead_generation_flutter_app/provider/offline_mode_provider.dart';
import 'package:lead_generation_flutter_app/ui/screens/choose_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/home_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:lead_generation_flutter_app/utils_backup/theme/custom_theme.dart';

import 'model/user_model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.removeAfter(initialization);

  var initialRoute = '/';

  var isUserLogged = await DatabaseHelper.instance.isUserLogged();

  if (isUserLogged != false) {
    initialRoute = 'home';
    var user = await DatabaseHelper.instance.getUser();
    if (user.courseId == 0 || user.courseId == null) {
      initialRoute = 'choose';
    }
    runApp(MyAppPage(initialRoute: initialRoute, user: user));
  } else {
    runApp(MyAppPage(
      initialRoute: initialRoute,
    ));
  }
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 2));
}

class MyAppPage extends StatefulWidget {
  MyAppPage({Key? key, required this.initialRoute, this.user})
      : super(key: key);

  final String initialRoute;
  final User? user;

  @override
  State<MyAppPage> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppPage> {
  DarkThemeProvider themeProvider = new DarkThemeProvider();
  EnvirormentProvider envirormentProvider = new EnvirormentProvider();
  OfflineModeProvider offlineModeProvider = new OfflineModeProvider();
  void getCurrentAppTheme() async {
    themeProvider.darkTheme =
        await themeProvider.darkThemePreferences.getTheme();
  }

  void getCurrentEnvirorment() async {
    envirormentProvider.envirormentState =
        await envirormentProvider.envirormentPreferences.getEnvirorment();
  }

  void getOfflineMode() async {
    offlineModeProvider.offlineMode =
        await offlineModeProvider.envirormentPreferences.getMode();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<DarkThemeProvider>(
              create: (_) => themeProvider),
          ChangeNotifierProvider<EnvirormentProvider>(
              create: (_) => envirormentProvider),
          ChangeNotifierProvider<OfflineModeProvider>(
              create: (_) => offlineModeProvider)
        ],
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('it', ''), // Spanish, no country code
          ],
          title: 'TicketManager',
          theme: ThemeHelper.myThemeData(themeProvider.darkTheme, context),
          initialRoute: widget.initialRoute,
          routes: {
            "/": (context) => LoginScreen(),
            "home": (context) => HomePageScreen(
                  user: widget.user!,
                ),
            "choose": (context) => ChooseScreen(
                  user: widget.user,
                )
          },
        ));
  }
}
