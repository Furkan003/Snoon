package com.furka.snoon

import android.app.AlertDialog
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.text.InputType
import android.view.Gravity
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.Space
import android.widget.TextView
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.OnBackPressedCallback
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import org.json.JSONObject
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.lang.ref.WeakReference
import kotlin.math.sqrt

class AlarmRingingActivity : ComponentActivity(), SensorEventListener {
    companion object {
        private const val STATE_SHAKE_COUNT = "shakeCount"
        private val CLOCK_FORMAT: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm")
        private var activeActivity: WeakReference<AlarmRingingActivity>? = null

        fun finishIfVisible() {
            activeActivity?.get()?.let { activity ->
                activity.runOnUiThread {
                    if (!activity.isFinishing) activity.finishAndRemoveTask()
                }
            }
        }
    }

    private lateinit var record: JSONObject
    private var occurrenceToken = 0L
    private var snoozeCount = 0
    private var kind = AlarmScheduler.KIND_MAIN
    private var sensorManager: SensorManager? = null
    private var shakeCount = 0
    private var lastShakeAt = 0L
    private var dismissButton: Button? = null
    private var clockView: TextView? = null
    private val uiHandler = Handler(Looper.getMainLooper())

    // The screen can stay up for the whole auto-silence window, so the clock
    // has to keep ticking instead of freezing at the moment the alarm fired.
    private val clockTick = object : Runnable {
        override fun run() {
            clockView?.text = LocalTime.now().format(CLOCK_FORMAT)
            uiHandler.postDelayed(this, 1_000L - System.currentTimeMillis() % 1_000L)
        }
    }

    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(LocaleHelper.wrap(newBase))
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Rotating the phone must not throw away shake progress.
        shakeCount = savedInstanceState?.getInt(STATE_SHAKE_COUNT, 0) ?: 0
        readIntent(intent)
        configureLockScreen()
        onBackPressedDispatcher.addCallback(
            this,
            object : OnBackPressedCallback(true) {
                override fun handleOnBackPressed() = Unit
            },
        )
        setContentView(buildContent())
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        readIntent(intent)
        configureLockScreen()
        setContentView(buildContent())
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putInt(STATE_SHAKE_COUNT, shakeCount)
    }

    override fun onStart() {
        super.onStart()
        activeActivity = WeakReference(this)
        uiHandler.post(clockTick)
    }

    override fun onStop() {
        uiHandler.removeCallbacks(clockTick)
        if (activeActivity?.get() === this) activeActivity = null
        super.onStop()
    }

    private fun readIntent(source: Intent) {
        record = try {
            JSONObject(source.getStringExtra("recordJson") ?: "{}")
        } catch (_: Exception) {
            JSONObject()
        }
        occurrenceToken = source.getLongExtra("occurrenceToken", record.optLong("triggerAtMillis", 0L))
        snoozeCount = source.getIntExtra("snoozeCount", 0)
        kind = source.getStringExtra("kind") ?: AlarmScheduler.KIND_MAIN
    }

    private fun configureLockScreen() {
        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON,
        )
        val showOnLockScreen = record.optBoolean("showOnLockScreen", true)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(showOnLockScreen)
            setTurnScreenOn(showOnLockScreen)
            if (showOnLockScreen) {
                getSystemService(KeyguardManager::class.java)
                    .requestDismissKeyguard(this, null)
            }
        } else if (showOnLockScreen) {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
            )
        }
    }

    private fun buildContent(): View {
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(dp(28), dp(20), dp(28), dp(20))
            background = GradientDrawable(
                GradientDrawable.Orientation.TOP_BOTTOM,
                intArrayOf(Color.rgb(28, 20, 48), Color.rgb(7, 8, 13)),
            )
        }
        ViewCompat.setOnApplyWindowInsetsListener(root) { view, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            view.setPadding(
                dp(28) + systemBars.left,
                dp(20) + systemBars.top,
                dp(28) + systemBars.right,
                dp(20) + systemBars.bottom,
            )
            insets
        }
        ViewCompat.requestApplyInsets(root)

        root.addView(TextView(this).apply {
            text = getString(
                if (record.optBoolean("isTimer", false)) {
                    R.string.timer_upper
                } else {
                    R.string.alarm_upper
                },
            )
            setTextColor(Color.rgb(196, 181, 253))
            textSize = 14f
            typeface = Typeface.DEFAULT_BOLD
            letterSpacing = 0.18f
            gravity = Gravity.CENTER
        })
        root.addView(space(32))
        clockView = TextView(this).apply {
            text = LocalTime.now().format(CLOCK_FORMAT)
            setTextColor(Color.WHITE)
            textSize = 72f
            typeface = Typeface.create("sans", Typeface.NORMAL)
            gravity = Gravity.CENTER
        }
        root.addView(clockView)
        root.addView(TextView(this).apply {
            text = record.optString("label", getString(R.string.alarm_default))
            setTextColor(Color.rgb(210, 210, 220))
            textSize = 22f
            gravity = Gravity.CENTER
            setPadding(0, dp(8), 0, 0)
        })

        val task = record.optString("dismissTask", "none")
        if (task != "none") {
            root.addView(space(24))
            root.addView(TextView(this).apply {
                text = if (task == "math") {
                    getString(R.string.complete_math_task)
                } else {
                    getString(R.string.shake_task_instruction)
                }
                setTextColor(Color.rgb(167, 139, 250))
                textSize = 15f
                gravity = Gravity.CENTER
            })
        }

        root.addView(Space(this), LinearLayout.LayoutParams(1, 0, 1f))

        val isTimer = record.optBoolean("isTimer", false)
        val maxSnoozes = record.optInt("maxSnoozes", 3)
        if (!isTimer && snoozeCount < maxSnoozes) {
            root.addView(Button(this).apply {
                text = getString(
                    R.string.snooze_minutes,
                    record.optInt("snoozeMinutes", 5),
                )
                textSize = 16f
                isAllCaps = false
                setTextColor(Color.WHITE)
                background = roundedBackground(Color.rgb(35, 37, 49), dp(18))
                setOnClickListener { snooze() }
            }, fullWidthParams(64))
            root.addView(space(14))
        }

        dismissButton = Button(this).apply {
            text = if (task == "shake" && shakeCount < 5) {
                getString(R.string.shake_to_dismiss, shakeCount)
            } else {
                getString(R.string.dismiss)
            }
            textSize = 17f
            typeface = Typeface.DEFAULT_BOLD
            isAllCaps = false
            setTextColor(Color.rgb(24, 15, 42))
            background = roundedBackground(Color.rgb(167, 139, 250), dp(18))
            setOnClickListener {
                when (task) {
                    "math" -> showMathTask()
                    "shake" -> {
                        if (shakeCount >= 5) dismissAlarm()
                        else Toast.makeText(
                            this@AlarmRingingActivity,
                            R.string.shake_first,
                            Toast.LENGTH_SHORT,
                        ).show()
                    }
                    else -> dismissAlarm()
                }
            }
        }
        root.addView(dismissButton, fullWidthParams(68))
        return root
    }

    override fun onResume() {
        super.onResume()
        if (::record.isInitialized && record.optString("dismissTask") == "shake") {
            sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
            val accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
            if (accelerometer == null) {
                shakeCount = 5
                dismissButton?.text = getString(R.string.dismiss)
                Toast.makeText(
                    this,
                    getString(R.string.sensor_unavailable),
                    Toast.LENGTH_LONG,
                ).show()
                return
            }
            sensorManager?.registerListener(
                this,
                accelerometer,
                SensorManager.SENSOR_DELAY_UI,
            )
        }
    }

    override fun onPause() {
        sensorManager?.unregisterListener(this)
        super.onPause()
    }

    override fun onSensorChanged(event: SensorEvent) {
        val force = sqrt(
            event.values[0] * event.values[0] +
                event.values[1] * event.values[1] +
                event.values[2] * event.values[2],
        )
        val now = SystemClock.elapsedRealtime()
        if (force > 17f && now - lastShakeAt > 450) {
            lastShakeAt = now
            shakeCount++
            dismissButton?.text = getString(
                R.string.shake_to_dismiss,
                shakeCount.coerceAtMost(5),
            )
            if (shakeCount >= 5) dismissButton?.text = getString(R.string.dismiss)
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit

    /** Question text paired with the answer the user has to type. */
    private fun buildMathTask(): Pair<String, Int> =
        when (record.optString("mathDifficulty", "easy")) {
            "hard" -> {
                val a = (11..19).random()
                val b = (3..9).random()
                val c = (10..49).random()
                "$a × $b + $c = ?" to a * b + c
            }
            "medium" -> {
                val a = (3..12).random()
                val b = (3..12).random()
                "$a × $b = ?" to a * b
            }
            else -> {
                val a = (10..29).random()
                val b = (3..18).random()
                "$a + $b = ?" to a + b
            }
        }

    private fun showMathTask() {
        val (question, answer) = buildMathTask()
        val input = EditText(this).apply {
            inputType = InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_SIGNED
            gravity = Gravity.CENTER
            textSize = 22f
        }
        val dialog = AlertDialog.Builder(this)
            .setTitle(question)
            .setMessage(getString(R.string.math_task_message))
            .setView(input)
            .setNegativeButton(getString(R.string.cancel), null)
            .setPositiveButton(getString(R.string.check_answer), null)
            .create()
        dialog.setOnShowListener {
            dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener {
                if (input.text.toString().toIntOrNull() == answer) {
                    dialog.dismiss()
                    dismissAlarm()
                } else {
                    input.error = getString(R.string.wrong_answer)
                }
            }
        }
        dialog.show()
    }

    private fun dismissAlarm() {
        AlarmScheduler.cancelBackup(this, record.optString("id"), occurrenceToken)
        HistoryStore.add(
            this,
            record.optString("id", "alarm"),
            record.optString("label", getString(R.string.alarm_default)),
            "dismissed",
        )
        stopSound()
        finishAndRemoveTask()
    }

    private fun snooze() {
        val maxSnoozes = record.optInt("maxSnoozes", 3).coerceAtLeast(0)
        if (record.optBoolean("isTimer", false) || snoozeCount >= maxSnoozes) {
            Toast.makeText(this, R.string.max_snoozes_reached, Toast.LENGTH_SHORT)
                .show()
            return
        }
        val minutes = record.optInt("snoozeMinutes", 5)
        AlarmScheduler.cancelBackup(this, record.optString("id"), occurrenceToken)
        AlarmScheduler.suspendRangeUntilSnooze(this, record)
        val trigger = AlarmScheduler.scheduleSnooze(
            this,
            record,
            minutes,
            snoozeCount + 1,
        )
        SnoozeNotification.show(this, record, minutes, trigger)
        HistoryStore.add(
            this,
            record.optString("id", "alarm"),
            record.optString("label", getString(R.string.alarm_default)),
            "snoozed",
        )
        stopSound()
        finishAndRemoveTask()
    }

    private fun showDismissTaskHint() {
        val message = if (record.optString("dismissTask", "none") == "math") {
            R.string.complete_math_task
        } else {
            R.string.shake_task_instruction
        }
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
    }

    private fun stopSound() {
        startService(Intent(this, AlarmSoundService::class.java).apply {
            action = AlarmSoundService.ACTION_STOP
        })
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP || keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
            // Defaults to "volume": returning false below leaves the keys doing
            // their normal job, so a volume press cannot snooze unless the user
            // turned that on in settings.
            return when (record.optString("volumeButtonAction", "volume")) {
                "snooze" -> {
                    snooze()
                    true
                }
                "dismiss" -> {
                    // A volume press must not bypass the dismissal task, but it
                    // should say why nothing happened instead of staying silent.
                    if (record.optString("dismissTask", "none") == "none") {
                        dismissAlarm()
                    } else {
                        showDismissTaskHint()
                    }
                    true
                }
                else -> super.onKeyDown(keyCode, event)
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    private fun space(height: Int) = Space(this).apply {
        layoutParams = LinearLayout.LayoutParams(1, dp(height))
    }

    private fun fullWidthParams(height: Int) = LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        dp(height),
    )

    private fun roundedBackground(color: Int, radius: Int) = GradientDrawable().apply {
        setColor(color)
        cornerRadius = radius.toFloat()
    }

    private fun dp(value: Int): Int = (value * resources.displayMetrics.density).toInt()
}
