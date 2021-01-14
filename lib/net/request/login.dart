import 'package:idol/net/request/base.dart';

class LoginRequest extends BaseRequest {
  final String email;
  final String password;

  LoginRequest(this.email, this.password);

  @override
  Map<String, dynamic> toMap({String Function(String key) keyMapper}) {
    keyMapper ??= (key) => key;
    // ignore: unnecessary_cast
    return {
      keyMapper('email'): this.email,
      keyMapper('password'): this.password,
    } as Map<String, dynamic>;
  }
}
