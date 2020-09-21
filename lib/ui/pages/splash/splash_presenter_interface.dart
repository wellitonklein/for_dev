abstract class ISplashPresenter {
  Stream<String> get navigateToStream;
  Future<void> loadCurrentAccount();
}
