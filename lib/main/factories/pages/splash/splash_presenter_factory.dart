import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ISplashPresenter makeGetXSplashPresenter() {
  return GexSplashPresenter(loadCurrentAccount: makeLocalLoadCurrentAccount());
}
