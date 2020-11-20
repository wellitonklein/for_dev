import 'package:get/get.dart';
import 'package:meta/meta.dart';

mixin NavigationMixin {
  void handleNavigation({
    @required Stream<String> stream,
    bool clear = false,
  }) {
    stream.listen((page) {
      if (page?.isNotEmpty == true) {
        if (clear == true) {
          Get.offAllNamed(page);
        } else {
          Get.toNamed(page);
        }
      }
    });
  }
}
