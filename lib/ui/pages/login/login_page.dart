import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../pages.dart';

class LoginPage extends StatelessWidget {
  final ILoginPresenter presenter;

  const LoginPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              child: SimpleDialog(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      const Text('Aguarde ...', textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),
            );
          }
        });

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginHeaderWidget(),
              HeadLine1Widget(text: 'Login'),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  child: Column(
                    children: [
                      StreamBuilder<String>(
                        stream: presenter.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorText: (snapshot.data?.isEmpty == true)
                                  ? null
                                  : snapshot.data,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: presenter.validateEmail,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 32),
                        child: StreamBuilder<String>(
                          stream: presenter.passwordErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                errorText: (snapshot.data?.isEmpty == true)
                                    ? null
                                    : snapshot.data,
                              ),
                              obscureText: true,
                              onChanged: presenter.validatePassword,
                            );
                          },
                        ),
                      ),
                      StreamBuilder<bool>(
                          stream: presenter.isFormValidStream,
                          builder: (context, snapshot) {
                            return RaisedButton(
                              onPressed:
                                  snapshot.data == true ? presenter.auth : null,
                              child: Text('Entrar'.toUpperCase()),
                            );
                          }),
                      FlatButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person),
                        label: const Text('Criar conta'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
