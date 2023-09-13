package com.example.tuya_app_sdk_plugin

import android.app.Application
import android.content.ContentValues.TAG
import android.content.Context
import androidx.annotation.NonNull
import com.thingclips.smart.android.user.api.ILoginCallback
import com.thingclips.smart.android.user.api.ILogoutCallback
import com.thingclips.smart.android.user.bean.User
import com.thingclips.smart.home.sdk.ThingHomeSdk
import com.thingclips.smart.home.sdk.builder.ActivatorBuilder
import com.thingclips.smart.sdk.api.IThingActivator
import com.thingclips.smart.sdk.api.IThingSmartActivatorListener
import com.thingclips.smart.sdk.bean.DeviceBean
import com.thingclips.smart.sdk.enums.ActivatorModelEnum
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TuyaAppSdkPlugin */
class TuyaAppSdkPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var thingActivator: IThingActivator? = null
  private var applicationContext: Context? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext

    ThingHomeSdk.init(applicationContext as Application)

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tuya_app_sdk_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "loginWithTicket" -> loginWithTicket(call, result)
      "pairingDeviceAPMode" -> pairingDeviceAPMode(call, result)
      else -> result.notImplemented()
    }
  }

  private fun loginWithTicket(call: MethodCall, result: Result) {
    val ticket = call.argument<String>("ticket") ?: ""

    if (ticket.isNotEmpty()) {
      ThingHomeSdk.getUserInstance().loginWithTicket(ticket, object : ILoginCallback {
        override fun onSuccess(user: User?) {
          result.success("SUCCESS")
        }

        override fun onError(code: String?, error: String?) {
          result.error(
            "LOGIN_ERROR",
            error,
            null
          )
        }
      })
    } else {
      result.error(
        "ARGUMENTS_ERROR",
        "Arguments missing.",
        null
      )
    }
  }

  private fun pairingDeviceAPMode(call: MethodCall, result: Result) {
    val ssid = call.argument<String>("ssid") ?: ""
    val password = call.argument<String>("password") ?: ""
    val token = call.argument<String>("token") ?: ""
    val timeOut = call.argument<Int?>("time_out")?.toLong() ?: 60

    if (ssid.isNotEmpty() && password.isNotEmpty() && token.isNotEmpty()) {
      val builder =  ActivatorBuilder()
        .setContext(applicationContext)
        .setSsid(ssid)
        .setPassword(password)
        .setActivatorModel(ActivatorModelEnum.THING_AP)
        .setTimeOut(timeOut)
        .setToken(token)
        .setListener(object : IThingSmartActivatorListener {
          override fun onError(errorCode: String, errorMsg: String) {
            result.error(
              errorCode,
              errorMsg,
              null
            )
          }

          override fun onActiveSuccess(devResp: DeviceBean?) {
            result.success("SUCCESS")
          }

          override fun onStep(step: String?, data: Any?) {
            Log.i(TAG, "$step --> $data")
          }
        })

      thingActivator = ThingHomeSdk.getActivatorInstance().newActivator(builder)
      thingActivator?.start()
    } else {
      result.error(
        "ARGUMENTS_ERROR",
        "Arguments missing.",
        null
      )
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
