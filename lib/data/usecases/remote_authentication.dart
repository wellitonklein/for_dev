import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';
import '../models/models.dart';

class RemoteAuthentication {
  final IHttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<AccountEntity> auth({@required AuthenticationParams params}) async {
    try {
      final response = await httpClient.request(
        url: url,
        method: 'POST',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      );
      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.secret,
      );

  Map toJson() => {
        'email': email,
        'password': password,
      };
}
