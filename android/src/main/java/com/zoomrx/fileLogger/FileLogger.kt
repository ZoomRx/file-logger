package com.zoomrx.fileLogger

import android.util.Log

import com.getcapacitor.*

@NativePlugin
class FileLogger : Plugin() {

    @PluginMethod
    fun getLoggerIndex(call: PluginCall) {
        Logger.index++
        Log.d("object_check", Logger.index.toString())
    }

    @PluginMethod
    fun log(call: PluginCall) {
        val level = call.getString("level")
        val message = call.getString("message")
        var consoleFunc = level
            when (level) {
                "debug" -> {
                    Logger.debug(message)
                }
                "error" -> {
                    Logger.error(message)
                }
                "warn" -> {
                    Logger.warn(message)
                }
                "info" -> {
                    Logger.info(message)
                }
                else -> {
                    Logger.verbose(message)
                    consoleFunc = "log"
                }
            }
        bridge.webView.evaluateJavascript("console.$consoleFunc((\"${message}\"))", null)
        val ret = JSObject()
        ret.put("success", true)
        call.success(ret)
    }

    @PluginMethod
    fun getLogDirPath(call: PluginCall) {
        val ret = JSObject()
        ret.put("path", "${context.filesDir.absolutePath}/logs")
        call.success(ret)
    }
}