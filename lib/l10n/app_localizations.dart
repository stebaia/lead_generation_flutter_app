import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In it, this message translates to:
  /// **'Ciao mondo!'**
  String get helloWorld;

  /// No description provided for @courses.
  ///
  /// In it, this message translates to:
  /// **'Corsi'**
  String get courses;

  /// No description provided for @manifestation.
  ///
  /// In it, this message translates to:
  /// **'Manifestazione:'**
  String get manifestation;

  /// No description provided for @selectManifestation.
  ///
  /// In it, this message translates to:
  /// **'Seleziona una manifestazione'**
  String get selectManifestation;

  /// No description provided for @course.
  ///
  /// In it, this message translates to:
  /// **'Corso:'**
  String get course;

  /// No description provided for @selectCourse.
  ///
  /// In it, this message translates to:
  /// **'Seleziona corso'**
  String get selectCourse;

  /// No description provided for @confirm.
  ///
  /// In it, this message translates to:
  /// **'Conferma'**
  String get confirm;

  /// No description provided for @scan.
  ///
  /// In it, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @scanQrCode.
  ///
  /// In it, this message translates to:
  /// **'Scan QrCode'**
  String get scanQrCode;

  /// No description provided for @currentPeople.
  ///
  /// In it, this message translates to:
  /// **'persone presenti'**
  String get currentPeople;

  /// No description provided for @enter.
  ///
  /// In it, this message translates to:
  /// **'Entrata'**
  String get enter;

  /// No description provided for @exit.
  ///
  /// In it, this message translates to:
  /// **'Uscita'**
  String get exit;

  /// No description provided for @qrUnderCamera.
  ///
  /// In it, this message translates to:
  /// **'Posizionare un qr sotto la fotocamera'**
  String get qrUnderCamera;

  /// No description provided for @qrCodeOk.
  ///
  /// In it, this message translates to:
  /// **'Scan ok!'**
  String get qrCodeOk;

  /// No description provided for @qrCodeError.
  ///
  /// In it, this message translates to:
  /// **'Errore!'**
  String get qrCodeError;

  /// No description provided for @historyScannerization.
  ///
  /// In it, this message translates to:
  /// **'Storico scansioni'**
  String get historyScannerization;

  /// No description provided for @scannerizationOf.
  ///
  /// In it, this message translates to:
  /// **'Scannerizzazione del'**
  String get scannerizationOf;

  /// No description provided for @expositors.
  ///
  /// In it, this message translates to:
  /// **'Visitatori'**
  String get expositors;

  /// No description provided for @socialRegion.
  ///
  /// In it, this message translates to:
  /// **'Ragione sociale'**
  String get socialRegion;

  /// No description provided for @surname.
  ///
  /// In it, this message translates to:
  /// **'Cognome'**
  String get surname;

  /// No description provided for @name.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @email.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @telephone.
  ///
  /// In it, this message translates to:
  /// **'Telefono'**
  String get telephone;

  /// No description provided for @expositorData.
  ///
  /// In it, this message translates to:
  /// **'Dati visitatore'**
  String get expositorData;

  /// No description provided for @expositorLocalizationData.
  ///
  /// In it, this message translates to:
  /// **'Dati geografici'**
  String get expositorLocalizationData;

  /// No description provided for @nation.
  ///
  /// In it, this message translates to:
  /// **'Nazione'**
  String get nation;

  /// No description provided for @province.
  ///
  /// In it, this message translates to:
  /// **'Provincia'**
  String get province;

  /// No description provided for @cap.
  ///
  /// In it, this message translates to:
  /// **'Cap'**
  String get cap;

  /// No description provided for @finalNotes.
  ///
  /// In it, this message translates to:
  /// **'Note finali'**
  String get finalNotes;

  /// No description provided for @notes.
  ///
  /// In it, this message translates to:
  /// **'Note'**
  String get notes;

  /// No description provided for @takePicture.
  ///
  /// In it, this message translates to:
  /// **'Scatta una foto'**
  String get takePicture;

  /// No description provided for @doValutation.
  ///
  /// In it, this message translates to:
  /// **'Dai una valutazione'**
  String get doValutation;

  /// No description provided for @saveExpositor.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get saveExpositor;

  /// No description provided for @preference.
  ///
  /// In it, this message translates to:
  /// **'Preferenze'**
  String get preference;

  /// No description provided for @language.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get language;

  /// No description provided for @modifyUser.
  ///
  /// In it, this message translates to:
  /// **'Modifica utente'**
  String get modifyUser;

  /// No description provided for @offlineMode.
  ///
  /// In it, this message translates to:
  /// **'Modalità Offline'**
  String get offlineMode;

  /// No description provided for @rootMode.
  ///
  /// In it, this message translates to:
  /// **'Modalità amministratore'**
  String get rootMode;

  /// No description provided for @welcomeTicketManager.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto\nsu\n'**
  String get welcomeTicketManager;

  /// No description provided for @username.
  ///
  /// In it, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In it, this message translates to:
  /// **'Login in'**
  String get login;

  /// No description provided for @enterText.
  ///
  /// In it, this message translates to:
  /// **'Inserisci il testo'**
  String get enterText;

  /// No description provided for @yes.
  ///
  /// In it, this message translates to:
  /// **'Si'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In it, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @cancelExpositor.
  ///
  /// In it, this message translates to:
  /// **'Vuoi annullare l\'inserimento dell\'espositore?'**
  String get cancelExpositor;

  /// No description provided for @titleDialogLogout.
  ///
  /// In it, this message translates to:
  /// **'Logout'**
  String get titleDialogLogout;

  /// No description provided for @contentDialogLogout.
  ///
  /// In it, this message translates to:
  /// **'Vuoi sloggarti dall\'applicazione?'**
  String get contentDialogLogout;

  /// No description provided for @contentToastSetUtenteOk.
  ///
  /// In it, this message translates to:
  /// **'Dati inseriti correttamente'**
  String get contentToastSetUtenteOk;

  /// No description provided for @contentToastSetUtenteko.
  ///
  /// In it, this message translates to:
  /// **'Errore nell\'inserimento dati'**
  String get contentToastSetUtenteko;

  /// No description provided for @tap_login.
  ///
  /// In it, this message translates to:
  /// **'Clicca per loggarti'**
  String get tap_login;

  /// No description provided for @go_to_gate.
  ///
  /// In it, this message translates to:
  /// **'Vai ai gates'**
  String get go_to_gate;

  /// No description provided for @go_to_event.
  ///
  /// In it, this message translates to:
  /// **'Vai agli eventi'**
  String get go_to_event;

  /// No description provided for @select_gate.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un gate'**
  String get select_gate;

  /// No description provided for @select_event.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un evento'**
  String get select_event;

  /// No description provided for @go_to_scan.
  ///
  /// In it, this message translates to:
  /// **'Vai alla scansione'**
  String get go_to_scan;

  /// No description provided for @change_choose.
  ///
  /// In it, this message translates to:
  /// **'Vuoi cambiare le tue scelte?'**
  String get change_choose;

  /// No description provided for @setting.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get setting;

  /// No description provided for @events.
  ///
  /// In it, this message translates to:
  /// **'Eventi'**
  String get events;

  /// No description provided for @manifestations.
  ///
  /// In it, this message translates to:
  /// **'Manifestazioni'**
  String get manifestations;

  /// No description provided for @gates.
  ///
  /// In it, this message translates to:
  /// **'Gates'**
  String get gates;

  /// No description provided for @scan_exclamative.
  ///
  /// In it, this message translates to:
  /// **'Scan!'**
  String get scan_exclamative;

  /// No description provided for @scan_qr.
  ///
  /// In it, this message translates to:
  /// **'Scan QR code'**
  String get scan_qr;

  /// No description provided for @tap_the_button.
  ///
  /// In it, this message translates to:
  /// **'Clicca il bottone sottostante per iniziare la scansione'**
  String get tap_the_button;

  /// No description provided for @history_check.
  ///
  /// In it, this message translates to:
  /// **'Vuoi riguardare le scannerizzazioni?'**
  String get history_check;

  /// No description provided for @logout.
  ///
  /// In it, this message translates to:
  /// **'Logout'**
  String get logout;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
