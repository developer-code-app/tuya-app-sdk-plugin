package com.example.poc_smart_life_flutter_sdk_plugin_example

import android.app.Application
import com.example.tuya_app_sdk_plugin.TuyaAppSdkPlugin

class BaseApplication : Application() { 
    override fun onCreate() {
        super.onCreate()

        // TuyaAppSdkPlugin.setupTuyaSDK(this)
    }

    override fun onTerminate() {
        super.onTerminate()

        TuyaAppSdkPlugin.destroy()
    }
}