package com.furka.snoon

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter

/**
 * Quick Settings tile showing the next alarm; tapping it opens Snoon.
 *
 * Reads the scheduler records directly, so it works without the Flutter engine.
 */
class NextAlarmTileService : TileService() {
    override fun onStartListening() {
        super.onStartListening()
        val strings = LocaleHelper.wrap(this)
        val next = AlarmScheduler.nextAlarm(this)
        val summary = if (next == null) {
            strings.getString(R.string.widget_no_alarm)
        } else {
            Instant.ofEpochMilli(next.second)
                .atZone(ZoneId.systemDefault())
                .format(DateTimeFormatter.ofPattern("HH:mm"))
        }
        qsTile?.apply {
            state = if (next == null) Tile.STATE_INACTIVE else Tile.STATE_ACTIVE
            // Tile subtitles arrived in Android 10; below that the label has to
            // carry the time itself.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                label = strings.getString(R.string.app_name)
                subtitle = summary
            } else {
                label = summary
            }
            updateTile()
        }
    }

    // Below Android 14 the Intent overload is the only way to collapse the
    // shade, so the deprecation warning is expected on that path.
    @SuppressLint("StartActivityAndCollapseDeprecated")
    override fun onClick() {
        super.onClick()
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        // Android 14 replaced the Intent overload with a PendingIntent one.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startActivityAndCollapse(
                PendingIntent.getActivity(
                    this,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or
                        PendingIntent.FLAG_IMMUTABLE,
                ),
            )
        } else {
            @Suppress("DEPRECATION")
            startActivityAndCollapse(intent)
        }
    }
}
