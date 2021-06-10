import 'dart:io';

import 'package:ecomshare/ecomshare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'package:idol/conf.dart';
import 'package:idol/event/app_event.dart';
import 'package:idol/net/api.dart';
import 'package:idol/router.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/keystore.dart';
import 'package:idol/utils/localStorage.dart';
import 'package:idol/widgets/dialog_share.dart';

class ShareManager {
  static final _storage = new FlutterSecureStorage();

  /// 分享Link
  static void showShareLinkDialog(BuildContext context, String link) {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) {
          return ShareDialog(
            'How to drive sales on social media?',
            videoUrls,
            '1.Add shop link in the bio of social media account.\n2.Attract your fans with great content and post.',
            ShareType.link,
            (channel, shareText, currentImageIndex) {
              final shareChannel = channel == 'System' ? 'More' : channel;
              AppEvent.shared.report(
                  event: AnalyticsEvent.shoplink_share_channel,
                  parameters: {AnalyticsEventParameter.type: shareChannel});

              if ('Copy Link' == channel) {
                //复制
                Clipboard.setData(ClipboardData(text: link));
                EasyLoading.showToast('Link Copied');
              } else {
                Ecomshare.shareTo(Ecomshare.MEDIA_TYPE_TEXT, channel, link, []);
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
  static void showShareGoodsDialog(
      BuildContext context, List<String> imageUrls, String shareText) {
    AppEvent.shared.report(event: AnalyticsEvent.share_product_view);
    debugPrint('shareText >> $shareText');

    showCupertinoModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ShareDialog(
            // 'Share great posts in feed',
            '',
            imageUrls,
            // 'The product is now available in your store.\nShare the news with your fans on social media to make money!',
            '',
            ShareType.goods,
            (shareChannel, newShareText, currentImageIndex) {
              Clipboard.setData(ClipboardData(text: newShareText));

              Future.delayed(Duration(milliseconds: 500), () {
                IdolRoute.pop(context);
                _downloadAll(
                  context,
                  imageUrls,
                  shareChannel,
                  currentImageIndex,
                  newShareText,
                );
              });
            },
            shareText: shareText,
            tips: '',
          );
        });
  }

  static void _downloadAll(BuildContext context, List<String> imageUrls,
      String shareChannel, int currentImageIndex, String shareText) async {
    debugPrint(
        'Download shareChannel >>> $shareChannel currentImageIndex >>> $currentImageIndex');

    EasyLoading.show(status: 'Downloading...');
    try {
      List<String> imageLocalPaths = await Future.wait(
          imageUrls.map((e) => downloadPicture(context, e)).toList());

      EasyLoading.dismiss();

      _showGuideDialog(
        context,
        Ecomshare.MEDIA_TYPE_IMAGE,
        videoUrls[0],
        shareChannel,
        imageLocalPaths,
        currentImageIndex,
        shareText,
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
    List<String> imageLocalPaths,
    int currentImageIndex,
    String shareText,
  ) async {
    final channel = shareChannel == 'System' ? 'More' : shareChannel;
    AppEvent.shared.report(
        event: AnalyticsEvent.product_share_channel,
        parameters: {AnalyticsEventParameter.type: channel});

    if (shareChannel != 'Download All') {
      Ecomshare.shareTo(
              mediaType,
              shareChannel,
              imageLocalPaths[currentImageIndex],
              imageLocalPaths.take(6).toList())
          .then((value) {
        Future.delayed(Duration(milliseconds: 500), () {
          Clipboard.setData(ClipboardData(text: shareText));
        });
      });

      imageLocalPaths.removeAt(currentImageIndex);
    }

    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      imageLocalPaths.forEach((imageLocalPath) {
        ImageGallerySaver.saveFile(imageLocalPath);
      });
    }

    EasyLoading.showSuccess('All images downloaded, and capture copied');
  }
}

void downloadImagesAndCopyText(
    BuildContext context, List<String> imageUrls, String shareText) async {
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

    Clipboard.setData(ClipboardData(text: shareText));
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}

Future<String> downloadPicture(BuildContext context, String imageUrl) async {
  String savePath;
  try {
    Directory tempDir = await getTemporaryDirectory();
    savePath = tempDir.path + '/' + Uuid().v4() + '.jpg';

    return DioClient.getInstance()
        .download(imageUrl, savePath)
        .then((value) async {
      final targetPath = tempDir.path + '/' + Uuid().v4() + '.jpg';
      final file = await FlutterImageCompress.compressAndGetFile(
        savePath,
        targetPath,
        quality: 70,
      );
      debugPrint('file.absolute.path >>> ${file.absolute.path}');
      return file.absolute.path;
    });
  } catch (e) {
    return Future.error(e);
  }
}
