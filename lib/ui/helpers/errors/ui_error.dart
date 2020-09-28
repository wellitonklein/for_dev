import '../helpers.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return R.strings.msgRequiredField;
        break;
      case UIError.invalidField:
        return R.strings.msgInvalidField;
        break;
      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;
        break;
      case UIError.unexpected:
        return R.strings.msgUnexpected;
      case UIError.emailInUse:
        return R.strings.msgEmailInUse;
      default:
        return 'Tente novamente em breve.';
    }
  }
}
