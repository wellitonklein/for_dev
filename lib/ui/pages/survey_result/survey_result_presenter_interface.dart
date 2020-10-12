abstract class ISurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<dynamic> get surveyResultStream;
  Future<void> loadData();
}
