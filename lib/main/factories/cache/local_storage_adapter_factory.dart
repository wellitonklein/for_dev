import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/local_storage_adapter.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  final secureStorage = FlutterSecureStorage();
  return LocalStorageAdapter(secureStorage: secureStorage);
}
