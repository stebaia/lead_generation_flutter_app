import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation_flutter_app/model/expositor_mapper/expositor_mapper.dart';
import 'package:lead_generation_flutter_app/model/user_model/user.dart';
import 'package:lead_generation_flutter_app/network/get_user_extra_by_20_service.dart';
import 'package:lead_generation_flutter_app/network/get_user_extra_service.dart';
import 'package:lead_generation_flutter_app/network/set_utente_app.dart';
import 'package:lead_generation_flutter_app/network/set_utente_app_manual_service.dart';
import 'package:lead_generation_flutter_app/provider/envirorment_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lead_generation_flutter_app/store/selected_item_store/selected_item_store.dart';
import 'package:lead_generation_flutter_app/store/visibility_store/visibility_store.dart';
import 'package:lead_generation_flutter_app/utils/nations_utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../provider/dark_theme_provider.dart';
import '../../utils/custom_colors.dart';
import '../../utils/envirorment.dart';
import '../../utils/province_utils.dart';
import '../components/take_picture.dart';

class ExpositorDetailScreen extends StatefulWidget {
  const ExpositorDetailScreen(
      {Key? key,
      required this.user,
      this.idUtente,
      this.codice20,
      required this.isNew})
      : super(key: key);

  final User user;
  final int? idUtente;
  final String? codice20;
  final bool isNew;
  @override
  State<ExpositorDetailScreen> createState() => _ExpositorDetailScreenState();
}

class _ExpositorDetailScreenState extends State<ExpositorDetailScreen> {
  EnvirormentProvider envirormentProvider = EnvirormentProvider();

  TextEditingController textEditingControllerSocialRegion =
      TextEditingController();
  TextEditingController textEditingControllerSurname = TextEditingController();
  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPhone = TextEditingController();
  TextEditingController textEditingControllerCap = TextEditingController();
  TextEditingController textEditingControllerNote = TextEditingController();

  SelectedItemyStore selectedItemyStoreNation = SelectedItemyStore();
  SelectedItemyStore selectedItemyStoreProvince = SelectedItemyStore();
  VisibilityStore visibilityStore = VisibilityStore();
  int star = 0;
  String selectedValue = "";
  String selectedValueProvince = "";
  String base64Photo1 = "";
  String base64Photo2 = "";
  String base64Photo3 = "";
  late User user;
  late int? idUtente;
  late String? codice20;
  bool shouldClose = true;
  late bool isNew;
  ExpoisitorMapper? expoisitorMapper = null;
  @override
  void initState() {
    user = widget.user;
    idUtente = widget.idUtente;
    codice20 = widget.codice20;
    isNew = widget.isNew;
    
    if (!isNew) {
      requestGetUtente().then((expositorMapperData) {
        visibilityStore.setSelected(false);
        expoisitorMapper = expositorMapperData;
        if (expositorMapperData != null) {
          if (expositorMapperData.ragionesociale != null) {
            textEditingControllerSocialRegion.text =
                expositorMapperData.ragionesociale!;
          }
          if (expositorMapperData.cognome != null) {
            textEditingControllerSurname.text = expositorMapperData.cognome!;
          }
          if (expositorMapperData.nome != null) {
            textEditingControllerName.text = expositorMapperData.nome!;
          }
          if (expositorMapperData.email != null) {
            textEditingControllerEmail.text = expositorMapperData.email!;
          }
          if (expositorMapperData.note != null) {
            textEditingControllerNote.text = expositorMapperData.note!;
          }
          if (expositorMapperData.telefono != null) {
            textEditingControllerPhone.text = expositorMapperData.telefono!;
          }
          if (expositorMapperData.cap != null) {
            textEditingControllerCap.text = expositorMapperData.cap!;
          }
          if (expositorMapperData.siglanazione != null) {
            selectedValue = NationsUtils.getNationFromInitials(
                    expositorMapperData.siglanazione!)
                .name;
          }
          if (expositorMapperData.siglaprovincia != null) {
            selectedValueProvince = ProvinceUtils.getProvinceFromInitials(
                    expositorMapperData.siglaprovincia!)
                .name;
          }

          selectedItemyStoreNation.setSelectedItem(selectedValue);
          selectedItemyStoreProvince.setSelectedItem(selectedValueProvince);
        }
      });
    } else {
      selectedValue = "Italia";
      selectedValueProvince = "Rimini";
      selectedItemyStoreNation.setSelectedItem(selectedValue);
      selectedItemyStoreProvince.setSelectedItem(selectedValueProvince);
       visibilityStore.setSelected(false);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return WillPopScope(
        onWillPop: () async {
          await showDismissDialogForFuture();
          return shouldClose;
        },
        child: Scaffold(
            backgroundColor:
                themeChange.darkTheme ? Colors.black : Colors.white,
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context).expositorData,
                style: TextStyle(
                  color: themeChange.darkTheme ? Colors.white : Colors.black,
                ),
              ),
              backgroundColor:
                  themeChange.darkTheme ? Colors.black : Colors.white,
            ),
            body: Observer(
              builder: (context) {
                if(!visibilityStore.isVisible){
                return Container(
                    padding: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 14,
                        ),
                        textFieldForm(
                            textEditingControllerSocialRegion,
                            AppLocalizations.of(context).socialRegion,
                            1,
                            themeChange.darkTheme ? Colors.white : Colors.black),
                        SizedBox(
                          height: 14,
                        ),
                        textFieldForm(
                            textEditingControllerSurname,
                            AppLocalizations.of(context).surname,
                            1,
                            themeChange.darkTheme ? Colors.white : Colors.black),
                        SizedBox(
                          height: 14,
                        ),
                        textFieldForm(
                            textEditingControllerName,
                            AppLocalizations.of(context).name,
                            1,
                            themeChange.darkTheme ? Colors.white : Colors.black),
                        SizedBox(
                          height: 14,
                        ),
                        textFieldForm(
                            textEditingControllerEmail,
                            AppLocalizations.of(context).email,
                            1,
                            themeChange.darkTheme ? Colors.white : Colors.black),
                        SizedBox(
                          height: 14,
                        ),
                        textFieldForm(
                            textEditingControllerPhone,
                            AppLocalizations.of(context).telephone,
                            1,
                            themeChange.darkTheme ? Colors.white : Colors.black),
                        SizedBox(
                          height: 14,
                        ),
                        textFieldForm(
                            textEditingControllerCap,
                            AppLocalizations.of(context).cap,
                            1,
                            themeChange.darkTheme ? Colors.white : Colors.black),
                        SizedBox(
                          height: 14,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromARGB(109, 146, 196, 165),
                            ),
                            padding: EdgeInsets.all(4),
                            child: Column(
                              children: [
                                Align(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .expositorLocalizationData,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CupertinoColors.systemGrey),
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () => showPickerNation(),
                                        child: Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                top: 12,
                                                bottom: 12,
                                                right: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .nation,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: CupertinoColors
                                                          .systemGrey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Observer(
                                                    builder: ((context) => Text(
                                                        selectedItemyStoreNation
                                                            .selectedItem!))),
                                                Spacer(),
                                                Icon(
                                                  CupertinoIcons.chevron_down,
                                                  //color: ThemeHelper.primaryColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                    GestureDetector(
                                        onTap: () => showPickerProvince(),
                                        child: Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                top: 12,
                                                bottom: 12,
                                                right: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .province,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: CupertinoColors
                                                          .systemGrey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Observer(
                                                    builder: ((context) => Text(
                                                        selectedItemyStoreProvince
                                                            .selectedItem!))),
                                                Spacer(),
                                                Icon(
                                                  CupertinoIcons.chevron_down,
                                                  //color: ThemeHelper.primaryColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            )),
                        SizedBox(
                          height: 14,
                        ),
                        textFieldForm(
                            textEditingControllerNote,
                            AppLocalizations.of(context).notes,
                            5,
                            themeChange.darkTheme ? Colors.white : Colors.black),
                        SizedBox(
                          height: 14,
                        ),
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).takePicture,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.systemGrey),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TakePictureWidget(
                                        onTakedPicture: (value) =>
                                            base64Photo1 = value,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TakePictureWidget(
                                        onTakedPicture: (value) =>
                                            base64Photo2 = value,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TakePictureWidget(
                                        onTakedPicture: (value) =>
                                            base64Photo3 = value,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of(context).doValutation,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.systemGrey),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: RatingBar.builder(
                                  initialRating: 1,
                                  minRating: 1,
                                  itemSize: 38,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  unratedColor: themeChange.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    CupertinoIcons.star_fill,
                                    color: Colors.green,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    star = rating.round();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          // ignore: sort_child_properties_last
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            color: Colors.green,
                            textColor: Colors.white,
                            height: 46,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              setUtenteApp(
                                      isNew,
                                      user.id.toString(),
                                      user.manifestationId.toString(),
                                      codice20.toString(),
                                      textEditingControllerNote.text,
                                      textEditingControllerCap.text,
                                      textEditingControllerEmail.text,
                                      NationsUtils.getInitialsFromNation(
                                          selectedValue),
                                      ProvinceUtils.getInitialsFromProvince(
                                          selectedValueProvince),
                                      textEditingControllerName.text,
                                      textEditingControllerSurname.text,
                                      textEditingControllerPhone.text,
                                      textEditingControllerSocialRegion.text,
                                      expoisitorMapper != null ? expoisitorMapper!.idextra : null,
                                      envirormentProvider.envirormentState)
                                  .then((value) => {
                                        if (value != 0)
                                          {
                                            Navigator.pop(context),
                                            Fluttertoast.showToast(
                                                msg: AppLocalizations.of(context)
                                                    .contentToastSetUtenteOk,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    CupertinoColors.black,
                                                textColor: CupertinoColors.white,
                                                fontSize: 16.0),
                                          }
                                        else
                                          {
                                            Fluttertoast.showToast(
                                                msg: AppLocalizations.of(context)
                                                    .contentToastSetUtenteko,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    CupertinoColors.black,
                                                textColor: CupertinoColors.white,
                                                fontSize: 16.0),
                                          }
                                      });
                            },
                            child: Text(AppLocalizations.of(context).saveExpositor),
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    )));
                }else{
                  return Center(child: CircularProgressIndicator());
                }
              }
              
            )));
  }

  Future showDismissDialogForFuture() async {
    await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context).cancelExpositor),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(
                    AppLocalizations.of(context).yes,
                    style: TextStyle(color: CupertinoColors.systemRed),
                  ),
                  onPressed: () {
                    shouldClose = true;
                    Navigator.of(context).pop(true);
                  },
                ),
                CupertinoButton(
                  child: Text(
                    AppLocalizations.of(context).no,
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    shouldClose = false;
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ));
  }

  Widget textFieldForm(TextEditingController textEditingController,
      String label, int lines, Color borderColor) {
    return TextField(
        minLines: lines,
        maxLines: lines,
        controller: textEditingController,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.green),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
            border: OutlineInputBorder(),
            labelText: label,
            hintText: label));
  }

  void showPickerNation() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.25,
              color: CupertinoColors.white,
              child: CupertinoPicker(
                children: countries,
                onSelectedItemChanged: (value) {
                  Text text = countries[value] as Text;
                  selectedValue = text.data.toString();
                  selectedItemyStoreNation.setSelectedItem(selectedValue);
                },
                itemExtent: 25,
                diameterRatio: 1,
                useMagnifier: true,
                magnification: 1.3,
                looping: true,
              ));
        });
  }

  void showPickerProvince() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.25,
              color: CupertinoColors.white,
              child: CupertinoPicker(
                children: provinceList,
                onSelectedItemChanged: (value) {
                  Text text = provinceList[value] as Text;
                  selectedValueProvince = text.data.toString();
                  selectedItemyStoreProvince
                      .setSelectedItem(selectedValueProvince);
                },
                itemExtent: 25,
                diameterRatio: 1,
                useMagnifier: true,
                magnification: 1.3,
                looping: true,
              ));
        });
  }

  List<Widget> countries = List.generate(NationsUtils.nations.length,
      (index) => Text(NationsUtils.nations[index].name));

  List<Widget> provinceList = List.generate(ProvinceUtils.provinces.length,
      (index) => Text(ProvinceUtils.provinces[index].name));

  Future<int> setUtenteApp(bool isNew, String expositorId,
      String manifestationId,
      String codice20,
      String note,
      String cap,
      String email,
      String siglaNatzione,
      String siglaProvincia,
      String nome,
      String cognome,
      String telefono,
      String ragioneSociale,
      String? idExtra,
      Envirorment envirorment){
    
    if(isNew){
      return requestSetUtenteAppManual(expositorId, manifestationId, note, cap, email, siglaNatzione, siglaProvincia, nome, cognome, telefono, ragioneSociale, envirorment);
    }else{
      idExtra ??= "";
      return requestSetUtenteApp(expositorId, manifestationId, codice20, note, cap, email, siglaNatzione, siglaProvincia, nome, cognome, telefono, ragioneSociale, idExtra!, envirorment);
    }
  }

  Future<int> requestSetUtenteAppManual(
      String idUtilizzatore,
      String manifestationId,
      String note,
      String cap,
      String email,
      String siglaNatzione,
      String siglaProvincia,
      String nome,
      String cognome,
      String telefono,
      String ragioneSociale,
      Envirorment envirorment) {
    SetUtenteManualService setUtenteService = SetUtenteManualService();
    Future<int> setUser = setUtenteService.setUtenteAppManual(
        idUtilizzatore,
        manifestationId,
        (star + 1).toString(),
        base64Photo1,
        base64Photo2,
        base64Photo3,
        note,
        cap,
        email,
        siglaNatzione,
        siglaProvincia,
        nome,
        cognome,
        telefono,
        ragioneSociale,
        "1",
        envirorment);
    return setUser;
  }

  Future<int> requestSetUtenteApp(
      String expositorId,
      String manifestationId,
      String codice20,
      String note,
      String cap,
      String email,
      String siglaNatzione,
      String siglaProvincia,
      String nome,
      String cognome,
      String telefono,
      String ragioneSociale,
      String idExtra,
      Envirorment envirorment) {
    SetUtenteService setUtenteService = SetUtenteService();
    Future<int> setUser = setUtenteService.setUtenteApp(
        expositorId,
        manifestationId,
        codice20,
        (star + 1).toString(),
        base64Photo1,
        base64Photo2,
        base64Photo3,
        note,
        cap,
        email,
        siglaNatzione,
        siglaProvincia,
        nome,
        cognome,
        telefono,
        ragioneSociale,
        "1",
        idExtra,
        envirorment);
    return setUser;
  }

  Future<ExpoisitorMapper> requestGetUtente() {
    if (idUtente != null) {
      GetUserExtraService getUserExtraByCode20Service =
          new GetUserExtraService();
      Future<ExpoisitorMapper> resultGetUserExtra =
          getUserExtraByCode20Service.requestUserExtra(
              user.id!, idUtente!, envirormentProvider.envirormentState);
      return resultGetUserExtra;
    } else {
      GetUserExtraByCode20Service getUserExtraByCode20Service =
          new GetUserExtraByCode20Service();
      return getUserExtraByCode20Service.requestUserExtraBy20(
          user.id!,
          user.manifestationId!,
          codice20!,
          envirormentProvider.envirormentState);
    }
  }
}
