package com.dukaanbot.inventory;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // The TTS reply (base64 MP3) is played via audio.play() right after the
        // network call returns. Android blocks media playback that isn't tied to a
        // direct user gesture by default, which would silence the voice reply.
        // The whole flow IS user-initiated (tap record -> tap stop), so it's safe
        // to relax this here and let the reply auto-play.
        getBridge().getWebView().getSettings().setMediaPlaybackRequiresUserGesture(false);
    }
}
