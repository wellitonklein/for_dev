abstract class ILoginPresenter {
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<String> get mainErrorStream;
  Stream<String> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateEmail(String value);
  void validatePassword(String value);
  Future<void> auth();
  void dispose();
}
