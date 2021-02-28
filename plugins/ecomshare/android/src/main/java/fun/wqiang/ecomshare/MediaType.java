package fun.wqiang.ecomshare;

import androidx.annotation.StringDef;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Instagram share media type.
 * @author AKid <a href="mailto:gaopengfeidev@gmail.com">Contact me.</a>
 * @version 1.0
 * @since 15:36
 */
@StringDef({
        MediaType.IMAGE,
        MediaType.VIDEO,
})
@Retention(RetentionPolicy.SOURCE)
public @interface MediaType {
    String IMAGE = "image/*";
    String VIDEO = "video/*";
}
