import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ticket_manager_flutter_app/network/login_service.dart';
import 'package:ticket_manager_flutter_app/provider/dark_theme_provider.dart';
import 'package:ticket_manager_flutter_app/provider/envirorment_provider.dart';
import 'package:ticket_manager_flutter_app/ui/components/bazier_container.dart';
import 'package:ticket_manager_flutter_app/ui/screens/choose_screen.dart';
import 'package:ticket_manager_flutter_app/ui/screens/home_screen.dart';
import 'package:ticket_manager_flutter_app/utils/custom_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ticket_manager_flutter_app/utils/envirorment.dart';
import 'package:ticket_manager_flutter_app/utils/theme/custom_theme.dart';
import '../../db/database_helper.dart';
import '../../model/user_model/user.dart';
import '../../store/form_store/form_store.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  FormStore formStore = FormStore();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final envirormentTheme = Provider.of<EnvirormentProvider>(context);
    Widget _entryField(String title, TextEditingController controller,
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
                color: themeChange.darkTheme
                    ? Color(0xfff3f3f4)
                    : Color.fromARGB(255, 1, 1, 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (isPassword)
              Observer(
                  builder: ((context) => TextField(
                      style: TextStyle(
                        color: themeChange.darkTheme
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
                              color: themeChange.darkTheme
                                  ? Color(0xfff3f3f4)
                                  : Color.fromARGB(255, 1, 1, 20),
                            ),
                            onPressed: () =>
                                formStore.setVisibility(!formStore.isVisibile),
                          ),
                          border: InputBorder.none,
                          fillColor: themeChange.darkTheme
                              ? Color.fromARGB(255, 1, 1, 20)
                              : Color(0xfff3f3f4),
                          filled: true))))
            else
              Observer(
                  builder: ((context) => TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: themeChange.darkTheme
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
        DatabaseHelper.instance.add(user);
        switch (user.userType) {
          case 107:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePageScreen(
                        user: user,
                      )),
              ModalRoute.withName('/home'),
            );
            break;
          default:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ChooseScreen(
                        user: user,
                      )),
              ModalRoute.withName('/choose'),
            );
            break;
        }
      }).onError((error, stackTrace) {
        Fluttertoast.showToast(
            msg: 'Credenziali non valide',
            textColor: Colors.white,
            backgroundColor: Colors.red);
      });
    }

    Widget _title() {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w700, color: PrimaryColor),
            children: [
              TextSpan(
                text: 'Ticket',
                style: TextStyle(
                    color: themeChange.darkTheme
                        ? CupertinoColors.white
                        : CupertinoColors.label,
                    fontSize: 30,
                    fontFamily: 'Poppins'),
              ),
              TextSpan(
                text: 'Manager',
                style: TextStyle(
                    color: PrimaryColor, fontSize: 30, fontFamily: 'Poppins'),
              ),
            ]),
      );
    }

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
                  _title(),
                  _entryField('Email', textEditingControllerEmail),
                  _entryField('Password', textEditingControllerPassword,
                      isPassword: true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Observer(
                        builder: ((context) => TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
                                formStore
                                    .setEmail(textEditingControllerEmail.text);
                                formStore.setPassword(
                                    textEditingControllerPassword.text);
                                formStore.loginAction();
                                if (formStore.isValid) {
                                  loginRequest(
                                      textEditingControllerEmail.text,
                                      textEditingControllerPassword.text,
                                      context,
                                      envirormentTheme.envirormentState);
                                } else {}
                              },
                              child:
                                  Text(AppLocalizations.of(context).tap_login),
                            ))),
                  )
                ],
              ),
            )
          ],
        )));
  }
}
