import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../widgets/widgets.dart';

mixin LoadingMixin {
  void handleLoading({
    @required BuildContext context,
    @required Stream<bool> stream,
  }) {
    stream.listen((isLoading) {
      if (isLoading == true) {
        showLoading(context);
      } else {
        hideLoading(context);
      }
    });
  }
}
