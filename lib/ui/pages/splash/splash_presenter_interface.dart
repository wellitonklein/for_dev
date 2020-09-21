abstract class ISplashPresenter {
  Stream<String> get navigateToStream;
  Future<void> checkAccount({int durationInSeconds});
}
