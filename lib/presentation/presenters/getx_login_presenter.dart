import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../dependencies/dependencies.dart';

class GetXLoginPresenter extends GetxController implements ILoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;
  final ISaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;

  var _emailError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _navigateTo = RxString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  GetXLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  void validateEmail(String value) {
    _email = value;
    _emailError.value = _validateField(field: 'email', value: value);
    _validateForm();
  }

  void validatePassword(String value) {
    _password = value;
    _passwordError.value = _validateField(field: 'password', value: value);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
        break;
      case ValidationError.requiredField:
        return UIError.requiredField;
        break;
      default:
        return null;
    }
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
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;
        default:
          _mainError.value = UIError.unexpected;
      }

      _isLoading.value = false;
    }
  }

  void dispose() {}

  @override
  void goToSignUp() {
    _navigateTo.value = '/signup';
  }
}
