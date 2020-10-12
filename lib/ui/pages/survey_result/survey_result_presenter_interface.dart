abstract class ISurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Future<void> loadData();
}
