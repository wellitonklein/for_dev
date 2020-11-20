import 'package:get/get.dart';
import 'package:meta/meta.dart';

mixin SessionMixin {
  void handleSessionExpired({@required Stream<bool> stream}) {
    stream.listen((isExpired) {
      if (isExpired == true) {
        Get.offAllNamed('/login');
      }
    });
  }
}
