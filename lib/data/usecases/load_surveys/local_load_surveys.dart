import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements ILoadSurveys {
  final IFetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {
    try {
      final response = await fetchCacheStorage.fetch(key: 'surveys');
      if (response?.isEmpty != false) {
        throw Exception();
      }
      return response
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
