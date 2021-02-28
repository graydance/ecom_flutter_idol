package fun.wqiang.ecomshare;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import fun.wqiang.ecomshare.BuildConfig;
import com.twitter.sdk.android.tweetcomposer.TweetUploadService;

/**
 * You can use the Receiver receive results shared on Twitter.
 *
 * @author AKid <a href="mailto:gaopengfeidev@gmail.com">Contact me.</a>
 * @version 1.0
 * @since 12:15
 */
public class TwitterResultReceiver extends BroadcastReceiver {

    private static final String TAG = TwitterResultReceiver.class.getSimpleName();

    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle intentExtras = intent.getExtras();
        if (TweetUploadService.UPLOAD_SUCCESS.equals(intent.getAction())) {
            // success
            final Long twitterId = intentExtras.getLong(TweetUploadService.EXTRA_TWEET_ID);
            if (BuildConfig.DEBUG) {
                Log.e(TAG, "Share to twitter success >>> twitterId：" + twitterId);
            }
        } else if (TweetUploadService.UPLOAD_FAILURE.equals(intent.getAction())) {
            // failure
            final Intent retryIntent = intentExtras.getParcelable(TweetUploadService.EXTRA_RETRY_INTENT);
            boolean retry = intentExtras.getBoolean("retry");
            if (BuildConfig.DEBUG) {
                Log.e(TAG, "Share to twitter failure >>> retry：" + retry);
            }
            if (!retry) {
                retryIntent.putExtra("retry", true);
                context.getApplicationContext().startActivity(retryIntent);
            }
        } else if (TweetUploadService.TWEET_COMPOSE_CANCEL.equals(intent.getAction())) {
            // cancel
            if (BuildConfig.DEBUG) {
                Log.e(TAG, "Share to twitter cancel >>>");
            }
        }
    }
}
