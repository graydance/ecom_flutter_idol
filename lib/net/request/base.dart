abstract class BaseRequest {
  Map<String, dynamic> toMap({
    String keyMapper(String key),
  });
}

class BaseRequestImpl extends BaseRequest{
  @override
  Map<String, dynamic> toMap({String Function(String key) keyMapper}) {
    return Map();
  }
}