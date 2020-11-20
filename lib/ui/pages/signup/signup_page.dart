import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../../widgets/widgets.dart';
import 'signup_presenter_interface.dart';
import 'widgets/widgets.dart';

class SignUpPage extends StatelessWidget
    with KeyboardMixin, LoadingMixin, UIErrorMixin, NavigationMixin {
  final ISignUpPresenter presenter;

  const SignUpPage({Key key, this.presenter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        handleLoading(context: context, stream: presenter.isLoadingStream);
        handleMainError(context: context, error: presenter.mainErrorStream);
        handleNavigation(stream: presenter.navigateToStream, clear: true);

        return GestureDetector(
          onTap: () => hideKeyboard(context),
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
