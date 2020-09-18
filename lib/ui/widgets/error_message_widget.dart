import 'package:flutter/material.dart';

void showErrorMessage({
  @required BuildContext context,
  @required String message,
}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(message, textAlign: TextAlign.center),
    ),
  );
}
