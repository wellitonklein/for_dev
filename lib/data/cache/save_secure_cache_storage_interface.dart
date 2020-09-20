import 'package:meta/meta.dart';

abstract class ISaveSecureCacheStorage {
  Future<void> saveSecure({
    @required String key,
    @required String value,
  });
}
