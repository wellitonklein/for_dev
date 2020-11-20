import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../../widgets/widgets.dart';
import 'login_presenter_interface.dart';
import 'widgets/widgets.dart';

class LoginPage extends StatelessWidget
    with KeyboardMixin, LoadingMixin, UIErrorMixin, NavigationMixin {
  final ILoginPresenter presenter;

  const LoginPage({Key key, @required this.presenter}) : super(key: key);

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
                HeadLine1Widget(text: R.strings.login),
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
                            onPressed: presenter.goToSignUp,
                            icon: const Icon(Icons.person),
                            label: Text(R.strings.addAccount),
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
