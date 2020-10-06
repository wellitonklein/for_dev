import 'survey_viewmodel.dart';

abstract class ISurveysPresenter {
  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;

  Future<void> loadData();
}
