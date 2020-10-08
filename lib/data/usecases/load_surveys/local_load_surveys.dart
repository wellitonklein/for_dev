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
      return _map(response);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    final response = await cacheStorage.fetch(key: 'surveys');
    try {
      _map(response);
    } catch (_) {
      await cacheStorage.delete(key: 'surveys');
    }
  }

  List<SurveyEntity> _map(List<Map> list) => list
      .map<SurveyEntity>(
        (json) => LocalSurveyModel.fromJson(json).toEntity(),
      )
      .toList();
}
