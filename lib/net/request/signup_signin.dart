import 'package:idol/net/request/base.dart';

/// 登录|注册
class SignUpSignInRequest extends BaseRequest {
  final String email;
  final String password;
  final String userName;

  SignUpSignInRequest(this.email, this.password, {this.userName});

  @override
  Map<String, dynamic> toMap({String Function(String key) keyMapper}) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('email'): this.email,
      keyMapper('password'): this.password,
      keyMapper('userName'): this.userName,
    };
  }
}

class ValidateEmailRequest extends BaseRequest{
  final String email;

  ValidateEmailRequest(this.email);

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('email'): this.email,
    };
  }
}

class SignUpRequest extends BaseRequest{
  final String email;
  final String password;
  final String userName;

  SignUpRequest(this.email, this.password, this.userName);

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('email'): this.email,
      keyMapper('password'): this.password,
      keyMapper('userName'): this.userName,
    };
  }
}