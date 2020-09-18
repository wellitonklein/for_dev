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
  test('should call Validation with correct email', () async {
    // arrange
    final validation = ValidationSpy();
    final sut = StreamLoginPresenter(validation: validation);
    final email = faker.internet.email();

    // act
    sut.validateEmail(email);

    // assert
    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
