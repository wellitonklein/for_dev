import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class ISaveSurveyResult {
  Future<SurveyResultEntity> save({@required String answer});
}
