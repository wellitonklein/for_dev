import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../pages.dart';
import 'widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  final ILoginPresenter presenter;

  const LoginPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.mainErrorStream.listen((error) {
          if (error?.isNotEmpty == true) {
            showErrorMessage(context: context, message: error);
          }
        });

        presenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });

        return GestureDetector(
          onTap: _hideKeyboard,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeaderWidget(),
                HeadLine1Widget(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInputWidget(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordInputWidget(),
                          ),
                          LoginButtonWidget(),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person),
                            label: const Text('Criar conta'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
