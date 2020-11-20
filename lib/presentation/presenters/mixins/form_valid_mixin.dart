import 'package:get/get.dart';

mixin FormValidMixin {
  var _isFormValid = false.obs;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  set isFormValid(bool value) => _isFormValid.value = value;
}
