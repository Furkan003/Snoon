package com.furka.snoon

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.time.Instant

object HistoryStore {
    // Kept for upgrade compatibility with history written by early builds.
    private const val PREFS = "saat2_history"
    private const val EVENTS = "events"

    fun add(
        context: Context,
        alarmId: String,
        label: String,
        action: String,
        disableAlarm: Boolean = false,
    ) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val items = try {
            JSONArray(prefs.getString(EVENTS, "[]"))
        } catch (_: Exception) {
            JSONArray()
        }
        val event = JSONObject().apply {
            put("id", "native-${System.nanoTime()}")
            put("alarmId", alarmId)
            put("label", label)
            put("action", action)
            put("timestamp", Instant.now().toString())
            put("disableAlarm", disableAlarm)
        }
        val updated = JSONArray().put(event)
        for (index in 0 until minOf(items.length(), 299)) updated.put(items.get(index))
        prefs.edit().putString(EVENTS, updated.toString()).apply()
    }

    fun consume(context: Context): List<Map<String, Any?>> {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val items = try {
            JSONArray(prefs.getString(EVENTS, "[]"))
        } catch (_: Exception) {
            JSONArray()
        }
        val result = mutableListOf<Map<String, Any?>>()
        for (index in 0 until items.length()) {
            val item = items.optJSONObject(index) ?: continue
            result.add(
                mapOf(
                    "id" to item.optString("id"),
                    "alarmId" to item.optString("alarmId"),
                    "label" to item.optString("label"),
                    "action" to item.optString("action"),
                    "timestamp" to item.optString("timestamp"),
                    "disableAlarm" to item.optBoolean("disableAlarm", false),
                ),
            )
        }
        prefs.edit().putString(EVENTS, "[]").apply()
        return result
    }
}
