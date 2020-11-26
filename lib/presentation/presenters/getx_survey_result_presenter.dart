import 'package:for_dev/domain/entities/entities.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import 'helpers/helpers.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingMixin, SessionMixin
    implements ISurveyResultPresenter {
  final String surveyId;
  final ILoadSurveyResult loadSurveyResult;
  final ISaveSurveyResult saveSurveyResult;

  final _surveyResult = Rx<SurveyResultViewModel>();

  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.surveyId,
    @required this.saveSurveyResult,
  });

  Future<void> loadData() async {
    _showResultOnAction(
      () => loadSurveyResult.loadBySurvey(surveyId: surveyId),
    );
  }

  Future<void> save({@required String answer}) async {
    _showResultOnAction(
      () => saveSurveyResult.save(answer: answer),
    );
  }

  Future<void> _showResultOnAction(Future<SurveyResultEntity> action()) async {
    try {
      isLoading = true;
      final response = await action();
      _surveyResult.value = response.toViewModel();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}
