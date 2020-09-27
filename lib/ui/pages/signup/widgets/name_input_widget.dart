import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class NameInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.name,
        icon: Icon(
          Icons.person,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      keyboardType: TextInputType.name,
      autocorrect: false,
    );
  }
}
