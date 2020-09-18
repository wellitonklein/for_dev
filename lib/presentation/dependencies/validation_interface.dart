import 'package:meta/meta.dart';

abstract class IValidation {
  String validate({
    @required String field,
    @required String value,
  });
}
