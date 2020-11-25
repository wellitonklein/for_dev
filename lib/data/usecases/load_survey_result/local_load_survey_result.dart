import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveyResult implements ILoadSurveyResult {
  final ICacheStorage cacheStorage;

  LocalLoadSurveyResult({@required this.cacheStorage});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final response = await cacheStorage.fetch(key: 'survey_result/$surveyId');
      if (response?.isEmpty != false) {
        throw Exception();
      }
      return LocalSurveyResultModel.fromJson(response).toEntity();
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
