import 'package:meta/meta.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements ILoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final response = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(response);
      return response;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }
      await local.validate(surveyId: surveyId);
      return await local.loadBySurvey(surveyId: surveyId);
    }
  }
}
