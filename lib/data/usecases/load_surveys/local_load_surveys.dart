import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements ILoadSurveys {
  final ICacheStorage cacheStorage;

  LocalLoadSurveys({@required this.cacheStorage});

  Future<List<SurveyEntity>> load() async {
    try {
      final response = await cacheStorage.fetch(key: 'surveys');
      if (response?.isEmpty != false) {
        throw Exception();
      }
      return _mapToEntity(response);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final response = await cacheStorage.fetch(key: 'surveys');
      _mapToEntity(response);
    } catch (_) {
      await cacheStorage.delete(key: 'surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    try {
      await cacheStorage.save(key: 'surveys', value: _mapToJson(surveys));
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  List<SurveyEntity> _mapToEntity(dynamic list) => list
      .map<SurveyEntity>(
        (json) => LocalSurveyModel.fromJson(json).toEntity(),
      )
      .toList();

  List<Map> _mapToJson(List<SurveyEntity> list) => list
      .map(
        (entity) => LocalSurveyModel.fromEntity(entity).toJson(),
      )
      .toList();
}
