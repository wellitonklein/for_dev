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
  Future<void> checkAccount() async {
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = account.isNull ? '/login' : '/surveys';
    } catch (_) {
      _navigateTo.value = '/login';
    }
  }
}
