import 'package:meta/meta.dart';

abstract class IFetchCacheStorage {
  Future<dynamic> fetch({@required String key});
}
