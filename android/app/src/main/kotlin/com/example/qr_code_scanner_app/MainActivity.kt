package com.example.qr_code_scanner_app

import android.content.Context
import android.content.Intent
import android.net.wifi.WifiConfiguration
import android.net.wifi.WifiManager
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/wifi"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openWifiSettings" -> {
                    openWifiSettings()
                    result.success("Opened Wi-Fi settings")
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun openWifiSettings() {
        val intent = Intent(Settings.ACTION_WIFI_SETTINGS)
        startActivity(intent)
    }
}

// package com.example.qr_code_scanner_app

// import android.content.Context
// import android.content.Intent
// import android.net.wifi.WifiConfiguration
// import android.net.wifi.WifiManager
// import android.provider.Settings
// import android.os.Bundle
// import androidx.annotation.NonNull
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel

// class MainActivity : FlutterActivity() {
//     private val WIFI_CHANNEL = "samples.flutter.dev/wifi"
//     private val INTENT_CHANNEL = "com.example.qrcode/intent"

//     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)
        
//         // Wi-Fi settings channel
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIFI_CHANNEL).setMethodCallHandler { call, result ->
//             when (call.method) {
//                 "openWifiSettings" -> {
//                     openWifiSettings()
//                     result.success("Opened Wi-Fi settings")
//                 }
//                 else -> result.notImplemented()
//             }
//         }
        
//         // Intent data channel
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INTENT_CHANNEL).setMethodCallHandler { call, result ->
//             if (call.method == "getIntentData") {
//                 val intent: Intent? = intent
//                 if (intent?.action == Intent.ACTION_SEND && intent.type?.startsWith("image/") == true) {
//                     val imageUri = intent.getParcelableExtra<android.net.Uri>(Intent.EXTRA_STREAM)
//                     result.success(imageUri.toString())
//                 } else {
//                     result.success(null)
//                 }
//             } else {
//                 result.notImplemented()
//             }
//         }
//     }

//     // Function to open Wi-Fi settings
//     private fun openWifiSettings() {
//         val intent = Intent(Settings.ACTION_WIFI_SETTINGS)
//         startActivity(intent)
//     }
// }
