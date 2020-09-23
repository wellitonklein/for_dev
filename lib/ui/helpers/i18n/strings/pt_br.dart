import 'translations_interface.dart';

class PtBr implements ITranslations {
  @override
  String get msgInvalidCredentials => 'Credenciais inválidas.';

  @override
  String get msgInvalidField => 'Campo inválido.';

  @override
  String get msgRequiredField => 'Campo obrigatório.';

  @override
  String get msgUnexpected =>
      'Algo de errado aconteceu. Tente novamente em breve.';

  @override
  String get msgWait => 'Aguarde . . .';

  @override
  String get login => 'Entrar';

  @override
  String get addAccount => 'Criar conta';

  @override
  String get password => 'Senha';
}
