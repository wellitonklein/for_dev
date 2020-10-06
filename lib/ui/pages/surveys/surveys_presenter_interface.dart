import 'survey_viewmodel.dart';

abstract class ISurveysPresenter {
  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get loadSurveysStream;

  Future<void> loadData();
}
