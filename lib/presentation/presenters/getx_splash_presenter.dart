import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GexSplashPresenter implements ISplashPresenter {
  final ILoadCurrentAccount loadCurrentAccount;

  var _navigateTo = RxString();

  GexSplashPresenter({@required this.loadCurrentAccount});

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = account?.token == null ? '/login' : '/surveys';
    } catch (_) {
      _navigateTo.value = '/login';
    }
  }
}
