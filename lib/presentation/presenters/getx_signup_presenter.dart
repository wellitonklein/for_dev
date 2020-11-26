import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../dependencies/dependencies.dart';
import 'helpers/helpers.dart';

class GetxSignUpPresenter extends GetxController
    with AuthMixin, UIErrorMixin, LoadingMixin, NavigationMixin, FormValidMixin
    implements ISignUpPresenter {
  final IValidation validation;
  final IAddAccount addAccount;
  final ISaveCurrentAccount saveCurrentAccount;

  String _name;
  String _passwordConfirmation;

  var _nameError = Rx<UIError>();
  var _passwordConfirmationError = Rx<UIError>();

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });

  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;

  void validateName(String value) {
    _name = value;
    _nameError.value = _validateField('name');
    _validateForm();
  }

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

  void validatePasswordConfirmation(String value) {
    _passwordConfirmation = value;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
    _validateForm();
  }

  UIError _validateField(String field) {
    final formData = {
      'name': _name,
      'email': email,
      'password': password,
      'passwordConfirmation': _passwordConfirmation,
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
    isFormValid = _nameError.value == null &&
        emailError == null &&
        passwordError == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        email != null &&
        password != null &&
        _passwordConfirmation != null;
  }

  Future<void> signUp() async {
    isLoading = true;
    try {
      final account = await addAccount.add(
        params: AddAccountParams(
          name: _name,
          email: email,
          password: password,
          passwordConfirmation: _passwordConfirmation,
        ),
      );
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          mainError = UIError.emailInUse;
          break;
        default:
          mainError = UIError.unexpected;
      }
      isLoading = false;
    }
  }

  void dispose() {}

  @override
  void goToLogin() {
    navigateTo = '/login';
  }
}
