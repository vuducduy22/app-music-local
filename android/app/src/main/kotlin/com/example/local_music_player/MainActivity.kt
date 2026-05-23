package com.example.local_music_player

import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.security.MessageDigest

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "copyToCache" -> {
                    val uriString = call.argument<String>("uri")
                    val fileName = call.argument<String>("fileName")
                    if (uriString == null || fileName == null) {
                        result.error("ARG", "uri and fileName required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val path = copyToCache(uriString, fileName)
                        result.success(path)
                    } catch (e: Exception) {
                        result.error("COPY_FAILED", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun copyToCache(uriString: String, fileName: String): String {
        val uri = Uri.parse(uriString)
        val cacheDir = File(cacheDir, "playback_cache")
        if (!cacheDir.exists()) {
            cacheDir.mkdirs()
        }
        val outFile = File(cacheDir, cacheFileName(uriString, fileName))
        if (outFile.exists() && outFile.length() > 0L) {
            return outFile.absolutePath
        }
        contentResolver.openInputStream(uri).use { input ->
            if (input == null) {
                throw Exception("Cannot open input stream for $uriString")
            }
            FileOutputStream(outFile).use { output ->
                input.copyTo(output)
            }
        }
        return outFile.absolutePath
    }

    private fun cacheFileName(uriString: String, fileName: String): String {
        val hash = md5(uriString)
        val safe = fileName.replace(Regex("[\\\\/:*?\"<>|]"), "_")
        return "${hash}_$safe"
    }

    private fun md5(value: String): String {
        val digest = MessageDigest.getInstance("MD5")
        val bytes = digest.digest(value.toByteArray(Charsets.UTF_8))
        return bytes.joinToString("") { byte -> "%02x".format(byte) }
    }

    companion object {
        private const val CHANNEL = "com.example.local_music_player/content_uri"
    }
}
