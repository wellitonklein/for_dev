import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter_interface.dart';

class LoginButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);
    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return RaisedButton(
            onPressed: snapshot.data == true ? presenter.auth : null,
            child: Text('Entrar'.toUpperCase()),
          );
        });
  }
}
