import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../helpers/helpers.dart';
import '../widgets/widgets.dart';

mixin UIErrorMixin {
  void handleMainError({
    @required BuildContext context,
    @required Stream<UIError> error,
  }) {
    error.listen((error) {
      if (error != null) {
        showErrorMessage(context: context, message: error.description);
      }
    });
  }
}
