package com.furka.snoon

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle

/**
 * Home-screen widget showing the next alarm.
 *
 * It reads the same records [AlarmScheduler] schedules from, so it never needs
 * the Flutter engine to be running.
 */
class NextAlarmWidget : AppWidgetProvider() {
    companion object {
        const val ACTION_REFRESH = "com.furka.snoon.WIDGET_REFRESH"

        /** Asks every placed widget to redraw. Safe to call from anywhere. */
        fun refresh(context: Context) {
            val manager = AppWidgetManager.getInstance(context) ?: return
            val ids = manager.getAppWidgetIds(
                ComponentName(context, NextAlarmWidget::class.java),
            )
            if (ids.isEmpty()) return
            context.sendBroadcast(
                Intent(context, NextAlarmWidget::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                },
            )
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH) refresh(context)
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val strings = LocaleHelper.wrap(context)
        val next = AlarmScheduler.nextAlarm(context)
        val open = PendingIntent.getActivity(
            context,
            0,
            Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val views = RemoteViews(context.packageName, R.layout.widget_next_alarm)
        if (next == null) {
            views.setTextViewText(
                R.id.widget_time,
                strings.getString(R.string.widget_no_alarm),
            )
            views.setTextViewText(R.id.widget_label, "")
        } else {
            val moment = Instant.ofEpochMilli(next.second).atZone(ZoneId.systemDefault())
            views.setTextViewText(
                R.id.widget_time,
                moment.format(DateTimeFormatter.ofPattern("HH:mm")),
            )
            val day = moment.format(
                DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM)
                    .withLocale(strings.resources.configuration.locales[0]),
            )
            val label = next.first.ifBlank {
                strings.getString(R.string.alarm_default)
            }
            views.setTextViewText(R.id.widget_label, "$day • $label")
        }
        views.setOnClickPendingIntent(R.id.widget_root, open)

        appWidgetIds.forEach { id -> appWidgetManager.updateAppWidget(id, views) }
    }
}
