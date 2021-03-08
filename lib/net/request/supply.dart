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
      keyMapper('limit'): this.limit,
    };
  }
}

/// Following && Foy You Add to my store.
class AddStoreRequest implements BaseRequest {
  final String goodsId;

  const AddStoreRequest(this.goodsId);

  @override
  Map<String, dynamic> toMap({String Function(String key) keyMapper}) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('goodsId'): this.goodsId,
    };
  }
}

class GoodsDetailRequest implements BaseRequest {
  final String supplierId;
  final String goodsId;

  GoodsDetailRequest(this.supplierId, this.goodsId);

  @override
  Map<String, dynamic> toMap({String Function(String key) keyMapper}) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('supplierId'): this.supplierId,
      keyMapper('goodsId'): this.goodsId,
    };
  }
}

class SupplierInfoRequest implements BaseRequest {
  final String supplierId;

  SupplierInfoRequest(this.supplierId);

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('supplierId'): this.supplierId,
    };
  }
}

class SupplierGoodsListRequest implements BaseRequest {
  final String supplierId;
  final int type;
  final int page;
  final int limit;

  SupplierGoodsListRequest(this.supplierId, this.type, this.page,
      {this.limit = 20});

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('supplierId'): this.supplierId,
      keyMapper('type'): this.type,
      keyMapper('page'): this.page,
      keyMapper('limit'): this.limit,
    };
  }
}

class FollowRequest implements BaseRequest {
  final String supplierId;

  FollowRequest(this.supplierId);

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('supplierId'): this.supplierId,
    };
  }
}
