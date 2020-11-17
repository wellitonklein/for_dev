import 'package:meta/meta.dart';

abstract class IDeleteSecureCacheStorage {
  Future<void> deleteSecure({@required String key});
}
