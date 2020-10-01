import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ISignUpPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
    validation: makeSignUpValidation(),
    addAccount: makeRemoteAddAccount(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}
