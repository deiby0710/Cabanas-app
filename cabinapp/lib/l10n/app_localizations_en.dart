// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CabinApp';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get noAccount => 'Don\'t have an account? Sign up';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get emailInvalid => 'Invalid email';

  @override
  String get passwordTooShort => 'Must be at least 6 characters long';

  @override
  String get registerButton => 'Sign Up';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get alreadyAccount => 'Already have an account? Sign in';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get logoutButton => 'Log out';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get organizationTitle => 'Organization';

  @override
  String get createNew => 'Create new';

  @override
  String get joinWithCode => 'Join with code';

  @override
  String get organizationName => 'Organization name';

  @override
  String get createOrganization => 'Create organization';

  @override
  String get invitationCode => 'Invitation code';

  @override
  String get joinOrganization => 'Join organization';

  @override
  String get members => 'Members';

  @override
  String get home => 'Home';

  @override
  String get cabins => 'Cabins';

  @override
  String get reservations => 'Reservations';

  @override
  String get clients => 'Clients';

  @override
  String get enterValidCode => 'Enter valid code';

  @override
  String get enterValidName => 'Enter a valid name';

  @override
  String get invalidFormat => 'Invalid format';

  @override
  String get noActiveOrganization => 'No active organization';

  @override
  String get errorLabel => 'Error';

  @override
  String get noName => 'No name';

  @override
  String get roleLabel => 'Role';

  @override
  String get reservation => 'Reservation';

  @override
  String get client => 'Client';

  @override
  String get confirmed => 'Confirmed';
}
