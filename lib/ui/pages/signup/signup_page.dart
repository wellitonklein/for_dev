import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';
import 'signup_presenter_interface.dart';
import 'widgets/widgets.dart';

class SignUpPage extends StatelessWidget {
  final ISignUpPresenter presenter;

  const SignUpPage({Key key, this.presenter}) : super(key: key);
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
          if (isLoading == true) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.mainErrorStream.listen((error) {
          if (error != null) {
            showErrorMessage(context: context, message: error.description);
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
                HeadLine1Widget(text: R.strings.addAccount),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => presenter,
                    child: Form(
                      child: Column(
                        children: [
                          NameInputWidget(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: EmailInputWidget(),
                          ),
                          PasswordInputWidget(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordConfirmationInputWidget(),
                          ),
                          SignUpButtonWidget(),
                          FlatButton.icon(
                            onPressed: presenter.goToLogin,
                            icon: const Icon(Icons.exit_to_app),
                            label: Text(R.strings.login),
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
