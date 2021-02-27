package fun.wqiang.ecomshare;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.StrictMode;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import androidx.core.content.FileProvider;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareHashtag;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.model.ShareMediaContent;
import com.facebook.share.model.SharePhoto;
import com.facebook.share.model.ShareVideo;
import com.facebook.share.widget.ShareDialog;
import com.twitter.sdk.android.core.Twitter;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

import java.io.File;
import java.lang.ref.WeakReference;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

/**
 * Facebook Share SDK {@link "https://developers.facebook.com/docs/sharing/android/"}
 * Facebook AppLinks SDK {@link "https://developers.facebook.com/docs/applinks/android"}
 * Instagram Share SDK {@link "https://developers.facebook.com/docs/instagram/sharing-to-feed"}
 * SnapChat Share SDK {@link "https://kit.snapchat.com/docs/creative-kit-android"}
 * Twitter  Share SDK {@link "https://github.com/twitter-archive/twitter-kit-android"}
 *
 * @author AKid <a href="mailto:gaopengfeidev@gmail.com">Contact me.</a>
 * @version 1.0
 * @since 13:03
 */
public class ShareManager {

    private static final String TAG = ShareManager.class.getSimpleName();

    private CallbackManager mFacebookShareCallbackManager;
    private static WeakReference<Activity> mWRActivity;
    private static Context mApplicationContext;

    private ShareManager() {

    }

    static class InnerHolder {
        private static final ShareManager INSTANCE = new ShareManager();
    }

    public static ShareManager getInstance(Activity activity) {
        if (mWRActivity == null || activity != mWRActivity.get()) {
            mWRActivity = new WeakReference<>(activity);
            mApplicationContext = activity.getApplicationContext();
        }
        if (!FacebookSdk.isInitialized()) {
            FacebookSdk.setApplicationId(mApplicationContext.getString(R.string.facebook_app_id));
            FacebookSdk.sdkInitialize(mApplicationContext);
        }
        return InnerHolder.INSTANCE;
    }

    public void shareLink2Facebook(String link) {
        shareLink2Facebook(link, null, null);
    }

    public void shareLink2Facebook(String link, String tag) {
        shareLink2Facebook(link, tag, null);
    }

    public void shareLink2Facebook(String link, String tag, String quote) {
        if (!TextUtils.isEmpty(tag) && !tag.startsWith("#")) {
            tag = "#" + tag;
        }
        ShareLinkContent shareLinkContent = new ShareLinkContent.Builder()
                .setContentUrl(Uri.parse(link))
                // 话题标签
                .setShareHashtag(new ShareHashtag.Builder().setHashtag(tag).build())
                // 设置引文
                .setQuote(quote)
                .build();
        ShareDialog shareDialog = new ShareDialog(mWRActivity.get());
        shareDialog.show(shareLinkContent);
    }

    /**
     * 推荐使用隐式Intent方式来调用Facebook分享，Facebook sdk原生分享会依赖网络且部分机型默认直接走onError回调无法分享。
     *
     * @param content 文本内容/媒体资源本地路径
     */
    public void shareMedia2FacebookByIntent(String mediaType, String... content) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        if (EcomsharePlugin.MEDIA_TYPE_TEXT.equals(mediaType)) {
            intent.putExtra(Intent.EXTRA_TEXT, content);
        } else {
            if (content != null && content.length == 1) {
                intent.putExtra(Intent.EXTRA_STREAM, parse2Uri(content[0]));
            } else {
                ArrayList<Uri> uris = new ArrayList<>(content.length);
                intent = new Intent(Intent.ACTION_SEND_MULTIPLE);
                for (int i = 0; i < content.length; i++) {
                    if (i >= 6) {
                        // FB最大支持6个照片和视频元素内容
                        break;
                    }
                    uris.add(parse2Uri(content[i]));
                }
                intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris);
            }
        }
        intent.setType(EcomsharePlugin.MEDIA_TYPE_TEXT.equals(mediaType) ? "text/plain" : "video/;image/");
        intent.setPackage("com.facebook.katana");
        mWRActivity.get().startActivity(Intent.createChooser(intent, "Share to Facebook"));
    }

    public void shareMedia2Facebook(String... localMediaPaths) {
        _share2Facebook(createShareContent(localMediaPaths));
    }

    private void _share2Facebook(ShareMediaContent shareContent) {
        ShareDialog shareDialog = new ShareDialog(mWRActivity.get());
        _share2Facebook(shareDialog, shareContent);
    }

    private void _share2Facebook(ShareDialog shareDialog, ShareMediaContent shareContent) {
        mFacebookShareCallbackManager = CallbackManager.Factory.create();
        shareDialog.registerCallback(mFacebookShareCallbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {
                if (BuildConfig.DEBUG) {
                    Log.e(TAG, "Share to facebook success >>> result postId：" + result.getPostId());
                }
            }

            @Override
            public void onCancel() {
                if (BuildConfig.DEBUG) {
                    Log.e(TAG, "Share to facebook cancel >>>");
                }
            }

            @Override
            public void onError(FacebookException error) {
                if (BuildConfig.DEBUG) {
                    Log.e(TAG, "Share to facebook error >>> error：" + error.getMessage());
                }
            }
        });
        shareDialog.show(shareContent);
    }

    private ShareMediaContent createShareContent(String... localMediaPaths) {
        ShareMediaContent.Builder mediaBuilder = new ShareMediaContent.Builder();
        for (int i = 0; i < localMediaPaths.length; i++) {
            if (i >= 6) {
                // FB最大支持6个照片和视频元素内容
                break;
            }
            String localMediaPath = localMediaPaths[i];
            if (isImageSource(localMediaPath)) {
                SharePhoto sharePhoto = new SharePhoto.Builder()
                        .setImageUrl(parse2Uri(localMediaPath)).build();
                mediaBuilder.addMedium(sharePhoto);
            }
            if (isVideoSource(localMediaPath)) {
                ShareVideo shareVideo = new ShareVideo.Builder()
                        .setLocalUrl(parse2Uri(localMediaPath)).build();
                mediaBuilder.addMedium(shareVideo);
            }

        }
        return mediaBuilder.build();
    }

    private boolean isImageSource(String localMediaPath) {
        if (!TextUtils.isEmpty(localMediaPath)) {
            localMediaPath = localMediaPath.toLowerCase();
        } else {
            return false;
        }
        return localMediaPath.contains(".jpg") || localMediaPath.contains(".png") || localMediaPath.contains(".jpeg")
                || localMediaPath.contains(".gif") || localMediaPath.contains(".webp")
                || localMediaPath.contains(".bmp");
    }

    private boolean isVideoSource(String mediaUrl) {
        if (!TextUtils.isEmpty(mediaUrl)) {
            mediaUrl = mediaUrl.toLowerCase();
        } else {
            return false;
        }
        return mediaUrl.contains(".mp4") || mediaUrl.contains(".avi") || mediaUrl.contains(".3gp")
                || mediaUrl.contains(".mpg") || mediaUrl.contains(".mpeg") || mediaUrl.contains(".mkv")
                || mediaUrl.contains(".mov") || mediaUrl.contains(".rmvb") || mediaUrl.contains("wmv")
                || mediaUrl.contains(".flv");
    }

    public void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        if (mFacebookShareCallbackManager != null) {
            mFacebookShareCallbackManager.onActivityResult(requestCode, resultCode, data);
        }
    }

    private boolean isJpgOrPng(String mediaUrl) {
        if (!TextUtils.isEmpty(mediaUrl)) {
            mediaUrl = mediaUrl.toLowerCase();
        } else {
            return false;
        }
        return mediaUrl.contains(".jpg") || mediaUrl.contains(".png") || mediaUrl.contains(".jpeg");
    }

    private boolean isMp4AndSizeLessThan100M(String mediaUrl) {
        return !TextUtils.isEmpty(mediaUrl)
                && mediaUrl.toLowerCase().contains(".mp4")
                && new File(mediaUrl).length() <= 100 * 1024 * 1024;
    }

    /**
     * 分享到Twitter
     *
     * @param mediaType Text/Image
     * @param content   Local image/video url
     * @param tags      # tags
     */
    public void share2Twitter(String mediaType, String content, String... tags) {
        Twitter.initialize(mApplicationContext);
        TweetComposer.Builder builder = new TweetComposer.Builder(mWRActivity.get());
        if (EcomsharePlugin.MEDIA_TYPE_TEXT.equals(mediaType)) {
            if (content.startsWith("http://") || content.startsWith("https://")) {
                try {
                    builder.url(new URL(content));
                } catch (MalformedURLException e) {
                    e.printStackTrace();
                }
            } else {
                builder.text(content);
            }
        } else {
            builder.image(parse2Uri(content));
        }
        builder.show();
        // 该分享必须结合Twitter登录，且session不能为空。
        /*
        String[] newTags = null;
        if (tags != null && tags.length != 0) {
            newTags = new String[tags.length];
            for (int i = 0; i < tags.length; i++) {
                if (!tags[i].contains("#")) {
                    newTags[i] = "#" + tags[i];
                } else {
                    newTags[i] = tags[i];
                }
            }
        }
        final TwitterSession session = TwitterCore.getInstance().getSessionManager()
                .getActiveSession();
        final Intent intent = new ComposerActivity.Builder(mApplicationContext)
                .session(session)
                .image(parse2Uri(localImagePath))
                .text(content)
                .hashtags(newTags)
                // .darkTheme()
                .createIntent();
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        mApplicationContext.getApplicationContext().startActivity(intent);*/
    }

    /**
     * 分享到Instagram动态
     * {@link "https://gist.github.com/michaeltys/a8613e5aea9db8e4684bf85568e40160"}
     *
     * @param content 文本/本地资源路径
     */
    public void share2Instagram(String mediaType, String content) {
        /*@MediaType String type;
        type = isVideoSource(localMediaPath) ? MediaType.VIDEO : MediaType.IMAGE;
        // Create the new Intent using the 'Send' action.
        Intent share = new Intent(Intent.ACTION_SEND);
        share.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        // Set the MIME type
        share.setType(type);
        // Create the URI from the media
        // Add the URI to the Intent.
        share.putExtra(Intent.EXTRA_STREAM, parse2Uri(localMediaPath));
        // Broadcast the Intent.
        mApplicationContext.startActivity(Intent.createChooser(share, title));*/

        Intent feedIntent = new Intent(Intent.ACTION_SEND);
        if (EcomsharePlugin.MEDIA_TYPE_TEXT.equals(mediaType)) {
            feedIntent.setType("text/plain");
            feedIntent.putExtra(Intent.ACTION_SEND, content);
        } else {
            @MediaType String type;
            type = isVideoSource(content) ? MediaType.VIDEO : MediaType.IMAGE;
            feedIntent.setType(type);
            feedIntent.putExtra(Intent.EXTRA_STREAM, parse2Uri(content));
        }
        feedIntent.setPackage("com.instagram.android");

        Intent storiesIntent = new Intent("com.instagram.share.ADD_TO_STORY");
        if (EcomsharePlugin.MEDIA_TYPE_IMAGE.equals(mediaType)) {
            storiesIntent.setDataAndType(parse2Uri(content), isVideoSource(content) ? "mp4" : "jpg");
            mWRActivity.get().grantUriPermission(
                    "com.instagram.android", parse2Uri(content), Intent.FLAG_GRANT_READ_URI_PERMISSION);
        } else {
            storiesIntent.setType("text/plain");
            storiesIntent.putExtra(Intent.EXTRA_TEXT, content);
        }
        storiesIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        storiesIntent.setPackage("com.instagram.android");
        Intent chooserIntent = Intent.createChooser(feedIntent, "Share to");
        chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, new Intent[]{storiesIntent});
        chooserIntent.putExtra(Intent.EXTRA_TEXT, content);
        mWRActivity.get().startActivity(chooserIntent);
    }

    private boolean isInstagramSupportMediaFormat(String localMediaPath) {
        if (!TextUtils.isEmpty(localMediaPath)) {
            localMediaPath = localMediaPath.toLowerCase();
        }
        return !TextUtils.isEmpty(localMediaPath)
                && (localMediaPath.contains(".jpeg")
                || localMediaPath.contains(".jpg")
                || localMediaPath.contains(".gif")
                || localMediaPath.contains(".png")
                || localMediaPath.contains(".mkv")
                || localMediaPath.contains(".mp4"));
    }

    private Uri parse2Uri(String localMediaPath) {
        return FileProvider.getUriForFile(mApplicationContext,
                mApplicationContext.getPackageName() + ".fileprovider", new File(localMediaPath));
    }

    /**
     * 调用系统分享
     *
     * @param mediaType 分享文本内容
     * @param content   分享媒体资源
     */
    public void shareBySystemShareComponent(String mediaType, String content) {
        StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
        StrictMode.setVmPolicy(builder.build());
        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        if (EcomsharePlugin.MEDIA_TYPE_IMAGE.equals(mediaType)) {
            Uri uri = parse2Uri(content);
            shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
            shareIntent.setType(isVideoSource(content) ? MediaType.VIDEO : MediaType.IMAGE);
        } else {
            shareIntent.setType("text/plain");
            shareIntent.putExtra(Intent.EXTRA_TEXT, content);
        }
        shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        try {
            shareIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mWRActivity.get().startActivity(Intent.createChooser(shareIntent, "Share"));
        } catch (Exception ex) {
            Toast.makeText(mWRActivity.get(), ex.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }
}
