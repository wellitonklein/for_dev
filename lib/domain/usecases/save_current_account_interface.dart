import '../entities/entities.dart';

abstract class ISaveCurrentAccount {
  Future<void> save(AccountEntity account);
}
