import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:lead_generation_flutter_app/network/login_service.dart';
import 'package:lead_generation_flutter_app/provider/dark_theme_provider.dart';
import 'package:lead_generation_flutter_app/provider/envirorment_provider.dart';
import 'package:lead_generation_flutter_app/ui/components/bazier_container.dart';
import 'package:lead_generation_flutter_app/ui/screens/choose_screen.dart';
import 'package:lead_generation_flutter_app/ui/screens/home_screen.dart';
import 'package:lead_generation_flutter_app/utils_backup/custom_colors.dart';
import 'package:lead_generation_flutter_app/l10n/app_localizations.dart';
import 'package:lead_generation_flutter_app/utils_backup/envirorment.dart';
import 'package:lead_generation_flutter_app/utils_backup/theme/custom_theme.dart';
import '../../db/database_helper.dart';
import '../../model/user_model/user.dart';
import '../../store/form_store/form_store.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FormStore formStore = FormStore();

  TextEditingController textEditingControllerEmail = TextEditingController();

  TextEditingController textEditingControllerPassword = TextEditingController();

  Widget _entryField(
      String title, TextEditingController controller, bool darkTheme,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color:
                  darkTheme ? Color(0xfff3f3f4) : Color.fromARGB(255, 1, 1, 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (isPassword)
            Observer(
                builder: ((context) => TextField(
                    style: TextStyle(
                      color: darkTheme
                          ? Color(0xfff3f3f4)
                          : Color.fromARGB(255, 1, 1, 20),
                    ),
                    controller: controller,
                    obscureText: formStore.isVisibile,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            formStore.isVisibile
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: darkTheme
                                ? Color(0xfff3f3f4)
                                : Color.fromARGB(255, 1, 1, 20),
                          ),
                          onPressed: () =>
                              formStore.setVisibility(!formStore.isVisibile),
                        ),
                        border: InputBorder.none,
                        fillColor: darkTheme
                            ? Color.fromARGB(255, 1, 1, 20)
                            : Color(0xfff3f3f4),
                        filled: true))))
          else
            Observer(
                builder: ((context) => TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: darkTheme
                            ? Color.fromARGB(255, 1, 1, 20)
                            : Color(0xfff3f3f4),
                        filled: true))))
        ],
      ),
    );
  }

  void loginRequest(String email, String password, BuildContext buildContext,
      Envirorment envirorment) {
    LoginService loginService = LoginService();
    Future<User> futureUser =
        loginService.requestLogin(email, password, envirorment);
    futureUser.then((user) {
      SVProgressHUD.dismiss();
      formStore.clearError(); // Clear any previous errors
      DatabaseHelper.instance.add(user);
      switch (user.userType) {
        case 107:
          Navigator.pushAndRemoveUntil(
            buildContext,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePageScreen(
                      user: user,
                    )),
            ModalRoute.withName('/home'),
          );
          break;
        case 106:
          Navigator.pushAndRemoveUntil(
            buildContext,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePageScreen(
                      user: user,
                    )),
            ModalRoute.withName('/home'),
          );
          break;
        default:
          Navigator.pushAndRemoveUntil(
            buildContext,
            MaterialPageRoute(
                builder: (BuildContext context) => ChooseScreen(
                      user: user,
                    )),
            ModalRoute.withName('/choose'),
          );
          break;
      }
    }).onError((error, stackTrace) {
      SVProgressHUD.dismiss();
      print("Login error occurred: $error");
      print("Stack trace: $stackTrace");

      // Handle different types of errors
      String errorMessage;
      String errorString = error.toString().toLowerCase();

      if (errorString.contains('socketexception') ||
          errorString.contains('timeoutexception') ||
          errorString.contains('handshakeexception') ||
          errorString.contains('network') ||
          errorString.contains('connection')) {
        errorMessage = AppLocalizations.of(buildContext)!.networkError;
        print("Network error detected");
      } else if (errorString.contains('invalid credentials') ||
          errorString.contains('unauthorized') ||
          errorString.contains('401') ||
          errorString.contains('authentication') ||
          errorString.contains('login failed')) {
        errorMessage = AppLocalizations.of(buildContext)!.invalidCredentials;
        print("Invalid credentials detected");
      } else {
        errorMessage = AppLocalizations.of(buildContext)!
            .invalidCredentials; // Default to credentials error
        print("Generic error, defaulting to credentials error: $error");
      }
      formStore.setError(errorMessage);
    });
  }

  Widget _title(bool darkTheme) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w700, color: PrimaryColor),
          children: [
            TextSpan(
              text: 'Lead',
              style: TextStyle(
                  color:
                      darkTheme ? CupertinoColors.white : CupertinoColors.label,
                  fontSize: 30,
                  fontFamily: 'Poppins'),
            ),
            TextSpan(
              text: 'Generation',
              style: TextStyle(
                  color: PrimaryColor, fontSize: 30, fontFamily: 'Poppins'),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final envirormentTheme = Provider.of<EnvirormentProvider>(context);
    return Scaffold(
        backgroundColor:
            themeChange.darkTheme ? ThemeHelper.backgroundDark : Colors.white,
        body: Container(
            child: Stack(
          children: [
            Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _title(themeChange.darkTheme),
                  _entryField('Email', textEditingControllerEmail,
                      themeChange.darkTheme),
                  _entryField('Password', textEditingControllerPassword,
                      themeChange.darkTheme,
                      isPassword: true),
                  // Error message display
                  Observer(
                    builder: (context) => formStore.hasError
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    formStore.errorMessage ?? '',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Observer(
                        builder: ((context) => TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                formStore
                                    .clearError(); // Clear any previous errors
                                formStore
                                    .setEmail(textEditingControllerEmail.text);
                                formStore.setPassword(
                                    textEditingControllerPassword.text);
                                formStore.loginAction();
                                if (formStore.isValid) {
                                  SVProgressHUD.show();
                                  loginRequest(
                                      textEditingControllerEmail.text,
                                      textEditingControllerPassword.text,
                                      context,
                                      envirormentTheme.envirormentState);
                                } else {}
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.tap_login),
                            ))),
                  )
                ],
              ),
            )
          ],
        )));
  }
}
