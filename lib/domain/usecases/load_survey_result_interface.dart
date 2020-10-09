import '../entities/entities.dart';

abstract class ILoadSurveyResult {
  Future<SurveyResultEntity> loadBySurvey({String surveyId});
}
