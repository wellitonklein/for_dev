import '../../helpers/helpers.dart';

abstract class ISignUpPresenter {
  Stream<UIError> get nameErrorStream;
  Stream<UIError> get emailErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get passwordConfirmationErrorStream;
  Stream<UIError> get mainErrorStream;
  Stream<String> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateName(String value);
  void validateEmail(String value);
  void validatePassword(String value);
  void validatePasswordConfirmation(String value);
  Future<void> signUp();
  void goToLogin();
}
