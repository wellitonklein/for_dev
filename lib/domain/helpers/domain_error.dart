enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas.';
        break;
      case DomainError.unexpected:
        return 'Algo de errado aconteceu. Tente novamente em breve.';
      default:
        return '';
    }
  }
}
