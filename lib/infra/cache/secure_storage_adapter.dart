import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';

class SecureStorageAdapter
    implements ISaveSecureCacheStorage, IFetchSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageAdapter({@required this.secureStorage});

  @override
  Future<void> saveSecure({
    @required String key,
    @required String value,
  }) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String> fetchSecure({@required String key}) async {
    return await secureStorage.read(key: key);
  }
}
