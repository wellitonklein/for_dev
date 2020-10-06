import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ISurveysPresenter makeGetxSurveysPresenter() {
  return GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveys());
}
