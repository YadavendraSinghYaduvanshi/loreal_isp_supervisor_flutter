package com.cpm.lorealispsupervisorflutter;

import android.net.Uri;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
/*import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;*/

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build.VERSION_CODES;
import android.os.Environment;

import java.io.File;


public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "samples.flutter.io/battery";

    @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);


/* new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {

                if (call.method.equals("getApkInstall")) {
                  int res = getApkInstall();

                  if (res != -1) {
                    result.success(res);
                  } else {
                    result.error("UNAVAILABLE", "Not Installed.", null);
                  }
                } else {
                  result.notImplemented();
                }

              }
            });*/
  }

  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (Build.VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
              registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
              intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }

  private int getApkInstall(){
    Intent i = new Intent(Intent.ACTION_VIEW);
    i.setDataAndType(Uri.fromFile(new File(Environment
                    .getExternalStorageDirectory()
                    + "/download/"
                    + "app.apk")),
            "application/vnd.android.package-archive");
    startActivity(i);

    return 0;
  }
}
