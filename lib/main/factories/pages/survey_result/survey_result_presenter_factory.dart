import 'package:flutter/foundation.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ISurveyResultPresenter makeGetxSurveyResultPresenter({
  @required String surveyId,
}) {
  return GetxSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
    surveyId: surveyId,
  );
}
