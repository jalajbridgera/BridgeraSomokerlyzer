package com.reactlibrary.smokerlyzer.callback;

public interface AudioMethods {




    void _onResume();
    void _onPause();

    int checkAudioPermission();

    int checkTelephonyPermission();

    void initialization();

    void resetDeviceButtonTimer();
    void disabledDeviceTimerFired();

    void startAudio();
    void stopAudio();

    void setDeviceMode(boolean isDeviceMode);



    void startCountDown();



    void beginTimerIntervalFired();

    void beginTimerFinishedForCountDown();



    void registerBroadcastReceiver();

    void deregisterBroadcastReceiver();

    void initSystemServices();
}
