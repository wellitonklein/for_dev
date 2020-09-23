enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return 'Campo obrigatório.';
        break;
      case UIError.invalidField:
        return 'Campo inválido.';
        break;
      case UIError.invalidCredentials:
        return 'Credenciais inválidas.';
        break;
      case UIError.unexpected:
        return 'Algo de errado aconteceu. Tente novamente em breve.';
      default:
        return 'Tente novamente em breve.';
    }
  }
}
