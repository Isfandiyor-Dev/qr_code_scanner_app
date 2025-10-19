package com.isfandiyor.qrscanner

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val WIFI_CHANNEL = "samples.flutter.dev/wifi"
    private val FILE_CHANNEL = "app.channel.shared.data"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIFI_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openWifiSettings" -> {
                        openWifiSettings()
                        result.success("Opened Wi-Fi settings")
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FILE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getFileUri") {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        try {
                            val file = File(path)
                            val uri = FileProvider.getUriForFile(
                                this,
                                "${applicationContext.packageName}.fileprovider",
                                file
                            )

                            val intent = Intent(Intent.ACTION_VIEW)
                            intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
                            intent.setDataAndType(uri, "text/x-vcard")
                            startActivity(intent)

                            result.success(uri.toString())
                        } catch (e: Exception) {
                            result.error("URI_ERROR", e.message, null)
                        }
                    } else {
                        result.error("INVALID_PATH", "File path is null", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun openWifiSettings() {
        val intent = Intent(Settings.ACTION_WIFI_SETTINGS)
        startActivity(intent)
    }
}
