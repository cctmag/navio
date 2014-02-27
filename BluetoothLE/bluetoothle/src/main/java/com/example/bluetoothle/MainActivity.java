package com.example.bluetoothle;

import java.util.Collection;

import com.radiusnetworks.ibeacon.IBeacon;
import com.radiusnetworks.ibeacon.IBeaconConsumer;
import com.radiusnetworks.ibeacon.IBeaconManager;
import com.radiusnetworks.ibeacon.MonitorNotifier;
import com.radiusnetworks.ibeacon.RangeNotifier;
import com.radiusnetworks.ibeacon.Region;

import android.os.Bundle;
import android.os.RemoteException;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;

public class MainActivity extends Activity implements IBeaconConsumer
{
    protected static final String TAG = "RangingActivity";
    private IBeaconManager iBeaconManager = IBeaconManager.getInstanceForApplication(this);

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        iBeaconManager.bind(this);
    }
    @Override
    protected void onDestroy()
    {
        super.onDestroy();
        iBeaconManager.unBind(this);
    }
    @Override
    public void onIBeaconServiceConnect()
    {
        iBeaconManager.setRangeNotifier(new RangeNotifier()
        {
            @Override
            public void didRangeBeaconsInRegion(
                    Collection<IBeacon> iBeacons, Region region)
            {
                if (iBeacons.size() > 0)
                {
                    Log.i(TAG, "The first iBeacon I see is about "+iBeacons.iterator().next().getAccuracy()+" meters away.");
                }
            }
        });

        try
        {
            iBeaconManager.startRangingBeaconsInRegion(new Region("myRangingUniqueId", null, null, null));
        } catch (RemoteException e) {}
    }
}
