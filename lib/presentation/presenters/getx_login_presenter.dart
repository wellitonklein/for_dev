import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../dependencies/dependencies.dart';

class GetXLoginPresenter extends GetxController implements ILoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;
  final ISaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;

  var _emailError = RxString();
  var _passwordError = RxString();
  var _mainError = RxString();
  var _navigateTo = RxString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  GetXLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  Stream<String> get emailErrorStream => _emailError.stream;
  Stream<String> get passwordErrorStream => _passwordError.stream;
  Stream<String> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  void validateEmail(String value) {
    _email = value;
    _emailError.value = validation.validate(field: 'email', value: value);
    _validateForm();
  }

  void validatePassword(String value) {
    _password = value;
    _passwordError.value = validation.validate(field: 'password', value: value);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    _isLoading.value = true;

    try {
      final account = await authentication.auth(
          params: AuthenticationParams(
        email: _email,
        secret: _password,
      ));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (e) {
      _mainError.value = e.description;
      _isLoading.value = false;
    }
  }

  void dispose() {}
}
