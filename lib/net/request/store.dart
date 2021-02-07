import 'package:idol/net/request/base.dart';

/// KOL商品列表
class MyInfoGoodsListRequest implements BaseRequest {
  final String userId;
  final int page;
  final int limit;

  // 0 商品列表 1 商品类目列表
  final int type;

  MyInfoGoodsListRequest(this.userId, this.type, this.page, {this.limit = 20});

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('userId'): this.userId,
      keyMapper('page'): this.page,
      keyMapper('limit'): this.limit,
      keyMapper('type'): this.type,
    } as Map<String, dynamic>;
  }
}

/// 编辑商店
class EditStoreRequest implements BaseRequest {
  final String storePicture;
  final String portrait;
  final String storeName;
  final String userName;
  final String aboutMe;

  EditStoreRequest(
    this.storeName,
    this.userName,
    this.aboutMe, {
    this.storePicture,
    this.portrait,
  });

  @override
  Map<String, dynamic> toMap({String Function(String key) keyMapper}) {
    keyMapper ??= (key) => key;
    return {
      keyMapper('storeName'): this.storeName,
      keyMapper('userName'): this.userName,
      keyMapper('aboutMe'): this.aboutMe,
      keyMapper('storePicture'): this.storePicture,
      keyMapper('portrait'): this.portrait,
    };
  }
}

/// 检测用户名|商店名是否存在
class CheckNameRequest implements BaseRequest{
  final String storeName;
  final String userName;

  CheckNameRequest({this.storeName = '', this.userName = ''});

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('storeName'): this.storeName,
      keyMapper('userName'): this.userName,
    };
  }
}