import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import 'helpers/helpers.dart';

class GexSplashPresenter extends GetxController
    with NavigationMixin
    implements ISplashPresenter {
  final ILoadCurrentAccount loadCurrentAccount;

  GexSplashPresenter({@required this.loadCurrentAccount});

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      navigateTo = account?.token == null ? '/login' : '/surveys';
    } catch (_) {
      navigateTo = '/login';
    }
  }
}
