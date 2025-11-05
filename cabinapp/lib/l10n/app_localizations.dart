import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CabinApp'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get noAccount;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get emailInvalid;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 6 characters long'**
  String get passwordTooShort;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get registerButton;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @alreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyAccount;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutButton;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @organizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organizationTitle;

  /// No description provided for @createNew.
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get createNew;

  /// No description provided for @joinWithCode.
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get joinWithCode;

  /// No description provided for @organizationName.
  ///
  /// In en, this message translates to:
  /// **'Organization name'**
  String get organizationName;

  /// No description provided for @createOrganization.
  ///
  /// In en, this message translates to:
  /// **'Create organization'**
  String get createOrganization;

  /// No description provided for @invitationCode.
  ///
  /// In en, this message translates to:
  /// **'Invitation code'**
  String get invitationCode;

  /// No description provided for @joinOrganization.
  ///
  /// In en, this message translates to:
  /// **'Join organization'**
  String get joinOrganization;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @cabins.
  ///
  /// In en, this message translates to:
  /// **'Cabins'**
  String get cabins;

  /// No description provided for @reservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get reservations;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @enterValidCode.
  ///
  /// In en, this message translates to:
  /// **'Enter valid code'**
  String get enterValidCode;

  /// No description provided for @enterValidName.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name'**
  String get enterValidName;

  /// No description provided for @invalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get invalidFormat;

  /// No description provided for @noActiveOrganization.
  ///
  /// In en, this message translates to:
  /// **'No active organization'**
  String get noActiveOrganization;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorLabel;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleLabel;

  /// No description provided for @reservation.
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get reservation;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @organizationCleared.
  ///
  /// In en, this message translates to:
  /// **'Organization cleared from session'**
  String get organizationCleared;

  /// No description provided for @removeOrganization.
  ///
  /// In en, this message translates to:
  /// **'Remove organization'**
  String get removeOrganization;

  /// No description provided for @alreadyInOrganization.
  ///
  /// In en, this message translates to:
  /// **'You already belong to this organization.'**
  String get alreadyInOrganization;

  /// No description provided for @joinOrganizationError.
  ///
  /// In en, this message translates to:
  /// **'Error joining the organization'**
  String get joinOrganizationError;

  /// No description provided for @joinOrganizationUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error joining the organization'**
  String get joinOrganizationUnexpectedError;

  /// No description provided for @myOrganizations.
  ///
  /// In en, this message translates to:
  /// **'My organizations'**
  String get myOrganizations;

  /// No description provided for @organizationSelected.
  ///
  /// In en, this message translates to:
  /// **'Organization selected'**
  String get organizationSelected;

  /// No description provided for @noOrganizationsYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t belong to any organization yet'**
  String get noOrganizationsYet;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat your password'**
  String get confirmPasswordHint;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDontMatch;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccess;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up here'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyHaveAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue.'**
  String get signInToContinue;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// No description provided for @startExperience.
  ///
  /// In en, this message translates to:
  /// **'Start your CabinApp experience.'**
  String get startExperience;

  /// No description provided for @noCabinsYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any cabins yet'**
  String get noCabinsYet;

  /// No description provided for @createCabin.
  ///
  /// In en, this message translates to:
  /// **'Create cabin'**
  String get createCabin;

  /// No description provided for @cabinNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Cabin name'**
  String get cabinNameLabel;

  /// No description provided for @cabinCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get cabinCapacityLabel;

  /// No description provided for @cabinCreated.
  ///
  /// In en, this message translates to:
  /// **'Cabin created successfully'**
  String get cabinCreated;

  /// No description provided for @cabinError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading cabins'**
  String get cabinError;

  /// No description provided for @addCabin.
  ///
  /// In en, this message translates to:
  /// **'Add cabin'**
  String get addCabin;

  /// No description provided for @enterCabinName.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid cabin name'**
  String get enterCabinName;

  /// No description provided for @enterCapacity.
  ///
  /// In en, this message translates to:
  /// **'Enter the cabin capacity'**
  String get enterCapacity;

  /// No description provided for @invalidCapacity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid capacity'**
  String get invalidCapacity;

  /// No description provided for @createCabinTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new cabin'**
  String get createCabinTitle;

  /// No description provided for @creatingCabin.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creatingCabin;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add client'**
  String get addClient;

  /// No description provided for @createClient.
  ///
  /// In en, this message translates to:
  /// **'Create client'**
  String get createClient;

  /// No description provided for @createClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Register new client'**
  String get createClientTitle;

  /// No description provided for @clientNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Client name'**
  String get clientNameLabel;

  /// No description provided for @enterClientName.
  ///
  /// In en, this message translates to:
  /// **'Enter the client name'**
  String get enterClientName;

  /// No description provided for @clientPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get clientPhoneLabel;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enterPhone;

  /// No description provided for @customerCreated.
  ///
  /// In en, this message translates to:
  /// **'Client created successfully'**
  String get customerCreated;

  /// No description provided for @noClientsYet.
  ///
  /// In en, this message translates to:
  /// **'No clients registered yet'**
  String get noClientsYet;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @reserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get reserved;

  /// No description provided for @noReservationsForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No reservations for this day'**
  String get noReservationsForThisDay;

  /// No description provided for @addReservation.
  ///
  /// In en, this message translates to:
  /// **'Add reservation'**
  String get addReservation;

  /// No description provided for @newReservationTitle.
  ///
  /// In en, this message translates to:
  /// **'New reservation'**
  String get newReservationTitle;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get statusCanceled;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
