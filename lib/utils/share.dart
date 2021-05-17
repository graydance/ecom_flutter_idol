import 'dart:io';

import 'package:ecomshare/ecomshare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol/conf.dart';
import 'package:idol/event/app_event.dart';
import 'package:idol/net/api.dart';
import 'package:idol/router.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/keystore.dart';
import 'package:idol/utils/localStorage.dart';
import 'package:idol/widgets/dialog_share.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class ShareManager {
  static final _storage = new FlutterSecureStorage();

  /// 分享Link
  static void showShareLinkDialog(BuildContext context, String link) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ShareDialog(
            'How to drive sales on social media?',
            videoUrls,
            '1.Add shop link in the bio of social media account.\n2.Attract your fans with great content and post.',
            ShareType.link,
            (channel) {
              final shareChannel = channel == 'System' ? 'More' : channel;
              AppEvent.shared.report(
                  event: AnalyticsEvent.shoplink_share_channel,
                  parameters: {AnalyticsEventParameter.type: shareChannel});

              if ('Copy Link' == channel) {
                //复制
                Clipboard.setData(ClipboardData(text: link));
                EasyLoading.showToast('$link\n is Replicated!');
              } else {
                print('channel:' + channel + " , link:" + link);
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
  static void showShareGoodsDialog(BuildContext context, List<String> imageUrls,
      String goodsName, String price) {
    AppEvent.shared.report(event: AnalyticsEvent.share_product_view);

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ShareDialog(
              // 'Share great posts in feed',
              '',
              imageUrls,
              // 'The product is now available in your store.\nShare the news with your fans on social media to make money!',
              '',
              ShareType.goods, (shareChannel) {
            if (shareChannel != 'Download All') {
              EasyLoading.showToast('Capture copied');
            }
            final shareText =
                '$goodsName+ at US \$$price / piece only.\n\n\n🚨 LINK IN BIO TO SHOP⤵️\n\n🚨 FELLOW ME FOR SAVING 💰\n\n\n#olaak #rundeals #couponer #deals #savingmonsy #coupons #couponcommunity';
            Clipboard.setData(ClipboardData(text: shareText));

            Future.delayed(Duration(milliseconds: 500), () {
              IdolRoute.pop(context);
              _downloadAll(context, imageUrls, shareChannel);
            });
          }, tips: ''
              // 'Tips: Share your own pictures with product can increase 38% Sales.',
              );
        });
  }

  static void _downloadAll(
      BuildContext context, List<String> imageUrls, shareChannel) async {
    debugPrint('Download images >>> $imageUrls');

    EasyLoading.show(status: 'Downloading...');
    try {
      List<String> imageLocalPaths = await Future.wait(
          imageUrls.map((e) => downloadPicture(context, e)).toList());

      EasyLoading.dismiss();
      EasyLoading.showSuccess('All images downloaded, and capture copied');

      _showGuideDialog(
        context,
        Ecomshare.MEDIA_TYPE_IMAGE,
        videoUrls[0],
        shareChannel,
        imageLocalPaths,
      );
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  static void _showGuideDialog(
      BuildContext context,
      String mediaType,
      String guideVideoUrl,
      String shareChannel,
      List<String> imageLocalPaths) async {
    final channel = shareChannel == 'System' ? 'More' : shareChannel;
    AppEvent.shared.report(
        event: AnalyticsEvent.product_share_channel,
        parameters: {AnalyticsEventParameter.type: channel});

    if (shareChannel != 'Download All') {
      Ecomshare.shareTo(mediaType, shareChannel, imageLocalPaths.first);
    } else {
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        imageLocalPaths.forEach((imageLocalPath) {
          ImageGallerySaver.saveFile(imageLocalPath);
        });
      }
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

void downloadImages(BuildContext context, List<String> imageUrls) async {
  debugPrint('Download images >>> $imageUrls');

  EasyLoading.show(status: 'Downloading...');
  try {
    List<String> imageLocalPaths = await Future.wait(
        imageUrls.map((e) => downloadPicture(context, e)).toList());

    EasyLoading.dismiss();
    EasyLoading.showSuccess(imageUrls.length > 1
        ? 'All images downloaded, and capture copied'
        : 'Image downloaded, and capture copied');

    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      imageLocalPaths.forEach((imageLocalPath) {
        ImageGallerySaver.saveFile(imageLocalPath);
      });
    }
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}

Future<String> downloadPicture(BuildContext context, String imageUrl) async {
  String savePath;
  try {
    Directory tempDir = await getTemporaryDirectory();
    savePath = tempDir.path + '/' + Uuid().v4() + '.jpg';
  } catch (e) {
    return Future.error(e);
  }
  return DioClient.getInstance().download(imageUrl, savePath);
}
