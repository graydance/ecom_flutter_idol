import 'package:idol/net/request/base.dart';

class AddLinksRequest implements BaseRequest{
  // 	link类型(0:link类型 ,1:Text类型),默认0
  final int linkType;
  // linkType 为1的时候必传
  final String linkText;
  // 	link 名称
  final String linkName;
  // link 的地址
  final String linkUrl;
  // link 的图标
  final String linkIcon;
  // 是否置顶 默认0未置顶,1已置顶
  final String isTop;
  // 开关,默认0关闭,1开启
  final String isPrivate;

  AddLinksRequest(this.linkType, {this.linkText, this.linkName,
    this.linkUrl, this.linkIcon, this.isTop, this.isPrivate});

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('linkType'): this.linkType,
      keyMapper('linkText'): this.linkText,
      keyMapper('linkName'): this.linkName,
      keyMapper('linkUrl'): this.linkUrl,
      keyMapper('linkIcon'): this.linkIcon,
      keyMapper('isTop'): this.isTop,
      keyMapper('isPrivate'): this.isPrivate,
    };
  }
}
class EditLinksRequest implements BaseRequest{

  // link 的id
  final String linkId;
  // 	link类型(0:link类型 ,1:Text类型),默认0
  final int linkType;
  // linkType 为1的时候必传
  final String linkText;
  // 	link 名称
  final String linkName;
  // link 的地址
  final String linkUrl;
  // link 的图标
  final String linkIcon;
  // 是否置顶 默认0未置顶,1已置顶
  final String isTop;
  // 开关,默认0关闭,1开启
  final String isPrivate;

  EditLinksRequest(this.linkId, this.linkType, this.linkText, this.linkName,
      this.linkUrl, this.linkIcon, this.isTop, this.isPrivate);

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('linkId'): this.linkId,
      keyMapper('linkType'): this.linkType,
      keyMapper('linkText'): this.linkText,
      keyMapper('linkName'): this.linkName,
      keyMapper('linkUrl'): this.linkUrl,
      keyMapper('linkIcon'): this.linkIcon,
      keyMapper('isTop'): this.isTop,
      keyMapper('isPrivate'): this.isPrivate,
    };
  }
}

class DeleteLinksRequest implements BaseRequest{
  final String linkId;

  DeleteLinksRequest(this.linkId);

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('linkId'): this.linkId,
    };
  }
}

class UpdateUserInfoRequest implements BaseRequest{
  // 0: userName 1: avatar 2: storeDescription
  int type;
  String value;

  UpdateUserInfoRequest(UpdateUserInfoFieldType type, String value){
    this.type = type.index;
    this.value = value;
  }

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('type'): this.type,
      keyMapper('value'): this.value,
    };
  }
}

enum UpdateUserInfoFieldType{
  userName,
  portrait,
  storeDescription,
}