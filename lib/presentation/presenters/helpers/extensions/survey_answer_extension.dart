import '../../../../domain/entities/entities.dart';
import '../../../../ui/pages/pages.dart';

extension SurveyAnswerEntityExtensions on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: '$percent%',
      );
}
