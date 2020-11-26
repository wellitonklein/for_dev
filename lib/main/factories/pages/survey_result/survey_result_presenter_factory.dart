import 'package:flutter/foundation.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ISurveyResultPresenter makeGetxSurveyResultPresenter({
  @required String surveyId,
}) {
  return GetxSurveyResultPresenter(
    surveyId: surveyId,
    loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
    saveSurveyResult: makeRemoteSaveSurveyResult(surveyId),
  );
}
