import 'package:idol/net/request/base.dart';

/// Following && For You
class FollowingForYouRequest implements BaseRequest {
  // 0:following 1:for you
  final int type;
  // page>=1
  final int page;
  // pageSize default 20
  final int limit;

  const FollowingForYouRequest(this.type, this.page, {this.limit = 20})
      : assert(type == 0 || type == 1),
        assert(page >= 1);

  @override
  Map<String, dynamic> toMap({String Function(String key) keyMapper}) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('type'): this.type,
      keyMapper('page'): this.page,
    };
  }
}

/// Following && Foy You Add to my store.
class AddStoreRequest implements BaseRequest{
  final String goodsId;

  AddStoreRequest(this.goodsId);

  @override
  Map<String, dynamic> toMap({String Function(String key) keyMapper}) {
    return {
      keyMapper('goodsId'):this.goodsId,
    }as Map<String, dynamic>;
  }
}