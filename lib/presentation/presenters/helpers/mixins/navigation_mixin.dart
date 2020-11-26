import 'package:get/get.dart';

mixin NavigationMixin on GetxController {
  final _navigateTo = RxString();
  Stream<String> get navigateToStream => _navigateTo.stream;
  set navigateTo(String value) => _navigateTo.subject.add(value);
}
