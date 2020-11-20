import 'package:flutter/material.dart';

import '../../mixins/mixins.dart';
import 'splash.dart';

class SplashPage extends StatelessWidget with NavigationMixin {
  final ISplashPresenter presenter;

  const SplashPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('4Dev'),
      ),
      body: Builder(builder: (context) {
        handleNavigation(stream: presenter.navigateToStream, clear: true);

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
