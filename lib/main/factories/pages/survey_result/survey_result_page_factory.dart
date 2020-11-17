import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';
import '../pages.dart';

Widget makeSurveyResultPage() {
  return SurveyResultPage(
    presenter: makeGetxSurveyResultPresenter(
      surveyId: Get.parameters['survey_id'],
    ),
  );
}
