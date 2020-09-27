import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../signup_presenter_interface.dart';

class EmailInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ISignUpPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColorLight,
              ),
              errorText: snapshot.hasData ? snapshot.data.description : null,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: presenter.validateEmail,
            autocorrect: false,
          );
        });
  }
}
