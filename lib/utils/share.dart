import 'dart:io';
import 'package:ecomshare/ecomshare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:idol/conf.dart';
import 'package:idol/net/api.dart';
import 'package:idol/router.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/keystore.dart';
import 'package:idol/widgets/dialog_share.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';

class ShareManager {
  static final _storage = new FlutterSecureStorage();

  /// 分享Link
  static void showShareLinkDialog(BuildContext context, String link) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ShareDialog(
            'How to sales on socials',
            videoUrls[0],
            '1. Go to my Social account;\n2. Edit profile;\n3. Paste your Shop Link into Bio;\n4. Notice your fans with great post.',
            ShareType.link,
            (channel) {
              if ('Copy Link' == channel) {
                //复制
                Clipboard.setData(ClipboardData(text: link));
                EasyLoading.showToast('$link\n is Replicated!');
              } else {
                Ecomshare.shareTo(Ecomshare.MEDIA_TYPE_TEXT, channel, link);
              }
              IdolRoute.pop(context);
            },
          );
        }).whenComplete(() async {
      String step = await _storage.read(key: KeyStore.GUIDE_STEP);
      if (step == "4") {
        Global.tokGoods.currentState.show();
      }
    });
  }

  /// 分享商品
  static void showShareGoodsDialog(BuildContext context, String imageUrl) {
    showMaterialModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ShareDialog(
            'Share great posts in feed',
            imageUrl,
            'The product is now available in your store.\n share the news with your fans on social media to make money!',
            ShareType.goods,
            (shareChannel) {
              EasyLoading.showToast('Capture copied');
              final shareText =
                  'Just found a terrific stuff, can\'t wait to share! Check my link in bio  #Mypik.shop #Mypik  #supportsmallbusinesses';
              Clipboard.setData(ClipboardData(text: shareText));

              Future.delayed(Duration(milliseconds: 500), () {
                IdolRoute.pop(context);
                _downloadPicture(context, imageUrl, shareChannel);
              });
            },
            tips:
                'Tips: Share your own pictures with product can increase 38% Sales.',
          );
        });
  }

  static void _downloadPicture(
      BuildContext context, String imageUrl, shareChannel) async {
    EasyLoading.show(status: 'Downloading...');
    String savePath;
    try {
      Directory tempDir = await getTemporaryDirectory();
      savePath = tempDir.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg';
    } catch (e) {
      EasyLoading.showError(e.toString());
      debugPrint(e);
      return;
    }
    DioClient.getInstance().download(imageUrl, savePath).then((savePath) {
      EasyLoading.dismiss();
      _showGuideDialog(
        context,
        Ecomshare.MEDIA_TYPE_IMAGE,
        videoUrls[0],
        shareChannel,
        savePath,
      );
    }).catchError((err) {
      EasyLoading.showError(err.toString());
    });
  }

  static void _showGuideDialog(BuildContext context, String mediaType,
      String guideVideoUrl, String shareChannel, String imageLocalPath) {
    if (shareChannel != 'Download') {
      Ecomshare.shareTo(mediaType, shareChannel, imageLocalPath);
    }

    /*showDialog(
        context: context,
        builder: (context) {
          return ShareDialog(
            'How to share in $shareChannel',
            guideVideoUrl,
            '1. Go to my account in $shareChannel\n 2. Edit profile\n 3. Paste your shop link into Website',
            ShareType.guide,
            (sChannel) {
              Ecomshare.shareTo(mediaType, shareChannel, imageLocalPath);
            },
            shareChannel: shareChannel,
          );
        });*/
  }
}
