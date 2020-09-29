import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../ui/helpers/helpers.dart';

import '../dependencies/dependencies.dart';

class GetxSignUpPresenter extends GetxController {
  final IValidation validation;

  var _emailError = Rx<UIError>();
  var _isFormValid = false.obs;

  GetxSignUpPresenter({
    @required this.validation,
  });

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  void validateEmail(String value) {
    _emailError.value = _validateField(field: 'email', value: value);
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
    _isFormValid.value = false;
  }

  void dispose() {}
}
