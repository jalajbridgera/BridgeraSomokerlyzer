package com.reactlibrary.smokerlyzer.audio;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.media.audiofx.BassBoost;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.View;


import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
//
//import com.facebook.react.modules.core.PermissionAwareActivity;
//import com.facebook.react.modules.core.PermissionListener;
import com.google.gson.Gson;
import com.reactlibrary.R;
import com.reactlibrary.fftpack.RealDoubleFFT;
import com.reactlibrary.smokerlyzer.callback.AudioCallBack;
import com.reactlibrary.smokerlyzer.callback.AudioMethods;
import com.reactlibrary.smokerlyzer.callback.PermissionCallBack;
import com.reactlibrary.smokerlyzer.model.DataModel;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import static com.reactlibrary.RNBridgeraSmokerlyzerModule.constructorCount;

public class SmokerLyzerAudio implements AudioMethods {







    public static final int AUDIO_RECORD_PERMISSION = 1;
    public static final int TELEPHONE_PERMISSION = 2;
    Activity mActivity;
    Gson mGson;
   // Ac


    //smokerlyzer logical variable

    int audioPermission = -1;
    int telephonyPermission = -1;

    int _valuePPM = 0;



    //logical recorder

    private static final String TAG = "BreathTestFragment";
    private static final int PPM_SCALE = 0;
    private static final int BREATH_IN = 1;
    private static final int BREATH_HOLD = 2;
    private static final int BREATH_OUT = 3;


    private static final String ORDERTAG = "ORDER";
    MediaPlayer mPlayer;
    int sampleRate = 41000;
    int channelConfiguration = AudioFormat.CHANNEL_CONFIGURATION_MONO;
    int audioEncoding = AudioFormat.ENCODING_PCM_16BIT;

    double sampleRateOverBlockSize = 0;

    AudioRecord audioRecord;
    private RealDoubleFFT transformer;
    int blockSize;// = 256;
    boolean started = false;
    boolean CANCELLED_FLAG = false;
    RecordAudio recordTask;
    boolean sampleRateUnsupported = false;
    boolean isDeviceMode = false;




    boolean isListening = false;
    float currentFrequency = 0;
    boolean alreadyTakenReading = false;

    float lastPeakRecording = 0;
    int selectedlevel = 0;
    float readingValue = 0;


    int manualPPMReadingPrecise = 0;
    int scaling = 700;

    int countdown = 22;
    boolean begun = false;
    boolean ignoreReadings = true;
    float beforeRecordingCurrentFrequency = 0;

    float frequencyToSubractResultBy = 0;

    List<Float> initialOffsetRecordings = new ArrayList<Float>();
    boolean addToInitialOffset = false;

    boolean beginTimerAlreadyCancelled = false;
    boolean deviceTimerAlreadyCancelled = false;
    boolean overrideConnectedDevice = false;

    CountDownTimer mDisableDevicetimer;
    CountDownTimer mBeginTimer;


    int letDeviceGetreadyBeforeComparingCount = 0;


    //testing

    float highestFreq = 0;
    float highesPpm = 0;

    //pure data


    BassBoost booster;


    ArrayList<Integer> lagList = new ArrayList<Integer>();
    double lagLength = 4;


    Integer[] recentReadings = new Integer[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    double recentReadingLength = 20;
    int counter = 0;
    int recentReadingPosition = 0;


    Integer[] recentReadings2 = new Integer[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    double recentReadingLength2 = 10;
    int recentReadingPosition2 = 0;
    AudioCallBack audioCallBack;

    DataModel dataModel;


    public SmokerLyzerAudio(Activity mActivity, AudioCallBack audioCallBack){


       this.mActivity = mActivity;
       this.audioCallBack = audioCallBack;
        mGson = new Gson();
        initialization();
        initSystemServices();

    }

    @Override
    public void initialization() {
        blockSize = 4096;

        transformer = new RealDoubleFFT(blockSize);
        sampleRateOverBlockSize = sampleRate / blockSize;

        //avinash get pincode from react native storage and pass in this class
    /*    Bundle extras = getArguments();
        if (extras != null) {
        }
        scaling = SmokerlyzerStore.get(mActivity).getCurrentSettings().getScalingFactor();
*/
        overrideConnectedDevice = false;
        ignoreReadings = true;
        addToInitialOffset = false;
        countdown = 18;
        //device mode is handled in receiver handler
        isDeviceMode = false;//ios is =true

        mPlayer = MediaPlayer.create(mActivity, R.raw.tone500square);
        mPlayer.setLooping(true);

    }

    @Override
    public void resetDeviceButtonTimer() {


            //called from Broadcast Receiver
            //called from onResume if begintest button shown

            Log.i(ORDERTAG, "Reset device timerr");
            if (mDisableDevicetimer != null) {
                mDisableDevicetimer.cancel();
            }

            //load patch here
            mDisableDevicetimer = new CountDownTimer(5000, 1000) {

                public void onTick(long millisUntilFinished) {
                    //mTextField.setText("seconds remaining: " + millisUntilFinished / 1000);
                }

                public void onFinish() {
                    //mTextField.setText("done!");
                    disabledDeviceTimerFired();
                }
            }.start();


    }

    @Override
    public void disabledDeviceTimerFired() {

            if (isDeviceMode) {

                //avinash UI update
               // enableButton(mBeginTest, true);
                dataModel = new DataModel();
                DataModel.DataBean dataBean = new DataModel.DataBean();

                dataBean.setButtonName("BeginTest");
                dataBean.setIsButtonClickable(true);
                dataBean.setIsDeviceMode(isDeviceMode);
                dataBean.setButtonInvisible(false);

                dataModel.setKey("buttonUpdate");
                dataModel.setData(dataBean);

                String _data = mGson.toJson(dataModel);
                audioCallBack.notifyDataSetChange(_data);
            }


    }

    @Override
    public void _onResume() {


        transformer = new RealDoubleFFT(blockSize);
        if(telephonyPermission == 0) {
            initSystemServices();
        }
        Log.i(ORDERTAG, "On Resume ");
        Log.i("Audio", "On Resume");


        startAudio();
//        if (mBeginTest.isShown()) {
//            Log.i(ORDERTAG, "on resume reset timer");
//            resetDeviceButtonTimer();
//        }
    }

    @Override
    public void _onPause() {


        Log.i(ORDERTAG, "On Pause ");
        Log.i("Audio", "On Pause");
        Log.i("AUDIO", "stopAudio()  from onpause");
        stopAudio();
        if (mDisableDevicetimer != null) {
            mDisableDevicetimer.cancel();
        }

        if (mBeginTimer != null) {

            mBeginTimer.cancel();
        }

    }

    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public int checkAudioPermission() {
      //  Log.i(ORDERTAG, "checkAudioPermission: current: "+audioPermission);

      //  PermissionAwareActivity activity = getPermissionAwareActivity();

        if(audioPermission != PackageManager.PERMISSION_GRANTED) {
            audioPermission = ContextCompat.checkSelfPermission(mActivity, Manifest.permission.RECORD_AUDIO);
        }
        if (audioPermission != PackageManager.PERMISSION_GRANTED) {

          //  Log.i("AUDIO", "Permissions: do not currently have permission");
            if (ActivityCompat.shouldShowRequestPermissionRationale(mActivity, Manifest.permission.RECORD_AUDIO)) {
                //asked before so explain the reason we need it

               // Log.i("Audio", "Permission: shouldShowRequestPermissionRationale is true");
                AlertDialog.Builder builder = new AlertDialog.Builder(mActivity)
                        .setTitle("Audio Input")
                        .setMessage("To use the iCO device please allow AUDIO RECORD Permissions")
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                               // Log.i("AUDIO", "Permission: alert ok now ask permission");
                                dialog.cancel();
                                    mActivity.requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO}, AUDIO_RECORD_PERMISSION);

                            }
                        });

                AlertDialog alert = builder.create();
                alert.show();
            } else {
                //never asked before so ask

              //  Log.i("AUDIO", "Permission: shouldShowRequestPermissionRationale is false");
                    mActivity.requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO}, AUDIO_RECORD_PERMISSION);

            }

        }
        return audioPermission;
    }



    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public int checkTelephonyPermission() {

       // Log.i(ORDERTAG, "checkTelephonyPermission: : "+telephonyPermission);
        if(telephonyPermission != PackageManager.PERMISSION_GRANTED) {
            telephonyPermission = ContextCompat.checkSelfPermission(mActivity, Manifest.permission.READ_PHONE_STATE);
        }

        if (telephonyPermission != PackageManager.PERMISSION_GRANTED) {

         //   Log.i("TELEPHONE", "Permissions: do not currently have permission");
            if (ActivityCompat.shouldShowRequestPermissionRationale(mActivity, Manifest.permission.READ_PHONE_STATE)) {
                //asked before so explain the reason we need it

             //   Log.i("TELEPHONE", "Permission: shouldShowRequestPermissionRationale is true");
                AlertDialog.Builder builder = new AlertDialog.Builder(mActivity)
                        .setTitle("Stop on Phone call")
                        .setMessage("To stop the iCO device when receiving a phone call please allow Read Phone State Permissions")
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                            //    Log.i("TELEPHONE", "Permission: alert ok now ask permission");
                                dialog.cancel();

                                mActivity.requestPermissions(new String[]{Manifest.permission.READ_PHONE_STATE}, TELEPHONE_PERMISSION);
                            }
                        });

                AlertDialog alert = builder.create();
                alert.show();
            } else {
                //never asked before so ask

             //   Log.i("TELEPHONE", "Permission: shouldShowRequestPermissionRationale is false");
                mActivity.requestPermissions(new String[]{Manifest.permission.READ_PHONE_STATE}, TELEPHONE_PERMISSION);
            }

        }
        return telephonyPermission;
    }





    @Override
    public void startAudio() {

            Log.i(ORDERTAG, "Start Audio ");
            Log.i("AUDIO", "start audio ");

        if (constructorCount==1) {


            constructorCount=+2;
            return;

        } else {
            constructorCount=+2;
        }
        
            if (isDeviceMode) {
                Log.i("Audio", "start audio  is device mode");

                Log.i(ORDERTAG, "mplayer start mPlayer.isPlaying " + mPlayer.isPlaying());
                if (started == true) {
                    Log.i("Audio", "started is true");
                    //started = false;
                    CANCELLED_FLAG = true;
                    //recordTask.cancel(true);
                    try {
                        if (mPlayer.isPlaying() == true) {
                            mPlayer.reset();
                            Log.i("AUDIO", " mPlayer.reset() from startAudio");

                        }
                    } catch (Exception ex) {

                    }
                    try {

                        if (audioRecord != null) {
                            audioRecord.stop();
                            Log.i("AUDIO", " audioRecord.stop() from startAudio");
                        }

                    } catch (IllegalStateException e) {
                        Log.e("Stop failed", e.toString());

                    }


                } else {
                    Log.i("AUDIO", " started is false so check permission");
                    if (audioPermission == PackageManager.PERMISSION_GRANTED) {

                        if(sampleRateUnsupported)
                        {
                            AlertDialog.Builder builder = new AlertDialog.Builder(mActivity)
                                    .setTitle("Android phone/tablet Unsupported")
                                    .setMessage("The audio interface of your phone/talet doesn't support the sample rate required to use the iCO device ")
                                    .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int id) {



                                            dialog.cancel();
                                            dataModel = new DataModel();
                                            DataModel.DataBean dataBean = new DataModel.DataBean();

                                            dataBean.setButtonName("BeginTest");
                                            dataBean.setIsButtonClickable(true);
                                            dataBean.setIsDeviceMode(isDeviceMode);
                                            dataBean.setButtonInvisible(false);
                                            dataBean.setMessage("MainView");

                                            dataModel.setKey("error");
                                            dataModel.setData(dataBean);


                                            String _data = mGson.toJson(dataModel);
                                            audioCallBack.notifyDataSetChange(_data);

                                        }
                                    });

                            AlertDialog alert = builder.create();
                            alert.show();
                        }
                        else {
                            Log.i("AUDIO", " started is false permission is granted");
                            started = true;
                            CANCELLED_FLAG = false;
                            //startStopButton.setText("Stop");
                            mPlayer = MediaPlayer.create(mActivity, R.raw.tone500square);
                            mPlayer.setLooping(true);
                            if (mPlayer.isPlaying() == false) {
                                mPlayer.start();
                                Log.i("AUDIO", " mPlayer.start(); from startAudio");
                            }

                            Log.i("AUDIO", " new record task and execute");
                            recordTask = new RecordAudio();
                            recordTask.execute();
                        }
                    }
                }
            }


    }

    @Override
    public void stopAudio() {


            Log.i("Audio", "stopAudio ");
            if (started == true) {
                Log.i("Audio", "started is true ");
                //started = false;
                CANCELLED_FLAG = true;
                if (recordTask != null) {
                    recordTask.cancel(true);
                    Log.i("Audio", "record task not null set to cancel ");
                    try {
                        if (mPlayer.isPlaying() == true) {
                            mPlayer.reset();
                            Log.i("AUDIO", " mPlayer.reset() from stopAudio");

                        }
                    } catch (Exception ex) {

                    }
                }
                try {

                    if (audioRecord != null) {
                        audioRecord.stop();
                        Log.i("AUDIO", " audioRecord.stop() from stop audio");
                    }

                } catch (IllegalStateException e) {
                    Log.e("Stop failed", e.toString());

                }


            }

            Log.i(ORDERTAG, "stop audio");
            if (mPlayer.isPlaying()) {

                Log.i("AUDIO", "mPlayer.isPlaying() so reset");
                Log.i(ORDERTAG, "stop audio reset");
                mPlayer.reset();
                Uri myUri = Uri.parse("android.resource://" + mActivity.getPackageName() + "/" + R.raw.tone500square);
                try {
                    mPlayer.setDataSource(mActivity, myUri);

                } catch (IOException err) {

                }
            }



    }

    @Override
    public void setDeviceMode(boolean isDeviceMode ) {

        this.isDeviceMode = isDeviceMode;
    }


    public void stopPlayer(){
        try {
            if (audioRecord != null) {
                audioRecord.stop();
                Log.i("AUDIO", " audioRecord.stop() fro onPOstExecute");
            }
        } catch (IllegalStateException e) {
            Log.e("Stop failed", e.toString());

        }
        try {
            if (mPlayer.isPlaying() == true) {
                mPlayer.reset();
                Log.i("AUDIO", " mPlayer.reset() from onPostExecute");

            }
        } catch (Exception ex) {

        }
    }
    @Override
    public void startCountDown() {



            Log.i(ORDERTAG, "Start Countdown ");
            Log.i(ORDERTAG, "beforeRecordingCurrentFrequency " + beforeRecordingCurrentFrequency);
            if (ignoreReadings = true) {
                if ((beforeRecordingCurrentFrequency < 700 || beforeRecordingCurrentFrequency > 1300) && overrideConnectedDevice == false) {
                    if(sampleRateUnsupported)
                    {
                        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity)
                                .setTitle("Android phone/tablet unsupported")
                                .setMessage("The audio interface of your phone/tablet doesn't support the sample rate required to use the iCO Smokerlyzer device ")
                                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                    public void onClick(DialogInterface dialog, int id) {


                                        dialog.cancel();

                                        dataModel = new DataModel();
                                        DataModel.DataBean dataBean = new DataModel.DataBean();

                                        dataBean.setButtonName("BeginTest");
                                        dataBean.setIsButtonClickable(true);
                                        dataBean.setIsDeviceMode(isDeviceMode);
                                        dataBean.setButtonInvisible(false);
                                        dataBean.setMessage("MainView");

                                        dataModel.setKey("error");
                                        dataModel.setData(dataBean);


                                        String _data = mGson.toJson(dataModel);
                                        audioCallBack.notifyDataSetChange(_data);

                                    }
                                });

                        AlertDialog alert = builder.create();
                        alert.show();
                    }
                    else {
                        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity)
                                .setTitle(mActivity.getResources().getString(R.string.connected_device))
                                .setMessage(mActivity.getResources().getString(R.string.an_ico_device_volume_is_too_low))
                                .setPositiveButton(mActivity.getResources().getString(R.string.ok), new DialogInterface.OnClickListener() {
                                    public void onClick(DialogInterface dialog, int id) {
                                        dialog.cancel();
                                        dataModel = new DataModel();
                                        DataModel.DataBean dataBean = new DataModel.DataBean();

                                        dataBean.setButtonName("BeginTest");
                                        dataBean.setIsButtonClickable(true);
                                        dataBean.setIsDeviceMode(isDeviceMode);
                                        dataBean.setButtonInvisible(false);
                                        dataBean.setMessage("MainView");

                                        dataModel.setKey("error");
                                        dataModel.setData(dataBean);


                                        String _data = mGson.toJson(dataModel);
                                        audioCallBack.notifyDataSetChange(_data);
                                    }
                                });

                        AlertDialog alert = builder.create();
                        alert.show();
                    }
                } else {
                    //avinash send to ui update
                    //mBeginTest.setVisibility(View.INVISIBLE);


                    countdown = 22;

                    if (mBeginTimer != null) {
                        mBeginTimer.cancel();
                    }

                    //mMostTheScreenWrapper.setVisibility(View.GONE);
                    // mBreathInMessage.setVisibility(View.VISIBLE);//this needs to be animated
                    //mMainParent.invalidate();

                    //avinash send to ui update
                    //disabled for test
                   // mViewFlipper.setDisplayedChild(BREATH_IN);


                    //start
                    dataModel = new DataModel();
                    DataModel.DataBean dataBean = new DataModel.DataBean();

                    dataBean.setButtonName("BeginTest");
                    dataBean.setIsButtonClickable(false);
                    dataBean.setIsDeviceMode(isDeviceMode);
                    dataBean.setButtonInvisible(true);
                    dataBean.setViewType(BREATH_IN);
                    dataBean.setTime(3);

                    dataModel.setKey("viewTimeUpdate");
                    dataModel.setData(dataBean);

                    String _data = mGson.toJson(dataModel);
                    audioCallBack.notifyDataSetChange(_data);

                    //end

                    beginTimerAlreadyCancelled = false;

                    mBeginTimer = new CountDownTimer(countdown * 1000, 1000) {

                        public void onTick(long millisUntilFinished) {
                            //mTextField.setText("seconds remaining: " + millisUntilFinished / 1000);
                            beginTimerIntervalFired();
                        }

                        public void onFinish() {
                            //mTextField.setText("done!");
                            beginTimerFinishedForCountDown();
                        }
                    }.start();
                }
            }


    }

    @Override
    public void beginTimerIntervalFired() {
            countdown--;


            if (countdown > 3)//>0 on ios
            {
                Log.i(TAG, "frequency during countdown = " + beforeRecordingCurrentFrequency);
            }
            if (countdown == 20)//17 ios
            {
                //prep animation
            }



            if (countdown>19)
            {



                    //start
                    dataModel = new DataModel();
                    DataModel.DataBean dataBean = new DataModel.DataBean();

                    dataBean.setButtonName("");
                    dataBean.setIsDeviceMode(isDeviceMode);
                    dataBean.setTime(countdown - 19);
                    dataModel.setKey("timeUpdate");
                    dataModel.setData(dataBean);


                    String _data = mGson.toJson(dataModel);
                    audioCallBack.notifyDataSetChange(_data);

                    //end

            }

            if (countdown == 19)//16 ios
            {
                //avinash UI update
            //    mTimerCountDownLbl.setText("15");
                //mBreathInMessageLbl.setText("");


                //avinash UI update
                //disabled for test
              //  mViewFlipper.setDisplayedChild(BREATH_HOLD);


                //start
                dataModel = new DataModel();
                DataModel.DataBean dataBean = new DataModel.DataBean();

                dataBean.setButtonName("");
                dataBean.setIsButtonClickable(false);
                dataBean.setIsDeviceMode(isDeviceMode);
                dataBean.setButtonInvisible(true);
                dataBean.setViewType(BREATH_HOLD);
                dataBean.setTime(15);

                dataModel.setKey("viewTimeUpdate");
                dataModel.setData(dataBean);

                String _data = mGson.toJson(dataModel);
                audioCallBack.notifyDataSetChange(_data);

                //end
            }

            if (countdown > 8 && countdown <= 12)//ios >5 <=9
            {
                addToInitialOffset = true;
            }

            if (countdown == 8)//ios 5
            {
                //avinash UI update
              //  mContinueBtn.setText(R.string.continue_to_exhale);
                addToInitialOffset = false;

                float totalOffsets = 0;
                for (float n : initialOffsetRecordings) {
                    totalOffsets += n;
                }

                int numberOfReadingsToUse = 20;
                if (initialOffsetRecordings.size() < 20) {
                    numberOfReadingsToUse = initialOffsetRecordings.size();
                }

                float totalOffsetsFinal20 = 0;
                for (int i = initialOffsetRecordings.size() - 1; i >= 0; i--) {
                    totalOffsetsFinal20 += initialOffsetRecordings.get(i);
                }


                beforeRecordingCurrentFrequency = totalOffsets / initialOffsetRecordings.size();
                frequencyToSubractResultBy = totalOffsetsFinal20 / numberOfReadingsToUse;
                Log.i(TAG, "before recording currentFrequencyFinal= " + beforeRecordingCurrentFrequency);
                Log.i(TAG, "before recording frequencyToSubractResultBy= " + frequencyToSubractResultBy);
            }

            if (countdown == 3)//ios 0
            {
                //disabled for test
                //avinash UI update only mViewFlipper comment out
              //  mViewFlipper.setDisplayedChild(BREATH_OUT);


                ignoreReadings = false;

                //start
                dataModel = new DataModel();
                DataModel.DataBean dataBean = new DataModel.DataBean();

                dataBean.setButtonName("");
                dataBean.setIsButtonClickable(false);
                dataBean.setIsDeviceMode(isDeviceMode);
                dataBean.setButtonInvisible(true);
                dataBean.setViewType(BREATH_OUT);
                dataBean.setTime(countdown);

                dataModel.setKey("viewTimeUpdate");
                dataModel.setData(dataBean);

                String _data = mGson.toJson(dataModel);
                audioCallBack.notifyDataSetChange(_data);

                //end
            }

            if (countdown > 0)//ios -3
            {
                if (countdown > 3 && countdown < 19)//ios 0 and 17
                {

                    //avinash UI update
                 //   mTimerCountDownLbl.setText(Integer.toString(countdown - 3));

                    //start
                    dataModel = new DataModel();
                    DataModel.DataBean dataBean = new DataModel.DataBean();

                    dataBean.setButtonName("");
                    dataBean.setIsDeviceMode(isDeviceMode);
                    dataBean.setTime(countdown - 3);
                    dataModel.setKey("timeUpdate");
                    dataModel.setData(dataBean);


                    String _data = mGson.toJson(dataModel);
                    audioCallBack.notifyDataSetChange(_data);

                    //end

                } else if (countdown <= 3)
                {
                    //start
                    dataModel = new DataModel();
                    DataModel.DataBean dataBean = new DataModel.DataBean();

                    dataBean.setButtonName("");
                    dataBean.setIsDeviceMode(isDeviceMode);
                    dataBean.setTime(countdown);
                    dataModel.setKey("timeUpdate");
                    dataModel.setData(dataBean);


                    String _data = mGson.toJson(dataModel);
                    audioCallBack.notifyDataSetChange(_data);

                    //end
                }
            } else {


                //avinash UI update
               // mTimerCountDownLbl.setText("");

                //start
//                dataModel = new DataModel();
//                DataModel.DataBean dataBean = new DataModel.DataBean();
//
//                dataBean.setIsDeviceMode(isDeviceMode);
//
//
//                dataModel.setKey("timeUpdate");
//                dataModel.setData(dataBean);
//
//                String _data = mGson.toJson(dataModel);
//                audioCallBack.notifyDataSetChange(_data);

                //end

            }



    }

    @Override
    public void beginTimerFinishedForCountDown() {



        //avinash UI update
     //   mPpmSlider.setEnabled(false);

            //coundown finish is -3 in ios which starts at 19
            mBeginTimer.cancel();

            beginTimerAlreadyCancelled = false;
            mBeginTimer = new CountDownTimer(26000, 26000) {

                public void onTick(long millisUntilFinished) {


                }

                public void onFinish() {
                    if (beginTimerAlreadyCancelled == false) {
                        beginTimerAlreadyCancelled = true;
                        mBeginTimer.cancel();

                        alreadyTakenReading = true;
                        //avinash UI update
                     /*   mContinueBtn.setText(R.string.continue_text);
                        enableButton(mContinueBtn, true);*/

                        //start
                        dataModel = new DataModel();
                        DataModel.DataBean dataBean = new DataModel.DataBean();

                        dataBean.setPpmValue(_valuePPM);


                        dataModel.setKey("result");
                        dataModel.setData(dataBean);

                        String _data = mGson.toJson(dataModel);
                        audioCallBack.notifyDataSetChange(_data);

                        //end
                    }


                }
            }.start();

            //TODO set breath in message to invisible
        //avinash UI update

/*            enableButton(mContinueBtn, false);
            mContinueBtn.setVisibility(View.VISIBLE);

            mViewFlipper.setDisplayedChild(PPM_SCALE);*/


//        mBreathInMessage.setVisibility(View.GONE);
//        mMostTheScreenWrapper.setVisibility(View.VISIBLE);
//        mContinueBtn.setVisibility(View.VISIBLE);
//        mDeviceStatus.setVisibility(View.VISIBLE);
//        mDeviceStatusLbl.setVisibility(View.VISIBLE);
//        mPpmScaleWrapper.setVisibility(View.VISIBLE);



    }

    @Override
    public void registerBroadcastReceiver() {

    }

    @Override
    public void deregisterBroadcastReceiver() {

    }

    @Override
    public void initSystemServices() {


        Log.i(ORDERTAG, "Init system service");
        TelephonyManager telephonyManager = (TelephonyManager) mActivity.getSystemService(Context.TELEPHONY_SERVICE);
        telephonyManager.listen(new PhoneStateListener() {
            @Override
            public void onCallStateChanged(int state, String incomingNumber) {
                super.onCallStateChanged(state, incomingNumber);

                Log.i(ORDERTAG, "Init system service: telephonyManager.listen(PhoneStateListener)");
                if (state == TelephonyManager.CALL_STATE_IDLE) {
                    Log.i("AUDIO", "startAudio()  from initSystemServices oncallStateChanged");
                    startAudio();
                } else {
                    Log.i("AUDIO", "stopAudio()  from initSystemsServices onCallStateChanged");
                    stopAudio();
                }

            }
        }, PhoneStateListener.LISTEN_CALL_STATE);
    }







    private void updateFrequencyLabel() {

        long ppm = Math.round(findPeakPPM() * 100) / 100;
        //Log.i("ROUNDEDPPM","rounded ppm is "+ppm);
        float setProgressTo = 0;
        if (ppm <= 6) {
            setProgressTo = (((float) (((float) ppm) / 7)) * 100);
            //vertSlider.value = ((float)ppm /7) +1;
        } else if (ppm <= 10) {
            setProgressTo = (((float) (ppm - 7) / 4) + 1) * 100;
            //vertSlider.value = ((float)(ppm-7) /4) + 2;

        } else if (ppm <= 15) {
            setProgressTo = (((float) (ppm - 11) / 5) + 2) * 100;
            //vertSlider.value = ((float)(ppm-11) /5) +3;

        } else if (ppm <= 20) {
            setProgressTo = ((((float) (ppm - 16) / 5) + 3) * 100);
            //vertSlider.value = ((float)(ppm-16) /5) +4;

        } else if (ppm <= 25) {
            setProgressTo = ((((float) (ppm - 21) / 5) + 4) * 100);
            //vertSlider.value = ((float)(ppm-21) /5) +5;

        } else if (ppm <= 30) {
            setProgressTo = ((((float) (ppm - 26) / 5) + 5) * 100);
            //vertSlider.value = ((float)(ppm-26) /5) +6;

        } else {
            setProgressTo = (((float) (ppm - 31) / 5) + 6) * 100;
            //vertSlider.value = ((float)(ppm-31) /5) +7;
//            if(vertSlider.value >8)
//                vertSlider.value = 8;
        }

        Log.e("setProgressTo  ","setProgressTo "+setProgressTo);
        Log.e("ppm  ","ppm value "+ppm);

        _valuePPM = (int) ppm;
        //setProgressTo = (700/35)*ppm;
        // Log.i("SETPROGRESSTO", "setprogressto is " + setProgressTo);
        //Log.i("ROUNDEDANDPROGRESS", "rouded = " + ppm + "  ;  progress = " + setProgressTo);

        //avinash
    /*    int progress = mPpmSlider.getProgress();
        mPpmSlider.setProgress(0);
        mPpmSlider.setMax(700);
        mPpmSlider.setProgress((int) setProgressTo);
        mPpmSlider.UpdateThumb();
        vertSliderAction();*/

        // mTestPpm.setText(ppm+"");
    }


    private double findPeakPPM() {
        double peaked = lastPeakRecording;
//    NSArray *recordingscopy = [recordings copy];
//    for(TimeReading *t in recordingscopy)
//    {
//        if([t sampleRate] > peaked && [t sampleRate] <= 9000)
//        {
//            peaked = [t sampleRate];
//        }
//    }

        Log.i(ORDERTAG, "lastPeakRecording " + lastPeakRecording);
        // Log.i("CURRENT","currrent freq = "+currentFrequency);
        if (currentFrequency > lastPeakRecording && currentFrequency <= 9000) {
            lastPeakRecording = currentFrequency;
            peaked = lastPeakRecording;
        }
        if (peaked >= beforeRecordingCurrentFrequency) {
//            Log.i(ORDERTAG,"peaked "+peaked);
//            Log.i(ORDERTAG,"beforeRecordingCurrentFrequency "+beforeRecordingCurrentFrequency);
//            Log.i(ORDERTAG,"scaling "+scaling);
            peaked = peaked - beforeRecordingCurrentFrequency;
            peaked = (peaked * 10) / scaling;//this scales the sampleRate to PPM (0-100 PPM)
        } else {
            peaked = 0.0;
        }
        //Log.i("current ","peaked is "+peaked);
        Log.i(ORDERTAG, "Frequency " + currentFrequency);
        return peaked;
    }


    private void addBeforeRecordingFrequencyToInitialOffsetRecording() {
        if (beforeRecordingCurrentFrequency > 700 && beforeRecordingCurrentFrequency < 1300) {
            initialOffsetRecordings.add(beforeRecordingCurrentFrequency);

        }
    }

    private class RecordAudio extends AsyncTask<Void, Integer, Boolean> {

        @Override
        protected Boolean doInBackground(Void... params) {

            Log.i("AUDIO", "Record Audio: do InBackground");
            int bufferSize = AudioRecord.getMinBufferSize(sampleRate,
                    channelConfiguration, audioEncoding);

            if(bufferSize <0)
            {
                sampleRateUnsupported = true;
                return  false;
/*
                sampleRate = 4800;
                bufferSize = AudioRecord.getMinBufferSize(sampleRate,
                        channelConfiguration, audioEncoding);*/
            }

            sampleRateOverBlockSize = sampleRate / blockSize;

            audioRecord = new AudioRecord(
                    MediaRecorder.AudioSource.DEFAULT, sampleRate,
                    channelConfiguration, audioEncoding, bufferSize);
            int bufferReadResult;
            short[] buffer = new short[blockSize];
            double[] toTransform = new double[blockSize];

            try {
                audioRecord.startRecording();
            } catch (IllegalStateException e) {
                Log.e("Recording failed", e.toString());

            }

            Log.i("maxBuff", Integer.toString(bufferSize));
            Log.i("maxBBlock", Integer.toString(blockSize));
            Log.i("maxfOverBlockSize", Double.toString(sampleRateOverBlockSize));

//            String frequencyCommaSeperated = "";
//            String meanCommaSeperated5 = "";
//            String meanCommaSeperated10 = "";
//            String meanCommaSeperated15 = "";
//            String meanCommaSeperated20= "";
//            String each5Increase = "";
//            String each10Increase = "";
//            String each20Increase = "";
//
//            String each2_5Increase = "";
//            String each2_10Increase = "";


            while (started) {

                if (isCancelled() || (CANCELLED_FLAG == true)) {

                    started = false;
                    //publishProgress(cancelledResult);
                    Log.d("doInBackground", "Cancelling the RecordTask");
                    break;
                } else {
                    bufferReadResult = -33;


                    bufferReadResult = audioRecord.read(buffer, 0, blockSize);

                    Log.i("maxBuffRead", Integer.toString(bufferReadResult));

                    boolean newArrays = false;
                    if (bufferReadResult > 0) {
                        if (blockSize != bufferReadResult) {
                            blockSize = bufferReadResult;
                            buffer = new short[blockSize];
                            toTransform = new double[blockSize];

                            transformer = new RealDoubleFFT(blockSize);
                            newArrays = true;
                            Log.i("maxBlocksize", Integer.toString(blockSize));
                        }
                    } else if (blockSize > 1024) {
                        if (blockSize != bufferReadResult) {
                            blockSize -= 8;//reduce down for next time
                            buffer = new short[blockSize];
                            toTransform = new double[blockSize];

                            transformer = new RealDoubleFFT(blockSize);
                            newArrays = true;
                            Log.i("maxBlocksize", Integer.toString(blockSize));
                        }
                    } else {
                        Log.i("maxBlocksize", Integer.toString(blockSize));
                    }
                    Log.i("maxBlocksizealways", Integer.toString(blockSize));


                    if (newArrays == false && bufferReadResult > 0) {
                        int mPeakPos = 0;
                        double mMaxFFTSample = -150.0;

                        for (int i = 0; i < blockSize && i < bufferReadResult; i++) {
                            toTransform[i] = (double) buffer[i] / 32768.0; // signed 16 bit

                        }

                        transformer.ft(toTransform);

                        sampleRateOverBlockSize = sampleRate / bufferReadResult;


                        for (int i = 0; i < toTransform.length; i++) {
                            int x = i;
                            double vval = (double) (toTransform[i] * 10);
                            int upy = 150;
                            //Log.i("SETTT", "X: " + i + " downy: " + downy + " upy: " + upy);

                            if (vval > mMaxFFTSample) {
                                mMaxFFTSample = vval;
                                //mMag = mMaxFFTSample;
                                mPeakPos = i;
                            }

                        }
                        double mFreq = (sampleRateOverBlockSize * mPeakPos) / 2;


                        double myFreq = ((sampleRate / 2) / bufferReadResult) * mPeakPos;

                        //frequencyCommaSeperated += Double.toString(myFreq) +",";
                        counter++;
                        recentReadings[recentReadingPosition] = (int) myFreq;
                        recentReadings2[recentReadingPosition2] = (int) myFreq;

                        recentReadingPosition++;
                        recentReadingPosition2++;
                        if (recentReadingPosition % 5 == 0)//every five
                        {


                            //check

                            if (counter >= 20) {
                                //Log.i("maxlist", frequencyCommaSeperated);
                                Arrays.sort(recentReadings, new Comparator<Integer>() {
                                    @Override
                                    public int compare(Integer x, Integer y) {
                                        return x - y;
                                    }
                                });

                                int theMean = recentReadings[9];

                                publishProgress(theMean);

/*      debuging and logging, trials
                                Arrays.sort(recentReadings2, new Comparator<Integer>() {
                                    @Override
                                    public int compare(Integer x, Integer y) {
                                        return x - y;
                                    }
                                });

                                int theMean2 = recentReadings2[4];

                                meanCommaSeperated5 += Double.toString(theMean) +",";
                                Log.i("maxlistMean5", meanCommaSeperated5);


                                if(theMean > maxAt5)
                                {
                                    maxAt5 = theMean;
                                    each5Increase += maxAt5 + ", ";
                                }
                                if(theMean2 >max2At5)
                                {
                                    max2At5 = theMean2;
                                    each2_5Increase += max2At5 + ", ";
                                }


                                Log.i("maxAt5"," "+ maxAt5);
                                Log.i("maxAt2_5"," "+ max2At5);
                                if(recentReadingPosition % 10 ==0 )
                                {
                                    meanCommaSeperated10 += Double.toString(theMean) +",";
                                    Log.i("maxlistMean10", meanCommaSeperated10);

                                    if(theMean > maxAt10)
                                    {
                                        maxAt10 = theMean;
                                        each10Increase += maxAt10 + ", ";
                                    }

                                    if(theMean2 >max2At10)
                                    {
                                        max2At10 = theMean2;
                                        each2_10Increase += max2At10 + ", ";

                                    }

                                    Log.i("maxAt10"," "+ maxAt10);
                                    Log.i("maxAt2_10"," "+ max2At10);
                                }
                                else
                                {
                                    meanCommaSeperated10 +=  ", ";
                                }



                                if(recentReadingPosition %20 ==0)
                                {
                                    meanCommaSeperated20 += Double.toString(theMean) +",";
                                    Log.i("maxlistMean20", meanCommaSeperated20);
                                    if(theMean > maxAt20)
                                    {
                                        maxAt20 = theMean;
                                        each20Increase += maxAt20 + ", ";
                                    }


                                    Log.i("maxAt20"," "+ maxAt20);


                                    Log.i("maxlisteach5Increase", each5Increase);
                                    Log.i("maxlisteach10Increase", each10Increase);
                                    Log.i("maxlisteach20Increase", each20Increase);
                                    Log.i("maxlisteach2_5Increase", each2_5Increase);
                                    Log.i("maxlisteach2_10Increase", each2_10Increase);
                                }
                                else
                                {
                                    meanCommaSeperated20 +=  ", ";
                                }

                                Log.i("MAXSETTT4", "VALat4: " + theMean);


                                Log.i("VALAT2", "VALat2: " + recentReadings[2]);
                                Log.i("VALAT3", "VALat3: " + recentReadings[3]);
                                Log.i("VALAT4", "VALat4: " + recentReadings[4]);
                                Log.i("VALAT5", "VALat5: " + recentReadings[5]);
                                Log.i("VALAT6", "VALat6: " + recentReadings[6]);


                                if(lagList.size() > 4) {
                                    Integer[] last4 = new Integer[4];
                                    last4[0] = lagList.get(lagList.size() -4);
                                    last4[1]  = lagList.get(lagList.size() -3);
                                    last4[2]  = lagList.get(lagList.size() -2);
                                    last4[3]  = lagList.get(lagList.size() -1);


                                    ArrayList<Integer> indexOutOfBounds = new ArrayList<Integer>();

                                    int sendThisVal = last4[0];
                                    for(int i=0; i < last4.length -1;i++) {

                                        int diff1 = last4[i+1] - last4[i];
                                        if (diff1 < 0) diff1 = diff1 * -1;

                                        double percent = ((double) diff1 / (double) last4[i]) * 100;
                                        if(percent >20)
                                        {
                                            indexOutOfBounds.add(i);
                                        }

                                        Log.i("LAG", "val"+i+": " + last4[0]);
                                        Log.i("LAG", "diff"+i+": " + diff1);
                                        Log.i("LAG", "percent"+i+": " + percent);

                                    }


                                    if(sendThisVal <2300) {
                                       // publishProgress(sendThisVal);
                                    }
                                }
*/
                                if (counter > 100000) {
                                    counter = 300;
                                }
                            }


                        } else {
//                            meanCommaSeperated5 +=   ", ";
//                            meanCommaSeperated10 +=  ", ";
//                            meanCommaSeperated20 +=  ", ";
                        }
                        if (recentReadingPosition == recentReadingLength) {
                            recentReadingPosition = 0;
                        }

                        if (recentReadingPosition2 == recentReadingLength2) {
                            recentReadingPosition2 = 0;
                        }

                        Log.i("maxFmyFreq", Double.toString(myFreq));
                        Log.i("maxFmFreq", Double.toString(mFreq));
//                        Log.i("MAXSETTT", "I:" + mPeakPos + " FREQ: " + mFreq + " MAG: " + mMaxFFTSample);
//                        Log.i("MAXSETTT", "I:" + mPeakPos2 + " FREQ2: " + mFreq2 + " MAG2: " + mMaxFFTSample2);
//                        Log.i("MAXSETTT", "I:" + mPeakPos3 + " FREQ3: " + mFreq3 + " MAG3: " + mMaxFFTSample3);

                    }
                }

            }
            return true;
        }


        @Override
        protected void onProgressUpdate(Integer... progress) {
            Log.e("RecordingProgress", "Displaying in progress");


            Log.i("AUDIO", "Record Audio: onProgressUpdate val: "+progress[0]);
            // Log.i("SMOKERLYZER","x is "+x);
            if (ignoreReadings == false) {
                currentFrequency = (int) progress[0];
                updateFrequencyLabel();
            } else if (addToInitialOffset) {
                beforeRecordingCurrentFrequency = (int) progress[0];
                addBeforeRecordingFrequencyToInitialOffsetRecording();
            } else if (countdown > 9)//ios 6
            {

                beforeRecordingCurrentFrequency = (int) progress[0];
//                    if (x > highestFreq && letDeviceGetreadyBeforeComparingCount > 50) {
//                        highestFreq = x;
//                        highesPpm = highestFreq - x;
//                        highesPpm = (highesPpm * 10) / scaling;
//                        mTestPpm.setText("ppm: " + highesPpm);
//                    }
            }
//                mTestFrequency.setText(x + "");

            letDeviceGetreadyBeforeComparingCount++;

            //pitchLabel.setText ("freq: " + x);


            //showFrequency.setText( Integer.toString((int)progress[0]));


        }

        @Override
        protected void onPostExecute(Boolean result) {
            super.onPostExecute(result);

            Log.i("AUDIO", "Record Audio: onPostExecute");
            try {
                if (audioRecord != null) {
                    audioRecord.stop();
                    Log.i("AUDIO", " audioRecord.stop() fro onPOstExecute");
                }
            } catch (IllegalStateException e) {
                Log.e("Stop failed", e.toString());

            }
            try {
                if (mPlayer.isPlaying() == true) {
                    mPlayer.reset();
                    Log.i("AUDIO", " mPlayer.reset() from onPostExecute");

                }
            } catch (Exception ex) {

            }


        }
    }





}
