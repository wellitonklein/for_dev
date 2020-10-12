import './viewmodels/viewmodels.dart';

abstract class ISurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<SurveyResultViewModel> get surveyResultStream;
  Future<void> loadData();
}
