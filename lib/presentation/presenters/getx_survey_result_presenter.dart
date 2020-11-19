import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter implements ISurveyResultPresenter {
  final ILoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _isLoading = true.obs;
  final _isSessionExpired = RxBool();
  final _surveyResult = Rx<SurveyResultViewModel>();

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.surveyId,
  });

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final response = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
        surveyId: response.surveyId,
        question: response.question,
        answers: response.answers
            .map(
              (answer) => SurveyAnswerViewModel(
                image: answer.image,
                answer: answer.answer,
                isCurrentAnswer: answer.isCurrentAnswer,
                percent: '${answer.percent}%',
              ),
            )
            .toList(),
      );
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        _isSessionExpired.value = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      _isLoading.value = false;
    }
  }
}
