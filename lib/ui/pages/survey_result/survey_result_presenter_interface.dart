import 'package:meta/meta.dart';
import './viewmodels/viewmodels.dart';

abstract class ISurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<SurveyResultViewModel> get surveyResultStream;
  Future<void> loadData();
  Future<void> save({@required String answer});
}
