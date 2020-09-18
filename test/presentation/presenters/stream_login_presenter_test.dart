import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class IValidation {
  String validate({
    @required String field,
    @required String value,
  });
}

class ValidationSpy extends Mock implements IValidation {}

class StreamLoginPresenter {
  final IValidation validation;

  StreamLoginPresenter({
    @required this.validation,
  });

  void validateEmail(String value) {
    validation.validate(field: 'email', value: value);
  }
}

void main() {
  ValidationSpy validation;
  StreamLoginPresenter sut;
  String email;

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
  });

  test('should call Validation with correct email', () async {
    // act
    sut.validateEmail(email);

    // assert
    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
