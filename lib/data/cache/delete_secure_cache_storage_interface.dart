import 'package:meta/meta.dart';

abstract class IDeleteSecureCacheStorage {
  Future<void> delete({@required String key});
}
