import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../data/cache/cache.dart';
import '../../../infra/cache/local_storage_adapter.dart';

ISaveSecureCacheStorage makeLocalStorageAdapter() {
  final secureStorage = FlutterSecureStorage();
  return LocalStorageAdapter(secureStorage: secureStorage);
}
