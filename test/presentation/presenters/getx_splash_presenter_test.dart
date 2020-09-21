import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/ui/pages/pages.dart';

class GexSplashPresenter implements ISplashPresenter {
  final ILoadCurrentAccount loadCurrentAccount;

  var _navigateTo = RxString();

  GexSplashPresenter({@required this.loadCurrentAccount});

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount() async {
    await loadCurrentAccount.load();
  }
}

class LoadCurrentAccountSpy extends Mock implements ILoadCurrentAccount {}

void main() {
  test('should call LoadCurrentAccount', () async {
    // arrange
    final loadCurrentAccount = LoadCurrentAccountSpy();
    final sut = GexSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    // act
    await sut.checkAccount();
    // assert
    verify(loadCurrentAccount.load()).called(1);
  });
}
