import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'splash.dart';

class SplashPage extends StatelessWidget {
  final ISplashPresenter presenter;

  const SplashPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('4Dev'),
      ),
      body: Builder(builder: (context) {
        presenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
