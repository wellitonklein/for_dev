abstract class ILoginPresenter {
  Stream get emailErrorStream;
  Stream get passwordErrorStream;
  Stream get isFormValidStream;

  void validateEmail(String value);
  void validatePassword(String value);
  void auth();
}
