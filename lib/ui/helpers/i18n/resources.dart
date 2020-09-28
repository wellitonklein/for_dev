import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static ITranslations strings = PtBr();
  static void load(Locale locale) {
    switch (locale.toString()) {
      default:
        strings = PtBr();
    }
  }
}
