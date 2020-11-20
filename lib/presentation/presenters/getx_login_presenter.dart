import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../dependencies/dependencies.dart';
import 'mixins/mixins.dart';

class GetXLoginPresenter extends GetxController
    with AuthMixin, UIErrorMixin, LoadingMixin, NavigationMixin, FormValidMixin
    implements ILoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;
  final ISaveCurrentAccount saveCurrentAccount;

  GetXLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  void validateEmail(String value) {
    email = value;
    emailError = _validateField('email');
    _validateForm();
  }

  void validatePassword(String value) {
    password = value;
    passwordError = _validateField('password');
    _validateForm();
  }

  UIError _validateField(String field) {
    final formData = {
      'email': email,
      'password': password,
    };
    final error = validation.validate(field: field, input: formData);
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
    isFormValid = emailError == null &&
        passwordError == null &&
        email != null &&
        password != null;
  }

  Future<void> auth() async {
    isLoading = true;

    try {
      final account = await authentication.auth(
          params: AuthenticationParams(
        email: email,
        secret: password,
      ));
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        default:
          mainError = UIError.unexpected;
      }

      isLoading = false;
    }
  }

  void dispose() {}

  @override
  void goToSignUp() {
    navigateTo = '/signup';
  }
}
