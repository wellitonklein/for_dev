import 'package:localstorage/localstorage.dart';

import '../../../infra/cache/cache.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  final localStorage = LocalStorage('fordev');
  return LocalStorageAdapter(localStorage: localStorage);
}
