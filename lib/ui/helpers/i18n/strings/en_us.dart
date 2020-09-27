import 'translations_interface.dart';

class EnUs implements ITranslations {
  @override
  String get msgInvalidCredentials => 'Invalid credentials.';

  @override
  String get msgInvalidField => 'Invalid field.';

  @override
  String get msgRequiredField => 'Required field.';

  @override
  String get msgUnexpected => 'Something went wrong. Please try again soon.';

  @override
  String get msgWait => 'Wait . . .';

  @override
  String get login => 'Log in';

  @override
  String get addAccount => 'Add account';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get confirmPassword => 'Confirm password';
}
