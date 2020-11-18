import 'package:meta/meta.dart';

abstract class IFetchSecureCacheStorage {
  Future<String> fetch({@required String key});
}
