abstract class ISurveysPresenter {
  Stream<bool> get isLoadingStream;

  Future<void> loadData();
}
