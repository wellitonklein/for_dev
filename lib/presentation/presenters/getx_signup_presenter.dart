import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../dependencies/dependencies.dart';

class GetxSignUpPresenter extends GetxController {
  final IValidation validation;
  final IAddAccount addAccount;

  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;

  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _passwordConfirmationError = Rx<UIError>();
  var _isFormValid = false.obs;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
  });

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  void validateName(String value) {
    _name = value;
    _nameError.value = _validateField(field: 'name', value: value);
    _validateForm();
  }

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

  void validatePasswordConfirmation(String value) {
    _passwordConfirmation = value;
    _passwordConfirmationError.value =
        _validateField(field: 'passwordConfirmation', value: value);
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
    _isFormValid.value = _nameError.value == null &&
        _emailError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
  }

  Future<void> signUp() async {
    await addAccount.add(
      params: AddAccountParams(
        name: _name,
        email: _email,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      ),
    );
  }

  void dispose() {}
}
