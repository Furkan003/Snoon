package com.furka.snoon

import android.app.LocaleManager
import android.content.Context
import android.os.Build
import android.os.LocaleList
import java.util.Locale

object LocaleHelper {
    private const val PREFS = "snoon_locale"
    private const val LANGUAGE = "language_code"
    private val supported = setOf("tr", "en", "de", "es", "fr", "it", "pt")

    fun set(context: Context, languageCode: String) {
        val code = languageCode.takeIf(supported::contains) ?: "en"
        val storage = context.createDeviceProtectedStorageContext()
        storage.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .putString(LANGUAGE, code)
            .apply()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.getSystemService(LocaleManager::class.java)
                .applicationLocales = LocaleList.forLanguageTags(code)
        }
    }

    fun wrap(context: Context): Context {
        val storage = context.createDeviceProtectedStorageContext()
        val code = storage.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .getString(LANGUAGE, null)
            ?.takeIf(supported::contains)
            ?: return context
        val configuration = context.resources.configuration
        configuration.setLocale(Locale.forLanguageTag(code))
        configuration.setLayoutDirection(Locale.forLanguageTag(code))
        return context.createConfigurationContext(configuration)
    }
}
