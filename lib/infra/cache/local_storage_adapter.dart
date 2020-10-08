import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter implements ICacheStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  Future<dynamic> fetch({@required String key}) async {
    return await localStorage.getItem(key);
  }

  Future<void> delete({@required String key}) async {
    await localStorage.deleteItem(key);
  }

  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }
}
