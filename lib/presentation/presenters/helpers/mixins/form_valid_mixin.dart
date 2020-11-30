import 'package:get/get.dart';

mixin FormValidMixin on GetxController {
  var _isFormValid = false.obs;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  set isFormValid(bool value) => _isFormValid.subject.add(value);
}
