import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/domain/entities/account_entity.dart';
import 'package:for_dev/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements ILoadCurrentAccount {}

void main() {
  GexSplashPresenter sut;
  LoadCurrentAccountSpy loadCurrentAccount;

  PostExpectation mockLoadCurrentAccountCall() =>
      when(loadCurrentAccount.load());

  void mockLoadCurrentAccount({AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GexSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(token: faker.guid.guid()));
  });

  test('should call LoadCurrentAccount', () async {
    // arrange

    // act
    await sut.checkAccount();
    // assert
    verify(loadCurrentAccount.load()).called(1);
  });

  test('should go to surveys page on success', () async {
    // arrange

    // assert
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    // act
    await sut.checkAccount();
  });

  test('should go to login page on null result', () async {
    // arrange
    mockLoadCurrentAccount(account: null);

    // assert
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    // act
    await sut.checkAccount();
  });

  test('should go to login page on error', () async {
    // arrange
    mockLoadCurrentAccountError();

    // assert
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    // act
    await sut.checkAccount();
  });
}
