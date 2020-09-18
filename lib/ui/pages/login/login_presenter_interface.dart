abstract class ILoginPresenter {
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateEmail(String value);
  void validatePassword(String value);
  void auth();
}
