
package com.reactlibrary;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.media.AudioManager;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;
import com.reactlibrary.smokerlyzer.audio.SmokerLyzerAudio;
import com.reactlibrary.smokerlyzer.callback.AudioCallBack;
import com.reactlibrary.smokerlyzer.model.DataModel;

import java.util.Timer;

public class RNBridgeraSmokerlyzerModule extends ReactContextBaseJavaModule implements LifecycleEventListener {

  private final ReactApplicationContext reactContext;
  Callback callback;

  int counter = 0;
  CountDownTimer mBeginTimer;
  SmokerLyzerAudio smokerLyzerAudio;

  boolean isPermissionInvoked = false;
  boolean isDeviceMode = false;
  boolean isBroadCastRegistered = false;

 public static  int constructorCount=0;
  private static final String ACTION_HEADSET_PLUG = (android.os.Build.VERSION.SDK_INT >= 21) ? AudioManager.ACTION_HEADSET_PLUG : Intent.ACTION_HEADSET_PLUG;


//  public RNBridgeraSmokerlyzerModule(ReactApplicationContext reactContext) {
//    super(reactContext);
//    this.reactContext = reactContext;
//  }


  public RNBridgeraSmokerlyzerModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.reactContext.addLifecycleEventListener(this);
    constructorCount=1;
    // this.reactContext.addActivityEventListener(this);
    unRegisterReceiver();

  }
  @Override
  public String getName() {
    return "RNBridgeraSmokerlyzer";
  }



  @ReactMethod
  public void getAllCallBack(Callback callback) {


    //callback.invoke(orientationInt, null);
    //} else {
    callback.invoke(null, "hey");
    // }
  }


  @ReactMethod
  public void startTest(Callback callback){

   //Toast.makeText(getReactApplicationContext(),msg,Toast.LENGTH_SHORT).show();

    //callback.invoke("Done Toast Prasun");
    smokerLyzerAudio.checkAudioPermission();
    smokerLyzerAudio.startCountDown();
  }

//    @ReactMethod
//    public void setScalingFactor(String ){
//
//        //Toast.makeText(getReactApplicationContext(),msg,Toast.LENGTH_SHORT).show();
//
//        //callback.invoke("Done Toast Prasun");
//        smokerLyzerAudio.checkAudioPermission();
//        smokerLyzerAudio.startCountDown();
//    }



  @ReactMethod
  public void onSmokeDestroy(Callback callback){

    if(smokerLyzerAudio!=null) {
      smokerLyzerAudio.stopAudio();
      smokerLyzerAudio.stopPlayer();

    }

    smokerLyzerAudio = null;
    constructorCount = 1;

    unRegisterReceiver();
    //Toast.makeText(getReactApplicationContext(),"Destroy",Toast.LENGTH_SHORT);
    callback.invoke("Done Destroy");
  }




  public void notifyDataChange(String _value){

    //this.callback.invoke("callReactNativeCode");
    // counter++;


    String smokerlyzer =_value;

    WritableMap params = Arguments.createMap();
    params.putString("smokerlyzer", smokerlyzer);
    if (reactContext.hasActiveCatalystInstance()) {
      reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
              .emit("smokerlyzerDidChange", params);
    }
  }
  @ReactMethod
  public void registerCallBack(){


    //   callback.invoke("callback registered");

    if (smokerLyzerAudio==null)
    {
      smokerLyzerAudio = new SmokerLyzerAudio(getCurrentActivity(), audioCallBack);


    }
    if( smokerLyzerAudio.checkAudioPermission()<0)
    {
      isPermissionInvoked = true;
    } else if ( smokerLyzerAudio.checkTelephonyPermission()<0)
    {
      isPermissionInvoked = true;
    } else {
      isPermissionInvoked=false;
    }



//    if (isPermissionInvoked==false&& isBroadCastRegistered==false)
//    {
      unRegisterReceiver();
      registerReceiver();
  //  }

  }  @ReactMethod
  public void registerCallBack(int scalingFactor){


    //   callback.invoke("callback registered");

    if (smokerLyzerAudio==null)
    {
      smokerLyzerAudio = new SmokerLyzerAudio(getCurrentActivity(), audioCallBack);
      smokerLyzerAudio.setScalingFactor(scalingFactor);


    }
    if( smokerLyzerAudio.checkAudioPermission()<0)
    {
      isPermissionInvoked = true;
    } else if ( smokerLyzerAudio.checkTelephonyPermission()<0)
    {
      isPermissionInvoked = true;
    } else {
      isPermissionInvoked=false;
    }



//    if (isPermissionInvoked==false&& isBroadCastRegistered==false)
//    {
      unRegisterReceiver();
      registerReceiver();
  //  }

  }



    AudioCallBack audioCallBack  = new AudioCallBack() {
        @Override
        public void notifyDataSetChange(String mValue) {

            notifyDataChange(mValue);
        }
    };

  @Override
  public void onHostResume() {

    Log.e("","");




    if (smokerLyzerAudio!=null) {
      //smokerLyzerAudio._onResume();

      if (isPermissionInvoked) {

        if (smokerLyzerAudio.checkAudioPermission() < 0) {
          isPermissionInvoked = true;
        } else if (smokerLyzerAudio.checkTelephonyPermission() < 0) {
          isPermissionInvoked = true;
        } else {
          isPermissionInvoked = false;
        }

      } else if (smokerLyzerAudio.checkTelephonyPermission() < 0) {
        if (smokerLyzerAudio.checkTelephonyPermission() < 0) {
          isPermissionInvoked = true;
        } else if (smokerLyzerAudio.checkAudioPermission() < 0) {
          isPermissionInvoked = true;
        } else {
          isPermissionInvoked = false;
        }

      } else {
        isPermissionInvoked = false;

      }
    }

   // registerReceiver();

  }

  @Override
  public void onHostPause() {


  }

  @Override
  public void onHostDestroy() {

   // unRegisterReceiver();

  }

  public void unRegisterReceiver(){


    final Activity activity = getCurrentActivity();
    if (smokerLyzerAudio!=null) {

      // smokerLyzerAudio._onPause();
    }

    if (activity != null) {

      Log.e("", "");
      if (mReceiver != null) {
        Log.i("CYCLE", "unregister m receiver");
        //LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(mReceiver);

        try {

          isBroadCastRegistered = false;
          activity.unregisterReceiver(mReceiver);
        } catch (Exception e)
        {

        }

      }
    }
  }

  public void registerReceiver(){


    final Activity activity = getCurrentActivity();

    if (activity != null) {

      IntentFilter filter = new IntentFilter();
      filter.addAction(Intent.ACTION_HEADSET_PLUG);

      try {
        isBroadCastRegistered = true;

        activity.registerReceiver(mReceiver, filter);
      } catch (Exception e)
      {
        e.printStackTrace();
      }
    }
  }


  //detects changes in jack plugged unplugged
  private final BroadcastReceiver mReceiver = new BroadcastReceiver() //here fourth
  {
    @Override
    public void onReceive(Context context, Intent intent) {

      // Log.i(ORDERTAG, "Broadcast receiver");
      final String action = intent.getAction();

        DataModel dataModel = new DataModel();
        DataModel.DataBean dataBean = new DataModel.DataBean();



      Log.i("AUDIO", "stopAudio()  from broadcast receiver on receive");
      if(smokerLyzerAudio!=null) {
        smokerLyzerAudio.stopAudio();
        smokerLyzerAudio.stopPlayer();

      }


  /*    if (alreadyTakenReading) {
        Log.i("AUDIO", "Broadcast receiver: alreadyTakenReading return");
        return;
      }
*/
      isDeviceMode = false;
      if (Intent.ACTION_HEADSET_PLUG.equals(action)) {
        Log.d("AUDIO", "Headset jack plugged in state: " + intent.getIntExtra("state", -1));
        Log.d("AUDIO", "Headset microphone: " + intent.getIntExtra("microphone", -1));
        int isMicAvailable = intent.getIntExtra("microphone", -1);
        int isJackPluggedIn = intent.getIntExtra("state", -1);
        if (isMicAvailable == 1 && isJackPluggedIn == 1) {
          isDeviceMode = true;
        }
      }

      if (smokerLyzerAudio!=null)
      {
        smokerLyzerAudio.setDeviceMode(isDeviceMode);
      }

        dataBean.setIsDeviceMode(isDeviceMode);
        dataModel.setKey("deviceMode");
        dataModel.setData(dataBean);

        String _data = new Gson().toJson(dataModel);
        notifyDataChange(_data);

      if (isDeviceMode) {
        //avinash UI update
        // mDeviceStatus.setText(getActivity().getResources().getString(R.string.device_status_connected));


        // setUsingDevice();
        if(smokerLyzerAudio!=null) {
          if (smokerLyzerAudio.checkAudioPermission() == PackageManager.PERMISSION_GRANTED) {
            Log.i("AUDIO", "startAudio()  from broadcast receiver on receive");
            smokerLyzerAudio.startAudio();
              Log.i("ORDERTAG", "broadcast receiver is device mode and about to reset timer");
            smokerLyzerAudio.resetDeviceButtonTimer();
          }
        }
         // notifyDataChange("device status plugged");
      } else {
        //avinash UI update

        //  notifyDataChange("device status unplugged");

        //   mDeviceStatus.setText(getActivity().getResources().getString(R.string.device_status_unplugged));
        // enableButton(mBeginTest, false);
     //   callReactNativeCode(reactContext.getResources().getString(R.string.an_ico_device_is_not_connected));

    /*    AlertDialog.Builder builder = new AlertDialog.Builder(reactContext)
                .setTitle(reactContext.getResources().getString(R.string.connected_device))
                .setMessage(reactContext.getResources().getString(R.string.an_ico_device_is_not_connected))
                .setPositiveButton(reactContext.getResources().getString(R.string.manual), new DialogInterface.OnClickListener() {
                  public void onClick(DialogInterface dialog, int id) {
                    // getActivity().finish();
                    //setManual();
                    dialog.cancel();
                  }
                })
                .setNegativeButton(reactContext.getResources().getString(R.string.ok), new DialogInterface.OnClickListener() {
                  public void onClick(DialogInterface dialog, int id) {
                   // setUsingDevice();
                    dialog.cancel();
                  }
                });
        AlertDialog alert = builder.create();
        alert.show();*/
      }

    }
  };


}