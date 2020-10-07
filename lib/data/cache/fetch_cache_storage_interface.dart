import 'package:meta/meta.dart';

abstract class ICacheStorage {
  Future<dynamic> fetch({@required String key});
}
