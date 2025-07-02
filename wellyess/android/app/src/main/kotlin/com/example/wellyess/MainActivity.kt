package com.example.wellyess

import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.view.accessibility.AccessibilityManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "wellyess/accessibility"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
      .setMethodCallHandler { call, result ->
        when (call.method) {
          "isAccessibilityEnabled" -> {
            val am = getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
            result.success(am.isEnabled)
          }
          "openAccessibilitySettings" -> {
            startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
            result.success(null)
          }
          else -> result.notImplemented()
        }
      }
  }
}
