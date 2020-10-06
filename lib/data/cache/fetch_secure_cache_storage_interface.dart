import 'package:meta/meta.dart';

abstract class IFetchSecureCacheStorage {
  Future<String> fetchSecure({@required String key});
}
