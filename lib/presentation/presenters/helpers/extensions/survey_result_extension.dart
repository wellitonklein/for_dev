import '../../../../domain/entities/entities.dart';
import '../../../../ui/pages/pages.dart';
import 'survey_answer_extension.dart';

extension SurveyResultEntityExtensions on SurveyResultEntity {
  SurveyResultViewModel toViewModel() => SurveyResultViewModel(
        surveyId: surveyId,
        question: question,
        answers: answers.map((answer) => answer.toViewModel()).toList(),
      );
}
