import 'package:meta/meta.dart';

abstract class IFecthSecureCacheStorage {
  Future<String> fetchSecure({@required String key});
}
