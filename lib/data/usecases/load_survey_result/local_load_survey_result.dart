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
      return _mapToEntity(response);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate({@required String surveyId}) async {
    try {
      final response = await cacheStorage.fetch(key: 'survey_result/$surveyId');
      _mapToEntity(response);
    } catch (_) {
      await cacheStorage.delete(key: 'survey_result/$surveyId');
    }
  }

  Future<void> save(SurveyResultEntity surveyResult) async {
    try {
      await cacheStorage.save(
        key: 'survey_result/${surveyResult.surveyId}',
        value: LocalSurveyResultModel.fromEntity(surveyResult).toJson(),
      );
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  SurveyResultEntity _mapToEntity(Map json) =>
      LocalSurveyResultModel.fromJson(json).toEntity();
}
