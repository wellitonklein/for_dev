import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteAddAccount implements IAddAccount {
  final IHttpClient httpClient;
  final String url;

  RemoteAddAccount({
    @required this.httpClient,
    @required this.url,
  });

  Future<AccountEntity> add({@required AddAccountParams params}) async {
    await httpClient.request(
      url: url,
      method: 'POST',
      body: RemoteAddAccountParams.fromDomain(params).toJson(),
    );
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) =>
      RemoteAddAccountParams(
        name: params.name,
        email: params.email,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
      );

  Map toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };
}
